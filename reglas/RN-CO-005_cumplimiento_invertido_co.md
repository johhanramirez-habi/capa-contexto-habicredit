# RN-CO-005 — Cumplimiento invertido en indicadores de "menos es mejor" (CO)

```yaml
rule_id: "RN-CO-005"
name: "Cumplimiento invertido"
domain: "Comisiones"
market: ["CO"]
description: >
  En los indicadores donde un valor menor es mejor (días de trámite, devoluciones), el
  cumplimiento es la meta dividida entre la ejecución.
applies_to: ["Días de aprobación/sanción CO", "% cumplimiento de indicador CO"]
logic_summary: "dias_aprobacion, dias_sancion, devolucion_broker_formados → p_ejecucion = meta / ejecución"
sql_reference: |
  -- comisiones_internas_hc_final.sql:284-289
  WHEN ci.indicador = 'dias_sancion' THEN SAFE_DIVIDE(meta_value, ejecucion)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
