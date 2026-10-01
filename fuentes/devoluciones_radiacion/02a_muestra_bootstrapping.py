#!/usr/bin/env python3
"""
02a_muestra_bootstrapping.py — insumo para el Paso 02 (CLAUDE.md)

Pregunta que responde: ninguna. Genera la muestra de ~200 motivos que Ivan debe
leer ANTES de definir la taxonomía. CLAUDE.md: "Bootstrapping manual primero.
[...] de ahí sale la taxonomía. No al revés."

Fecha:  2026-08-12
Autor:  Claude (sesión Johhan Ramirez)

Estratificación: por mes de radicado, proporcional al volumen, sobre la ventana
con `tipificacion_devolucion` poblada. CLAUDE.md pide estratificar también por
volumen de broker — imposible: el export no trae columna de broker.

SALIDA CON TEXTO LIBRE DE CLIENTES. No versionar (ver .gitignore), no pegar en
tickets, no sacar del entorno.
"""

import pandas as pd

FUENTE = "data.xlsx"
SALIDA = "muestra_bootstrapping_200.csv"
N_OBJETIVO = 200
VENTANA_INICIO = pd.Period("2025-09")
VENTANA_FIN = pd.Period("2026-07")
SEMILLA = 20260812

df = pd.read_excel(FUENTE, sheet_name=0)
df["mes_radicado"] = df["fecha_de_radicado"].dt.to_period("M")

pool = df[
    (df.mes_radicado >= VENTANA_INICIO)
    & (df.mes_radicado <= VENTANA_FIN)
    & df.comentario_devoluci_n.notna()
    & (df.comentario_devoluci_n.astype(str).str.split().str.len() > 3)
].copy()

frac = N_OBJETIVO / len(pool)
muestra = pd.concat(
    [
        g.sample(max(1, round(len(g) * frac)), random_state=SEMILLA)
        for _, g in pool.groupby("mes_radicado")
    ]
).reset_index(drop=True)

muestra["que_fallo"] = ""       # a llenar por Ivan
muestra["donde_se_origino"] = ""  # a llenar por Ivan
muestra[
    [
        "radicacion_id",
        "mes_radicado",
        "tipificacion_devolucion",
        "comentario_devoluci_n",
        "que_fallo",
        "donde_se_origino",
    ]
].to_csv(SALIDA, index=False)

print(f"pool elegible: {len(pool)}")
print(f"muestra escrita: {len(muestra)} filas -> {SALIDA}")
print(muestra.groupby("mes_radicado").size().to_string())
