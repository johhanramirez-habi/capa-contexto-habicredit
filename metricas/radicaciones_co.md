# Radicaciones — CO

```yaml
metric: "Radicaciones CO"
aliases: ["radicacion", "radicacion_analista", "radicacion_colex", "radicaciones únicas", "radicaciones totales", "Radicaciones (WBR)"]
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
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: >
  Unidad: operaciones. Paga en pareja con radicacion_monto_co: solo paga la de mayor
  cumplimiento (RN-CO-003). Sin techo (RN-CO-008). Para directores, la meta de únicas se carga
  como N × 0,85 (RN-CO-015). El diccionario (DIC:37) la define solo como "radicaciones
  únicas". La versión iBuyer (radicacion_cib, cib_u) se promedia (RN-CO-004). En el WBR de
  Liquidez se reporta a nivel compañía desde habicredit.wbr_liquidez (columna
  radicaciones), sin evidencia de si esa columna cuenta radicaciones únicas o totales.
```

## Uso en el WBR de Liquidez CO
- **Qué muestra el WBR.** El indicador "Radicaciones" usa la serie `radicaciones` como barras y `monto_solicitado` como línea.
- **Tipo y agregación.** Es un flujo: el periodo es la suma diaria, con NULL = 0 (RN-CO-024).
- **Periodos del tablero:**
  - 8 semanas que empiezan en lunes.
  - 12 meses.
  - MTD recortado al mismo día del mes (RN-CO-023).
  - WoW y MoM sobre el conteo ([variacion_wow_mom_co.md](variacion_wow_mom_co.md)).
- **Meta.** Viene de `corp_gov_global.wbr_metas_pais`, prorrateada con una curva estacional (RN-CO-025), y el cumplimiento se calcula contra ella ([cumplimiento_meta_wbr_co.md](cumplimiento_meta_wbr_co.md)).
- **Estado.** El tablero marca el indicador como "validado".
- **Diferencia con comisiones.** Las comisiones cuentan por persona desde `main_board`; el WBR cuenta el total de la compañía desde `wbr_liquidez`. No hay evidencia de que los dos universos coincidan.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: enriquecida con el WBR de Liquidez CO (docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)).
