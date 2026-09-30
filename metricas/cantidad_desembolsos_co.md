# Cantidad de desembolsos — CO

```yaml
metric: "Cantidad de desembolsos CO"
aliases: ["desembolsos", "cantidad_desembolsos"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Número de créditos desembolsados en el mes. Se paga promediado con el monto
  desembolsado.
formula_business: "conteo de operaciones con fecha de desembolso en el mes"
formula_sql: |
  -- comisiones_internas_hc.sql:47
  if(date_trunc(fecha_desembolso, month) = mes_comision_input, 1.0, null) as desembolsos,
grain: "mes_comision × beneficiado"
filters_exclusions: "'desembolsos' = analista de legalización; 'cantidad_desembolsos' = supervisor y gerente"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: "Unidad: operaciones. p_ejecucion = promedio de p(cantidad) y p(monto) (RN-CO-004)."
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
