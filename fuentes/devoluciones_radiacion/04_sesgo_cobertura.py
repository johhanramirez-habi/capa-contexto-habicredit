#!/usr/bin/env python3
"""
04_sesgo_cobertura.py

Pregunta que responde: #13 — ¿la mezcla de causas depende de cuánto se comenta?

Fecha:  2026-08-13
Autor:  Claude (sesión Johhan Ramirez)

El 55,4% de las devoluciones de `Política documental` no tiene comentario, así que el
desglose de `02_clasificacion.py` se calcula sobre la mitad observada. La pregunta no
es si falta información — falta, y hay que escalarlo a desarrollo — sino si lo que se
observa está sesgado hacia unas causas.

Prueba: la cobertura del comentario varía casi al doble entre meses (26,8% a 50,6%). Si
la mezcla de causas fuera distinta en los meses de alta cobertura, la muestra estaría
sesgada. Si el share de cada categoría se mantiene estable mientras la cobertura se
duplica, trabajar en porcentaje sobre los comentados es defendible.

Advertencia: son 11 meses. Una correlación de ±0,3 con n=11 no se distingue del ruido.
El argumento fuerte es la amplitud del rango del share, no el coeficiente.

Requiere haber corrido antes `02_clasificacion.py`.
"""

import ast

import pandas as pd

import importlib.util

spec = importlib.util.spec_from_file_location("clasif", "02_clasificacion.py")
clasif = importlib.util.module_from_spec(spec)
spec.loader.exec_module(clasif)

ENTRADA = "documental_categorizado.xlsx"
VENTANA_INICIO = pd.Period("2025-09")
VENTANA_FIN = pd.Period("2026-07")


def main():
    d = pd.read_excel(ENTRADA)
    d["cats"] = d.categorias_documentales.map(ast.literal_eval)
    d["mes"] = pd.to_datetime(d.fecha_de_radicado).dt.to_period("M")
    w = d[(d.mes >= VENTANA_INICIO) & (d.mes <= VENTANA_FIN)]

    cobertura = w.groupby("mes").categoria_primaria.apply(
        lambda s: (s != clasif.SIN_COMENTARIO).mean()
    )
    wc = w[w.categoria_primaria != clasif.SIN_COMENTARIO]

    series = {
        cat: wc.groupby("mes").cats.apply(lambda s: s.map(lambda xs: cat in xs).mean())
        for cat in clasif.DOCUMENTALES
    }
    series["Sin causa documental"] = wc.groupby("mes").cats.apply(
        lambda s: s.map(lambda xs: not any(c in clasif.DOCUMENTALES for c in xs)).mean()
    )

    print(f"ventana {VENTANA_INICIO}..{VENTANA_FIN}\n")
    print(f"{'mes':9s} {'cobertura':>10s} {'n comentados':>13s}")
    n = wc.groupby("mes").size()
    for mes in cobertura.index:
        print(f"{str(mes):9s} {cobertura[mes]:9.1%} {n[mes]:13d}")

    print(f"\n{'categoría':47s} {'mín':>6s} {'máx':>6s} {'corr':>7s}")
    print("-" * 70)
    for cat, s in sorted(series.items(), key=lambda kv: -kv[1].mean()):
        # Correlación de rangos (Spearman) sin scipy: correlación de Pearson
        # sobre los rangos.
        corr = cobertura.rank().corr(s.rank())
        print(f"{cat:47s} {s.min():6.1%} {s.max():6.1%} {corr:+7.2f}")

    print(
        "\nLectura: correlación cerca de 0 = el peso de la categoría no depende de "
        "cuánto\nse comentó ese mes, así que el porcentaje sobre los comentados es "
        "utilizable.\nCorrelación alta = esa categoría se sub-registra cuando se "
        "comenta menos."
    )


if __name__ == "__main__":
    main()
