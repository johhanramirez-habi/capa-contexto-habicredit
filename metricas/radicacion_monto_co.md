# Monto radicado — CO

```yaml
metric: "Monto radicado CO"
aliases: ["radicacion_monto", "monto_solicitado", "monto_solicitado_analista"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Suma del monto solicitado de los créditos radicados en el mes. Es la versión en dinero
  del indicador de radicaciones.
formula_business: "suma del monto solicitado de las operaciones radicadas en el mes (únicas o totales según la posición)"
formula_sql: |
  -- comisiones_internas_hc.sql:24-25
  if(date_trunc(fecha_radicacion_u, month) = mes_comision_input, monto_solicitado_u, null) as monto_solicitado,
  if(date_trunc(fecha_radicacion, month) = mes_comision_input, monto_solicitado, null) as monto_solicitado_analista,
grain: "mes_comision × beneficiado"
filters_exclusions: "mismas que radicaciones_co"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Moneda COP. La meta se carga como radicaciones × 200.000.000 (ticket promedio de $200MM;
  convenciones.md:22-23). Paga en pareja con radicaciones_co (RN-CO-003).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
