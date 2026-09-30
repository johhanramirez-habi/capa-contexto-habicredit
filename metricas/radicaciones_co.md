# Radicaciones — CO

```yaml
metric: "Radicaciones CO"
aliases: ["radicacion", "radicacion_analista", "radicacion_colex", "radicaciones únicas", "radicaciones totales"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Número de créditos radicados ante banco en el mes. Es el indicador comercial principal.
  Tiene tres variantes: únicas (primera radicación por cliente), totales y COLEX
  (clientes en el exterior).
formula_business: "conteo de operaciones cuya fecha de radicación (única, total o COLEX según la posición) cae en el mes de comisión"
formula_sql: |
  -- comisiones_internas_hc.sql:21-22,32
  if(date_trunc(fecha_radicacion_u, month) = mes_comision_input, 1.0, null) as radicacion, --Radicaciones únicas
  if(date_trunc(fecha_radicacion, month) = mes_comision_input, 1.0, null) as radicacion_analista,
  if(date_trunc(fecha_radicacion_colex, month) = mes_comision_input, 1.0, null) as radicacion_colex,
grain: "mes_comision × beneficiado"
filters_exclusions: "el Director non ibuyer usa radicaciones únicas; Gerente Comercial, Supervisor/Analista de Radicación y Gerente Ops (desde 2026-08) usan totales"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: operaciones. Paga en pareja con radicacion_monto_co: solo paga la de mayor
  cumplimiento (RN-CO-003). Sin techo (RN-CO-008). Para directores, la meta de únicas se carga
  como N × 0,85 (RN-CO-015). El diccionario (DIC:37) la define solo como "radicaciones
  únicas". La versión iBuyer (radicacion_cib, cib_u) se promedia (RN-CO-004).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
