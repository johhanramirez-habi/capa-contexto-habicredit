# Salvamentos (reproceso de créditos) — CO

```yaml
metric: "Salvamentos CO"
aliases: ["reproceso_creditos", "reproceso_creditos_monto", "salvamento", "mesa de salvamento"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Créditos negados que el equipo de radicación logra aprobar por la mesa de salvamento,
  en unidades y en monto aprobado.
formula_business: "conteo y suma del monto aprobado de operaciones con subproceso de mesa de salvamento, por analista y mes de aprobación"
formula_sql: |
  -- comisiones_internas_hc.sql:438-505 (resumen)
  -- inicio_subproceso_mesa_salvamento IS NOT NULL; SUM(monto_aprobado)
grain: "mes de aprobación × analista (analista_negados)"
filters_exclusions: "si banco IN ('BANCODEBOGOTA','BANCOLOMBIA') o no hay analista, el crédito se atribuye al genérico 'Analista de radicación'"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad/moneda: operaciones y COP. Paga en pareja: solo la de mayor cumplimiento
  (RN-CO-003). Sin techo (RN-CO-008). Desde 2026-08-01, un traslado de banco cuenta como
  salvamento para dos analistas (RN-CO-017); no se hereda al total del supervisor. Meta del
  supervisor (descripción del Sheet): "3 operaciones reprocesadas por día para lograr 180
  salvadas".
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
