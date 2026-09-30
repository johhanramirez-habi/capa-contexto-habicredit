# Base comisionable — CO

```yaml
metric: "Base comisionable CO"
aliases: ["base_commission", "base", "bono objetivo"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Monto de referencia que cobra un beneficiado por un indicador al 100% de cumplimiento.
  Las bandas de pago la multiplican por un factor (0, 30%, 50%, % directo, techo).
formula_business: "valor definido en el esquema mensual por persona e indicador, cargado en el Sheet de metas"
formula_sql: |
  -- comisiones_internas_hc_final.sql:256
  base_commission   -- tomado de metas_comisiones_internas
grain: "email × metric_category × effective_date"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Moneda COP. La validación de metas marca como hallazgo base_commission < 1.000.000
  (validacion_metas.sql), pero muchas bases legítimas están entre 100.000 y 900.000. El
  PDF expresa pesos por concepto (p. ej. para el Gerente Comercial: radicación 40%,
  graduaciones 30%, aprobaciones 30% del bono); el motor solo los ve como la base de cada
  indicador.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
