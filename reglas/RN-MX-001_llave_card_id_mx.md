# RN-MX-001 — card_id como llave universal (MX)

```yaml
rule_id: "RN-MX-001"
name: "card_id como llave universal"
domain: "Comisiones"
market: ["MX"]
description: >
  Todo cruce, agrupación y neteo de comisiones en MX se hace por card_id. Nunca se usa el
  NID de la propiedad ni mapeos por nombre o monto.
applies_to: ["Negocio HabiCredit MX", "Anticipo de comisión MX", "Liquidación neta EF/AO MX"]
logic_summary: "llave única = card_id; el NID no es único y nunca se usa como llave de join"
sql_reference: |
  # config/reglas.yaml:15-18
  llave_negocio: card_id
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: CLAUDE.md:67-69; docs/fuentes.md:34-49
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
