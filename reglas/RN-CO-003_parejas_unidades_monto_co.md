# RN-CO-003 — Parejas unidades/monto: solo paga la de mayor cumplimiento (CO)

```yaml
rule_id: "RN-CO-003"
name: "Pareja unidades/monto paga la mayor"
domain: "Comisiones"
market: ["CO"]
description: >
  Varios indicadores se miden en unidades y en monto (p. ej. radicaciones y monto
  radicado). La persona cobra solo el de mayor cumplimiento; el otro queda sin pago.
applies_to: ["Radicaciones CO", "Monto radicado CO", "Salvamentos CO", "Reprocesos KAM CO"]
logic_summary: "parejas: radicacion/radicacion_monto, radicaciones_inmo_ciudades(_monto), reproceso_creditos(_monto), reprocesos_kam/reprocesos_monto, vinculacion_itau(_monto). Se elige la fila de mayor p_ejecucion por mes y beneficiado; la otra queda con p_ejecucion y pago NULL"
sql_reference: |
  -- comisiones_internas_hc_final.sql:80-143,260-273 (extracto)
  QUALIFY ROW_NUMBER() OVER (PARTITION BY mes_comision, beneficiado ORDER BY p_ejecucion_rad DESC) = 1
  IF(p_ejecucion_rad = SAFE_DIVIDE(ejecucion, meta_value), p_ejecucion_rad, NULL)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
