# Anticipo del Manager — MX

```yaml
metric: "Anticipo Manager MX"
aliases: ["anticipo MGR", "Comisión manager"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Pago adelantado al Manager en el mes de aceptación: 30% del monto fijo por aprobación
  que le corresponde según el tamaño del equipo.
formula_business: "30% × monto por aprobación del Manager (MXN 0 / 500 / 1.000 según el conteo de equipo)"
formula_sql: |
  # python (src/comisiones/motor.py:131)
  "monto": redondear(pct_anticipo * mgr_unitario)
grain: "negocio × Manager, en el mes de aceptación"
filters_exclusions: "el Manager cobra su anticipo aunque falte la base del EF (su monto no depende del crédito)"
source_tables:
  - "derivada de conteo_equipo_aceptaciones_mx"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. Valores observados: 150 (equipo de 9 a 16) y 300 (17 o más). El tope de
  25.000 del Manager no se aplica a los anticipos. Totales de control en los tests:
  2026-05 = 7.800, 2026-06 = 5.400, 2026-07 = 6.000.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
