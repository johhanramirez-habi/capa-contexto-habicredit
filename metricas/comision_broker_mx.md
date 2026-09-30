# Comisión de broker — MX

```yaml
metric: "Comisión broker MX"
aliases: ["comisión brokerage", "Comisiones infra brokers"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Porcentaje del crédito que se paga a un broker inmobiliario externo por un negocio
  desembolsado, según la fecha y el tipo de inmueble.
formula_business: "hasta 2023-12-11: 0,3% ibuyer / 1,0% externo; campaña de aceptaciones 2023-09 y 2023-10: 1,5% en externos si pasan más de 45 días hasta la escrituración (prioridad); desde 2024-04-01: 0,3% en cualquier inmueble con crédito tramitado por HabiCredit"
formula_sql: |
  # config/reglas.yaml:237-255 (no implementado en código)
  - {vigente_hasta: 2023-12-11, tipo_inmueble: ibuyer,  porcentaje: 0.003}
  - {vigente_hasta: 2023-12-11, tipo_inmueble: externo, porcentaje: 0.010}
  - {id: campana_externos, aceptaciones_en: [2023-09, 2023-10], porcentaje: 0.015, condicion: dias_hasta_escrituracion > 45, prioridad: 1}
  - {vigente_desde: 2024-04-01, tipo_inmueble: cualquiera, porcentaje: 0.003}
grain: "sin evidencia en el material fuente"
filters_exclusions: "requiere desembolso y factura aprobada (RN-MX-018)"
source_tables:
  - papyrus-master.operations_habi_mx_buyers.funnel_buyers_mx
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. No está implementado: en el reporte, la sección de brokerage sale vacía.
  Entre 2023-12-12 y 2024-03-31 no hay esquema documentado.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
