# Monto desembolsado — CO

```yaml
metric: "Monto desembolsado CO"
aliases: ["monto_desembolso", "monto_desembolso_leg", "monto_desembolso_ibuyer", "monto_desembolsos_inmo_ciudades", "desembolsos en monto"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Suma del monto desembolsado por los bancos en el mes. Se usa como indicador de
  cumplimiento en legalización y como base de tramos fijos en gerencia y directores.
formula_business: "suma del monto desembolsado de las operaciones cuya fecha de desembolso cae en el mes"
formula_sql: |
  -- comisiones_internas_hc.sql:48
  if(date_trunc(fecha_desembolso, month) = mes_comision_input, monto_desembolso, null) as monto_desembolso,
grain: "mes_comision × beneficiado"
filters_exclusions: "la variante iBuyer usa desembolsos_ibuyer_hc.valor_credito_1; la de convenios filtra por correo_broker del ejecutivo"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: >
  Moneda COP. Desde 2026-08-01, para el Gerente Comercial y el Director non ibuyer paga
  por tramos fijos (RN-CO-011). Para el Gerente Comercial el indicador era NULL antes de
  2026-08, aunque la meta de 2025-03 decía "bonus is 40% of total". En el Analista de
  Legalización y el Supervisor de Legalización paga promediado con cantidad_desembolsos
  (RN-CO-004). Sin techo en COLEX (RN-CO-008).
```

## Uso en el WBR de Liquidez CO
- En el WBR es la serie `monto_desembolsos` del indicador "Desembolsos HC Bancario": una línea sobre las barras de conteo, en miles de millones de COP. Es un flujo (suma diaria).
- Los KPI del indicador (WoW, MoM, meta, cumplimiento) se calculan sobre el conteo, no sobre el monto.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: enriquecida con el WBR de Liquidez CO (docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)).
