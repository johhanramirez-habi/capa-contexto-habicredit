# Reprocesos y aprobaciones KAM — CO

```yaml
metric: "Reprocesos KAM CO"
aliases: ["reprocesos_kam", "aprobaciones_kam", "reprocesos_monto"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Operaciones negadas que el KAM reprocesa (reconsideración, cambio de condiciones) y las
  que logra que se aprueben, en unidades y en monto.
formula_business: "reprocesos = entradas a reconsideración en banco en el mes + reprocesos por cambio de condiciones; aprobados = aprobados vía mesa de salvamento + aprobados en otro banco + aprobaciones por cambio de condiciones; monto = monto aprobado final"
formula_sql: |
  -- comisiones_internas_hc.sql:787-957 (CTE reprocesos_kam_octubre_2025; resumen)
  -- excluye banco = 'COLPATRIA' (línea 834)
grain: "mes_comision × KAM"
filters_exclusions: "excluye banco COLPATRIA"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - "main_board_integrado, bt_pre_legalizacion_bi_new (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Metas: 120 reprocesos y 60 aprobaciones. reprocesos_kam y reprocesos_monto pagan en
  pareja: solo la de mayor cumplimiento (RN-CO-003). Sin techo (RN-CO-008). aprobaciones_kam
  cambia de fuente según el mes: antes de 2026-07, 2026-07 y 2026-08 (este último con
  conteos manuales por KAM). No tiene rama para meses posteriores a 2026-08, así que
  queda NULL. Desde 2025-08 dejó de usarse el promedio de las dos condiciones.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
