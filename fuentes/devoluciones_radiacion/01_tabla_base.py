#!/usr/bin/env python3
"""
01_tabla_base.py — Paso 01 del pipeline (CLAUDE.md)

Pregunta que responde: #1 — ¿la tasa de devolución sube, baja o está estable por
cohorte semanal?

Fecha:  2026-08-13
Autor:  Claude (sesión Johhan Ramirez)

Materializa la tabla base anclada en `fecha_de_radicado`, con cohorte semanal y
censura aplicada. Es la única definición del denominador; ningún análisis aguas abajo
debe re-derivarlo.

ESTADO: la tabla queda construida a medias, a propósito.

El export solo contiene radicaciones DEVUELTAS, así que el numerador está completo y
el denominador no existe. Con eso se puede calcular el conteo de devoluciones por
cohorte, el lag y la censura — pero no el porcentaje.

Para completarla basta un agregado, sin datos de cliente: un CSV
`radicaciones_totales.csv` con dos columnas, `cohorte_semana` (lunes de la semana,
YYYY-MM-DD) y `radicaciones` (entero, TODAS las radicaciones de esa semana, devueltas
y no devueltas). Si el archivo existe, este script calcula la tasa y la deja en la
salida. Si no existe, avisa y emite solo lo calculable.

Salida: `tabla_base.xlsx`
"""

import os

import pandas as pd

FUENTE = "data.xlsx"
SALIDA = "tabla_base.xlsx"
DENOMINADOR = "radicaciones_totales.csv"

# Umbral de censura, en un solo lugar (CLAUDE.md paso 01). Es el p90 del lag
# radicación→devolución medido en `00_perfilado.py`: 14,09 días. Las cohortes más
# recientes que esto todavía no tuvieron tiempo de devolverse y su tasa se vería
# artificialmente baja.
CENSURA_DIAS = 14

# Lags fuera de este rango se excluyen del cálculo de días: 9 filas tienen la
# devolución antes del radicado y 1 tiene 917 días (ver HIPOTESIS.md H-03).
LAG_MIN, LAG_MAX = 0, 180


def construir():
    df = pd.read_excel(FUENTE, sheet_name=0)
    df = df.dropna(subset=["fecha_de_radicado"]).copy()

    df["lag_dias"] = (
        df.fecha_devolucion - df.fecha_de_radicado
    ).dt.total_seconds() / 86400
    df["cohorte_semana"] = df.fecha_de_radicado.dt.to_period("W-MON").dt.start_time

    fecha_corte = df.fecha_devolucion.max()
    limite = fecha_corte - pd.Timedelta(days=CENSURA_DIAS)
    df["censurada"] = df.fecha_de_radicado > limite

    base = pd.DataFrame(
        {
            "radicacion_id": df.radicacion_id,
            "fecha_radicacion": df.fecha_de_radicado,
            "cohorte_semana": df.cohorte_semana,
            "devuelta": True,  # el export solo trae devueltas
            "dias_a_primera_devolucion": df.lag_dias.where(
                df.lag_dias.between(LAG_MIN, LAG_MAX)
            ),
            "tipificacion": df.tipificacion_devolucion,
            "motivo_texto": df.comentario_devoluci_n,
            "censurada": df.censurada,
        }
    )
    return base, fecha_corte, limite


def main():
    base, fecha_corte, limite = construir()
    vigentes = base[~base.censurada]

    print(f"fecha de corte de los datos:      {fecha_corte:%Y-%m-%d}")
    print(f"umbral de censura:                {CENSURA_DIAS} días (p90 del lag)")
    print(f"cohortes válidas hasta:           {limite:%Y-%m-%d}")
    print(f"filas totales:                    {len(base)}")
    print(f"  excluidas por censura:          {int(base.censurada.sum())}")
    print(f"  vigentes:                       {len(vigentes)}")

    semanal = (
        vigentes.groupby("cohorte_semana")
        .agg(
            devoluciones=("radicacion_id", "size"),
            lag_p50=("dias_a_primera_devolucion", "median"),
        )
        .reset_index()
    )

    if os.path.exists(DENOMINADOR):
        den = pd.read_csv(DENOMINADOR, parse_dates=["cohorte_semana"])
        semanal = semanal.merge(den, on="cohorte_semana", how="left")
        semanal["tasa_devolucion"] = semanal.devoluciones / semanal.radicaciones
        n = int(semanal.devoluciones.sum())
        d = int(semanal.radicaciones.sum())
        print(f"\nTASA GLOBAL: {n} / {d} = {100 * n / d:.2f}%")
        print("(numerador / denominador / tasa — CLAUDE.md paso 1x)")
    else:
        semanal["radicaciones"] = pd.NA
        semanal["tasa_devolucion"] = pd.NA
        print(
            f"\nFALTA EL DENOMINADOR: no se encontró '{DENOMINADOR}'.\n"
            "Sin él la tabla base queda con numerador y sin tasa. Ver el docstring:\n"
            "hace falta un CSV con cohorte_semana,radicaciones."
        )

    base.to_excel(SALIDA, index=False)
    semanal.to_csv("tabla_base_semanal.csv", index=False)
    print(f"\nescrito -> {SALIDA} y tabla_base_semanal.csv")
    print("\núltimas 8 cohortes semanales vigentes:")
    print(semanal.tail(8).to_string(index=False))


if __name__ == "__main__":
    main()
