#!/usr/bin/env python3
"""
00_perfilado.py — Paso 00 del pipeline (CLAUDE.md)

Pregunta que responde: ¿qué contiene realmente la fuente, con qué calidad, y
desde qué fecha es comparable? Mecánico, sin interpretación.

Fecha:  2026-08-12
Autor:  Claude (sesión Johhan Ramirez)

Nota de desviación respecto a CLAUDE.md: el pipeline especifica `00_perfilado.sql`
sobre BigQuery, pero la configuración de entorno (proyecto/dataset/tabla) sigue en
TODO y lo único disponible es un export local. Este script perfila ese export.
Cuando se resuelva el acceso a BigQuery hay que reescribirlo como SQL contra la
tabla origen.

Actualización 2026-08-31: fuente reemplazada por `data_20260831.xlsx` (pull nuevo
del mismo query, corte 2026-08-31, entregado como Google Sheet "Nuevos datos").
`data.xlsx` (corte 2026-08-12) queda archivado para trazabilidad de la Iteración 1-2
en BITACORA.md; no se borra. El nuevo export trajo, en una hoja adicional
("Hoja vinculada 1"), el SQL real que lo genera — ver DICCIONARIO.md — lo cual
resuelve parte del TODO de configuración de CLAUDE.md pero NO el bloqueo principal:
sigue sin denominador (`WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL`,
solo devueltas) y sigue sin broker_id/director_comercial/kam.

Uso:  python3 00_perfilado.py > PERFILADO_salida_20260831.txt
"""

import pandas as pd

FUENTE = "data_20260831.xlsx"
HOJA = 0

# Ventana en la que `tipificacion_devolucion` está poblada de forma estable.
# Derivada del perfilado (ver PERFILADO.md), NO un supuesto de negocio.
VENTANA_TIPIF_INICIO = pd.Period("2025-09")
VENTANA_TIPIF_FIN = pd.Period("2026-07")  # 2026-08 es mes parcial (corte 12-ago)


DERIVADAS = ("mes_radicado", "lag_dias")


def cargar():
    df = pd.read_excel(FUENTE, sheet_name=HOJA)
    df["mes_radicado"] = df["fecha_de_radicado"].dt.to_period("M")
    df["lag_dias"] = (
        df["fecha_devolucion"] - df["fecha_de_radicado"]
    ).dt.total_seconds() / 86400
    return df


def seccion(titulo):
    print(f"\n{'=' * 78}\n{titulo}\n{'=' * 78}")


def perfilar(df):
    seccion("1. FORMA Y GRANO")
    print(f"filas: {len(df)}  columnas de origen: {df.shape[1] - len(DERIVADAS)}")
    print(f"radicacion_id únicos: {df.radicacion_id.nunique()}")
    print(f"radicacion_id duplicados: {int(df.radicacion_id.duplicated().sum())}")
    print(f"filas sin fecha_devolucion: {int(df.fecha_devolucion.isna().sum())}")

    seccion("2. NULOS Y CARDINALIDAD POR COLUMNA")
    for c in df.columns:
        if c in DERIVADAS:
            continue
        print(
            f"{c:26s} tipo={str(df[c].dtype):15s} "
            f"nulos={int(df[c].isna().sum()):6d} "
            f"({100 * df[c].isna().mean():5.1f}%) "
            f"distintos={df[c].nunique(dropna=True)}"
        )

    seccion("3. DENSIDAD MENSUAL Y EVOLUCIÓN DE NULOS (por mes de radicado)")
    g = df.groupby("mes_radicado", dropna=False).agg(
        n=("radicacion_id", "size"),
        pct_null_tipificacion=(
            "tipificacion_devolucion",
            lambda s: round(100 * s.isna().mean(), 1),
        ),
        pct_null_comentario=(
            "comentario_devolucion",
            lambda s: round(100 * s.isna().mean(), 1),
        ),
    )
    print(g.to_string())

    seccion("4. COBERTURA CRUZADA DE CAMPOS DE MOTIVO")
    ct = pd.crosstab(
        df.tipificacion_devolucion.notna(),
        df.comentario_devolucion.notna(),
        rownames=["tiene_tipificacion"],
        colnames=["tiene_comentario"],
    )
    print(ct.to_string())
    sin_nada = int(
        (df.tipificacion_devolucion.isna() & df.comentario_devolucion.isna()).sum()
    )
    print(f"\nfilas sin tipificación NI comentario: {sin_nada} "
          f"({100 * sin_nada / len(df):.1f}%)")

    seccion("5. RANGOS DE FECHA E INTEGRIDAD TEMPORAL")
    for c in ("fecha_de_radicado", "fecha_devolucion"):
        print(f"{c:20s} min={df[c].min()}  max={df[c].max()}")
    print(f"\nfecha_de_radicado nula: {int(df.fecha_de_radicado.isna().sum())}")
    print(f"lag negativo (devolución antes de radicado): {int((df.lag_dias < 0).sum())}")
    print(f"lag > 180 días: {int((df.lag_dias > 180).sum())}")

    seccion("6. LAG RADICACIÓN → DEVOLUCIÓN (días)")
    print(
        df.lag_dias.describe(
            percentiles=[0.05, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99]
        ).round(2).to_string()
    )
    print(f"\np90 = {df.lag_dias.quantile(0.90):.2f} días  "
          f"(umbral de censura propuesto, ver CLAUDE.md paso 01)")

    seccion("7. DISTRIBUCIÓN DE LENGTH(comentario_devolucion)")
    txt = df.comentario_devolucion.dropna().astype(str).str.strip()
    largo = txt.str.len()
    palabras = txt.str.split().str.len()
    print(largo.describe(percentiles=[0.05, 0.25, 0.5, 0.75, 0.9, 0.99]).round(1).to_string())
    print(f"\nvacíos tras strip: {int((largo == 0).sum())}")
    print(f"<= 20 caracteres:  {int((largo <= 20).sum())}")
    print(f"1-3 palabras:      {int((palabras <= 3).sum())} "
          f"({100 * (palabras <= 3).mean():.1f}% de los no nulos)")

    seccion("8. VALORES DE tipificacion_devolucion")
    print(df.tipificacion_devolucion.value_counts(dropna=False).to_string())


def composicion_ventana(df):
    """Preguntas #3 y #7, acotadas a la ventana con tipificación confiable.

    Reporta COMPOSICIÓN de devoluciones (share), NO tasa de devolución: el
    export no trae radicaciones no devueltas, así que no hay denominador.
    """
    seccion(f"9. P3/P7 — COMPOSICIÓN EN VENTANA "
            f"{VENTANA_TIPIF_INICIO}..{VENTANA_TIPIF_FIN}")
    w = df[
        (df.mes_radicado >= VENTANA_TIPIF_INICIO)
        & (df.mes_radicado <= VENTANA_TIPIF_FIN)
        & df.tipificacion_devolucion.notna()
    ]
    den = len(w)
    print(f"denominador (devoluciones tipificadas en ventana): {den}\n")
    for k, v in w.tipificacion_devolucion.value_counts().items():
        print(f"{k:35s} {v:5d} / {den} = {100 * v / den:5.1f}%")

    print("\nMix mensual (% de las devoluciones tipificadas de cada mes):")
    pct = pd.crosstab(w.mes_radicado, w.tipificacion_devolucion, normalize="index")
    pct = pct.mul(100).round(1)
    pct["n_mes"] = w.groupby("mes_radicado").size()
    print(pct.to_string())


if __name__ == "__main__":
    datos = cargar()
    perfilar(datos)
    composicion_ventana(datos)
