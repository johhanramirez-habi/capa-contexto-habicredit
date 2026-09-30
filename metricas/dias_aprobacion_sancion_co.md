# Días de radicación a aprobación / sanción — CO

```yaml
metric: "Días de aprobación/sanción CO"
aliases: ["dias_aprobacion", "dias_sancion"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Tiempo promedio desde la radicación hasta que el banco aprueba (o emite sanción:
  aprobación o negación). Aquí menos es mejor.
formula_business: "promedio de días de radicación a aprobación (o a sanción), solo créditos tradicionales"
formula_sql: |
  -- comisiones_internas_hc.sql:390-436 (resumen)
  AVG(dias_radicacion_sancion)   -- con valor >= 0 y tu_credito_es = 'Tradicional'
grain: "mes_comision × beneficiado"
filters_exclusions: "valores >= 0; tu_credito_es = 'Tradicional'"
source_tables:
  - "main_board_radicacion (derivada de papyrus-delivery-data.habicredit.main_board)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: días. Meta de 6 días hábiles (7 en convenios). El cumplimiento es invertido,
  meta/ejecución (RN-CO-005). Desde 2026-07-01, los supervisores y analistas de radicación
  pasaron de dias_aprobacion a dias_sancion.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
