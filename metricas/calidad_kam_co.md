# Calidad KAM — CO

```yaml
metric: "Calidad KAM CO"
aliases: ["calidad_kam"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Porcentaje de las operaciones creadas por un KAM en el mes que entran a radicación en
  banco en ese mismo mes sin devolución por documentos.
formula_business: "operaciones creadas en el mes que entran a radicación en banco el mismo mes y no fueron devueltas por documentos / operaciones creadas en el mes"
formula_sql: |
  -- comisiones_internas_hc.sql:520-540 (resumen)
  -- numerador: radicación en banco en el mismo mes AND entrada_devuelto_por_documentos_habi IS NULL
  -- denominador: created_at no nulo
grain: "mes de created_at × KAM"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - "pipe_radicacion_co (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: "Unidad: %. Meta 0,9. En el CSV de metas aparece con unidad COP (carga incorrecta)."
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
