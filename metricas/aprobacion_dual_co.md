# Aprobación dual — CO

```yaml
metric: "Aprobación dual CO"
aliases: ["aprobacion_dual", "aprobacion_dual_colex", "aprobaciones_inmo_ciudades", "% aprobación"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Porcentaje de las radicaciones del mes anterior que ya estaban aprobadas al cierre del
  mes actual. Mide la calidad de lo que se radica.
formula_business: "radicaciones del mes anterior aprobadas a más tardar el mes siguiente a la radicación / radicaciones del mes anterior"
formula_sql: |
  -- comisiones_internas_hc.sql:40-45,1698
  if(date_trunc(fecha_radicacion, month) = date_sub(mes_comision_input, interval 1 month) and mes_aprob_vs_rad <= 1, 1.0, null) as aprobacion_dual,
  if(date_trunc(fecha_radicacion, month) = date_sub(mes_comision_input, interval 1 month), 1.0, 0) as aprobacion_dual_meta,
  SAFE_DIVIDE(SUM(aprobacion_dual), SUM(aprobacion_dual_meta))
grain: "mes_comision × beneficiado (director; ejecutivo iBuyer por correo_broker)"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: >
  Unidad: %. Metas observadas: 0,5 para directores y 0,7 para iBuyer. La meta varía entre
  fuentes: el PDF de agosto dice 50%, la descripción del Sheet dice 60% con meta 0,5 y un
  comentario del SQL dice 60%. La definición de mes_aprob_vs_rad (viene de main_board) no
  tiene evidencia. Posible bug en COLEX: se calcula mes_aprob_vs_rad_colex, pero el filtro
  usa mes_aprob_vs_rad (comisiones_internas_hc.sql:33-35).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
