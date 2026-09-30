# RN-CO-006 — Cumplimiento binario en ANS (CO)

```yaml
rule_id: "RN-CO-006"
name: "Cumplimiento binario"
domain: "Comisiones"
market: ["CO"]
description: >
  Algunos indicadores de nivel de servicio pagan todo o nada: si la ejecución queda
  dentro de la meta el cumplimiento es 100%; si no, no hay cumplimiento ni pago.
applies_to: ["Cumplimiento ANS legalización CO", "% cumplimiento de indicador CO"]
logic_summary: "cumplimiento_ans, ans_ibuyer, tiempo_respuesta_pre_legalizacion → p_ejecucion = 1 si ejecución <= meta; NULL si no (no 0)"
sql_reference: |
  -- comisiones_internas_hc_final.sql:290-295
  WHEN ci.indicador = 'cumplimiento_ans' THEN IF(ejecucion <= meta_value, 1, NULL)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
