# Comisión por referido interno — MX

```yaml
metric: "Comisión referido interno MX"
aliases: ["referido 1%", "comisión referido"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Comisión que cobra el empleado que refirió un negocio: 1% del crédito final. Reemplaza
  el tramo normal que ese colaborador cobraría por ese negocio.
formula_business: "1% × Monto_final_credito (MXN); anticipo de 30% × 1% si el referido está declarado en la aceptación"
formula_sql: |
  # python (src/comisiones/motor.py:106-108,171-172)
  pct = pct_referido if es_referidor else tramo_ef_ao(n_ind, n_equipo, esquema)   # pct_referido = 0.01
grain: "negocio × colaborador referidor"
filters_exclusions: "solo con referido declarado en referidos.csv; vigente desde 2023-07-01 (retroactivo)"
source_tables:
  - "data/clean/referidos.csv"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. Si el referido se declara después de la aceptación, el anticipo sale al
  tramo normal y la diferencia se salda al escriturar. El referido de rol MGR (1 fila) no
  tiene rama en el motor. Quedan abiertas dos preguntas: si los otros implicados del
  negocio cobran y si el referido cuenta para la meta.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
