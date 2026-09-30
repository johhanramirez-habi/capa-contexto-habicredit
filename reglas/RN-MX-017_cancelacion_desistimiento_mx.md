# RN-MX-017 — Cancelación o desistimiento (MX)

```yaml
rule_id: "RN-MX-017"
name: "Descomisión por cancelación o desistimiento"
domain: "Comisiones"
market: ["MX"]
description: >
  Si un negocio se cancela o el cliente desiste, no se paga comisión y se "descomisiona":
  el anticipo ya pagado se descuenta de comisiones futuras.
applies_to: ["Anticipo de comisión MX", "Liquidación neta EF/AO MX"]
logic_summary: "negocio cancelado/desistido → sin comisión; anticipo pagado se netea contra comisiones futuras"
sql_reference: |
  -- sin evidencia en el material fuente (no implementado en código)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:162,328,563
```

## Notas
- Está documentada pero no implementada. Tampoco hay evidencia de cómo se identifica un desistimiento en la fuente.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
