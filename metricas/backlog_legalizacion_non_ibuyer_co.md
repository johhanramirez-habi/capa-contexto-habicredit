# Backlog de legalización non ibuyer — CO

```yaml
metric: "Backlog legalización non ibuyer CO"
aliases: ["backlog", "backlog_semana"]
domain: "Liquidez (WBR)"
market: ["CO"]
regional_variant_of: ""
description: >
  Cantidad de negocios non ibuyer pendientes en legalización al momento de la foto. Es el
  nivel contra el que se mide la rotación.
formula_business: "sin evidencia en el material fuente: la tabla trae el backlog ya calculado en la fila del lunes (semana) y del día 1 (mes)"
formula_sql: |
  -- liquidez/wbr_liquidez_co.sql:79,95
  STRUCT('backlog', CAST(backlog_semana AS FLOAT64))   -- semanal
  STRUCT('backlog', CAST(backlog AS FLOAT64))          -- mensual
grain: "semana (foto del lunes) y mes (foto del día 1)"
filters_exclusions: "solo non ibuyer; la vista mensual excluye el mes en curso"
source_tables:
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
known_caveats: >
  Unidad: negocios. Es un STOCK: nunca se suma ni se promedia en el periodo, se toma la
  foto de un día (RN-CO-024). Se muestra junto a los desembolsos non ibuyer
  (desembolsos_semana_leg_non_ibuyer / desembolsos_leg_non_ibuyer), en barras agrupadas.
```

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
