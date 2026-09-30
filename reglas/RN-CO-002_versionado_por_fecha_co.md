# RN-CO-002 — Recálculo del histórico y versionado de reglas por fecha (CO)

```yaml
rule_id: "RN-CO-002"
name: "Versionado de cambios por fecha de vigencia"
domain: "Comisiones"
market: ["CO"]
description: >
  El paso 2 del motor recalcula todo el histórico en cada corrida. Por eso cualquier
  cambio de regla se versiona por fecha, para no alterar meses ya pagados. El motor solo
  calcula hasta el mes en curso (hora de Colombia).
applies_to: ["Comisión interna CO", "Pago de comisión CO"]
logic_summary: "CASE WHEN mes_comision >= '<fecha de vigencia>' THEN <regla nueva> ELSE <regla vieja intacta> END; horizonte mes_comision <= mes actual (UTC-5)"
sql_reference: |
  -- comisiones_internas_hc_final.sql:76
  WHERE mes_comision <= DATE_TRUNC(CURRENT_DATE('-5'), MONTH)
exceptions: "un ajuste que reproduzca el valor viejo bit a bit, verificado con una consulta de solo lectura"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: CLAUDE.md:46-60,85-90
```

## Notas
- Los ajustes por UNION ALL dependen de `current_date` (RN-CO-022), lo que choca con esta regla de reproducibilidad.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
