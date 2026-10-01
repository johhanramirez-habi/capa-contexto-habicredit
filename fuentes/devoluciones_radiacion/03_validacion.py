#!/usr/bin/env python3
"""
03_validacion.py — Paso 03 del pipeline (CLAUDE.md)

Pregunta que responde: ¿qué tan confiable es cada categoría de `02_clasificacion.py`?
Accuracy POR CATEGORÍA, nunca global (CLAUDE.md: "una categoría al 60% manda a
arreglar el problema equivocado y el promedio la esconde").

Fecha:  2026-08-13
Autor:  Claude (sesión Johhan Ramirez)

Dos sets de referencia:

1. **Viejo** (`_labels_1..6.json`): 600 comentarios de `Política documental` sobre el
   pull de 12-ago-2026 (semilla 11), taxonomía de la Iteración 2 (sin `Trámite`,
   `Política` ni `Código o jerga interna del banco` como categorías propias — ese
   contenido cae en `Otros`). Se re-evalúa aquí tal cual, sin recalibrar, para ver si
   la recalibración del léxico (Iteración 5, BITACORA.md) rompió algo que ya
   funcionaba.
2. **Nuevo** (`_labels_new_1..6.json`): 600 comentarios sobre el pull de 31-ago-2026
   (semilla 20260831), con la taxonomía ampliada (incluye `Trámite`, `Política` y
   `Código o jerga interna del banco` como categorías propias, sin colapsar). Es la
   referencia que importa para juzgar la recalibración.

Limitación conocida: ninguna referencia fue etiquetada a mano por Ivan. CLAUDE.md
pide 150 casos etiquetados por él, distintos de los del bootstrapping. Hasta que eso
ocurra, estos números miden acuerdo con otro modelo, no con la verdad de negocio.
"""

import glob
import json

import pandas as pd

import importlib.util

spec = importlib.util.spec_from_file_location("clasif", "02_clasificacion.py")
clasif = importlib.util.module_from_spec(spec)
spec.loader.exec_module(clasif)

# Para el set VIEJO: las tres categorías nuevas no existían en esa referencia:
# allí ese contenido está bajo `Otros`. Para comparar se colapsan a `Otros`.
COLAPSO_VIEJO = {
    clasif.TRAMITE: clasif.OTROS,
    clasif.POLITICA: clasif.OTROS,
    clasif.BANCO_INTERNO: clasif.OTROS,
}
CATEGORIAS_VIEJO = clasif.DOCUMENTALES + [clasif.OTROS]

# Para el set NUEVO: taxonomía completa, sin colapsar.
COLAPSO_NUEVO = {}
CATEGORIAS_NUEVO = clasif.DOCUMENTALES + [
    clasif.TRAMITE,
    clasif.POLITICA,
    clasif.BANCO_INTERNO,
    clasif.OTROS,
]

# El léxico se ajustó mirando estos archivos (más una lectura manual de muestras
# 'Otros', ver BITACORA.md Iteración 5); los de holdout no se tocaron para nada.
# Reportar solo el número global sería reportar el ajuste, no el desempeño.
CALIBRACION_VIEJO = ["_labels_1.json", "_labels_2.json", "_labels_3.json", "_labels_4.json"]
HOLDOUT_VIEJO = ["_labels_5.json", "_labels_6.json"]
CALIBRACION_NUEVO = [
    "_labels_new_1.json", "_labels_new_2.json", "_labels_new_3.json", "_labels_new_4.json",
]
HOLDOUT_NUEVO = ["_labels_new_5.json", "_labels_new_6.json"]


def cargar_referencia(archivos):
    filas = []
    for f in sorted(archivos):
        with open(f) as fh:
            filas.extend(json.load(fh))
    return {int(r["id"]): (set(r["categorias"]), r["primaria"]) for r in filas}


def predecir(ids_validos, colapso):
    # data_20260831.xlsx cubre tanto los ids viejos (labels_1..6) como los nuevos
    # (labels_new_1..6): es un superset de data.xlsx salvo por 1 radicacion_id
    # (ver DICCIONARIO.md, Iteración 3). Se usa una sola fuente para no mezclar
    # dos snapshots del texto en la misma corrida.
    df = pd.read_excel("data_20260831.xlsx", sheet_name=0)
    d = df[df.radicacion_id.isin(ids_validos)][
        ["radicacion_id", "comentario_devolucion"]
    ]
    pred = {}
    for r in d.itertuples(index=False):
        cats, prim = clasif.clasificar(r.comentario_devolucion)
        pred[int(r.radicacion_id)] = (
            {colapso.get(c, c) for c in cats},
            colapso.get(prim, prim),
        )
    return pred


def evaluar(nombre, archivos, categorias_ref, colapso):
    ref = cargar_referencia(archivos)
    pred = predecir(set(ref), colapso)
    ids = [i for i in ref if i in pred]
    print(f"\n### {nombre} — {len(ids)} comentarios")
    print(f"{'categoría':47s} {'sop':>4s} {'prec':>6s} {'rec':>6s} {'F1':>6s}")
    print("-" * 73)
    for cat in categorias_ref:
        tp = sum(1 for i in ids if cat in ref[i][0] and cat in pred[i][0])
        fp = sum(1 for i in ids if cat not in ref[i][0] and cat in pred[i][0])
        fn = sum(1 for i in ids if cat in ref[i][0] and cat not in pred[i][0])
        sop = tp + fn
        prec = tp / (tp + fp) if tp + fp else float("nan")
        rec = tp / sop if sop else float("nan")
        f1 = 2 * prec * rec / (prec + rec) if prec and rec and prec + rec else 0.0
        print(f"{cat:47s} {sop:4d} {prec:6.2f} {rec:6.2f} {f1:6.2f}")

    print("-" * 73)
    print("coincidencia exacta de la categoría primaria: "
          f"{sum(1 for i in ids if ref[i][1] == pred[i][1]) / len(ids):.2%}")
    print("al menos una categoría en común: "
          f"{sum(1 for i in ids if ref[i][0] & pred[i][0]) / len(ids):.2%}")
    solo_otros = sum(1 for i in ids if ref[i][0] == {clasif.OTROS})
    print(f"'Otros' como única categoría EN LA REFERENCIA: "
          f"{solo_otros} / {len(ids)} = {100 * solo_otros / len(ids):.1f}%")


def main():
    print("=" * 73)
    print("SET VIEJO (pull 12-ago, taxonomía Iteración 2) — chequeo de regresión")
    print("=" * 73)
    evaluar("CALIBRACIÓN VIEJA", CALIBRACION_VIEJO, CATEGORIAS_VIEJO, COLAPSO_VIEJO)
    evaluar("HOLDOUT VIEJO", HOLDOUT_VIEJO, CATEGORIAS_VIEJO, COLAPSO_VIEJO)

    print("\n" + "=" * 73)
    print("SET NUEVO (pull 31-ago, taxonomía recalibrada) — el que importa")
    print("=" * 73)
    evaluar("CALIBRACIÓN NUEVA", CALIBRACION_NUEVO, CATEGORIAS_NUEVO, COLAPSO_NUEVO)
    evaluar("HOLDOUT NUEVO", HOLDOUT_NUEVO, CATEGORIAS_NUEVO, COLAPSO_NUEVO)


if __name__ == "__main__":
    main()
