# Comisión perdida ("quedó sobre la mesa") — CO

```yaml
metric: "Comisión perdida CO"
aliases: ["perdido", "quedó sobre la mesa"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Cuánto de su base comisionable dejó de cobrar el beneficiado en el mes por no llegar al
  100%. Se muestra en el visor de comisiones.
formula_business: "suma sobre indicadores de max(0, base comisionable − pago)"
formula_sql: |
  # python (services/visor_data.py:350-356)
  perdido = sum(max(0, base - pago))
grain: "mes_comision × beneficiado"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - papyrus-delivery-data.habicredit.visor_comisiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: "Moneda COP. Es una métrica de presentación (visor), no de pago."
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
