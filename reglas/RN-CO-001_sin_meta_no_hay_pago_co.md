# RN-CO-001 — Sin meta no hay pago (CO)

```yaml
rule_id: "RN-CO-001"
name: "Sin meta no hay pago"
domain: "Comisiones"
market: ["CO"]
description: >
  Un indicador solo se paga si la persona tiene una meta cargada para ese indicador y ese
  mes. El cruce se hace por correo, indicador y mes; si no hay meta, la fila desaparece del
  resultado sin ningún aviso.
applies_to: ["Comisión interna CO", "Meta de comisiones CO", "Pago de comisión CO"]
logic_summary: "join con metas por email = beneficiado AND metric_category = indicador AND effective_date = mes_comision; se descartan las filas con meta_value nulo"
sql_reference: |
  -- comisiones_internas_hc_final.sql:303,620
  LEFT JOIN `papyrus-delivery-data.habicredit.metas_comisiones_internas` mci ON mci.email = ci.beneficiado AND mci.metric_category = ci.indicador AND mci.effective_date = ci.mes_comision
  WHERE meta_value IS NOT NULL
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: CLAUDE.md:25-28
```

## Notas
- El barrido mensual busca justamente este síntoma: la alerta `1_META_SIN_EJECUCION` y relacionadas (sql/validaciones/barrido_cambios_mes.sql).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
