# Pago de comisión por indicador — CO

```yaml
metric: "Pago de comisión CO"
aliases: ["pago", "monto de comisión", "comisión"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Monto que se le paga a un beneficiado por un indicador en el mes. Resulta de aplicar la
  banda de pago de su posición al % de cumplimiento sobre la base comisionable, o un
  tramo fijo en los indicadores de monto desembolsado.
formula_business: "banda(posición, indicador, % cumplimiento) × base comisionable; o monto fijo por tramo de desembolso"
formula_sql: |
  -- comisiones_internas_hc_final.sql:315-617 (CTE reglas_generales; banda genérica)
  WHEN p_ejecucion <= .6999 THEN 0
  WHEN p_ejecucion <= .7999 THEN base_commission *.3
  WHEN p_ejecucion <= 1.2999 THEN base_commission * p_ejecucion
  WHEN p_ejecucion > 1.2999 THEN base_commission * 1.3
grain: "mes_comision × beneficiado × indicador"
filters_exclusions: "WHERE meta_value IS NOT NULL (sin meta no hay fila); posiciones fuera del CASE => NULL"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_fn_table
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Moneda COP. El total del mes por persona es SUM(pago) (visor). Las reglas del PDF que
  no están en el SQL (penalización CSAT del 20%, bono por sobreejecución) no se reflejan
  aquí. Los meses ya auditados se toman de la base de Finanzas, no de este cálculo
  (RN-CO-021). Las bandas específicas están en RN-CO-007 a RN-CO-014.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
