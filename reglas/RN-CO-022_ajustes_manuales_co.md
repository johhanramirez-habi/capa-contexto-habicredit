# RN-CO-022 — Ajustes manuales de ejecución y pago (CO)

```yaml
rule_id: "RN-CO-022"
name: "Ajustes manuales (quemas y UNION ALL)"
domain: "Comisiones"
market: ["CO"]
description: >
  Cuando la fuente no refleja la realidad acordada, el valor de ejecución de un indicador
  se fija a mano (se "quema") para un mes y una persona, o se agregan filas de ajuste
  (reversiones de pagos dobles, pagos puntuales).
applies_to: ["Comisión interna CO", "Pago de comisión CO"]
logic_summary: "quemas por mes × indicador × beneficiado en la CTE comisiones_internas; filas de ajuste por UNION ALL que solo se emiten en corridas de agosto 2026 (montos −159.000; −1.000.000; −440.500; +1.248.407; +498.133 COP)"
sql_reference: |
  -- comisiones_internas_hc_final.sql:9-44 (quemas), 645-716 (UNION ALL)
  -- condición del UNION ALL: date_sub(date_trunc(current_date('-5'), month), interval 1 month) = '2026-07-01'
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: CLAUDE.md:78-83 (no inventar valores: si falta un indicador quemado, se pide el valor)
```

## Notas
- **UNION ALL no reproducible.** Depende de `current_date`, así que su resultado cambia según el día en que se corra, lo que contradice RN-CO-002.
- **Indicadores con valores quemados.** Hay muchos más en el paso 1: filtros_enviados_banco, dev_banco_broker, dev_docs_habi, recaudo_garantias, vinculacion_itau, devoluciones/NPS/graduaciones de un director, convertidos_pre_legalizacion y ops_devueltas (= 0).
- **Quema revertida.** La quema general de agosto 2026 se revirtió el 2026-09-09.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
