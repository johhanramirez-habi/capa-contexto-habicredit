# RN-MX-016 — Día de pago (MX)

```yaml
rule_id: "RN-MX-016"
name: "Día de pago"
domain: "Comisiones"
market: ["MX"]
description: >
  Las comisiones se pagan el día 15 de cada mes. Al inicio de cada mes se liquida el mes
  anterior.
applies_to: ["Liquidación neta EF/AO MX", "Liquidación Manager MX"]
logic_summary: "pago el día 15; se calcula el mes cerrado anterior"
sql_reference: |
  # config/reglas.yaml:121
  dia_de_pago: 15
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:156 ("esquema 2026"); docs/proceso_mensual.md:5
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
