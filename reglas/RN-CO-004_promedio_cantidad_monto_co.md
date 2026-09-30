# RN-CO-004 — Desembolsos e iBuyer: se promedia cantidad y monto (CO)

```yaml
rule_id: "RN-CO-004"
name: "Promedio de cumplimiento cantidad/monto"
domain: "Comisiones"
market: ["CO"]
description: >
  En desembolsos (y en radicación iBuyer) el cumplimiento que paga es el promedio del
  cumplimiento en unidades y en monto. La fila de monto queda sin pago propio.
applies_to: ["Cantidad de desembolsos CO", "Monto desembolsado CO", "Radicaciones CO"]
logic_summary: "Analista Legalización: desembolsos paga AVG(p desembolsos, p monto_desembolso_leg). Supervisor Legalización y Gerente Ops: cantidad_desembolsos paga AVG(p cantidad, p monto_desembolso). iBuyer (Director/Ejecutivo): radicacion_cib paga AVG(p cib, p cib_u); cib_u y monto_cib quedan NULL"
sql_reference: |
  -- comisiones_internas_hc_final.sql:145-214,275-282 (extracto)
  WHEN ci.indicador = 'monto_desembolso' AND ci.posicion IN ('Supervisor Legalización') THEN NULL
  WHEN ci.indicador = 'cantidad_desembolsos' THEN cd_gs.p_ejecucion_desembolso
  WHEN ci.indicador = 'desembolsos' THEN cd_a.p_ejecucion_desembolso
  WHEN ci.indicador = 'radicacion_cib' THEN cr_cib.p_ejecucion_radicacion_cib
exceptions: "para el Gerente Ops la fila monto_desembolso no se anula (solo para Supervisor Legalización)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Notas
- **radicacion_monto_cib nunca paga.** Tiene meta y base, pero no entra en el promedio iBuyer.
- **Falso positivo en el visor.** El visor no conoce estas parejas (`PAREJA_MONTO`, visor_data.py:96-102) y marca esas filas NULL como "a revisar".

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
