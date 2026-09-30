# RN-CO-017 — Traslado de banco cuenta como salvamento (CO)

```yaml
rule_id: "RN-CO-017"
name: "Traslado de banco como salvamento"
domain: "Comisiones"
market: ["CO"]
description: >
  Desde agosto 2026, cuando un analista logra que un cliente negado sea aprobado en otro
  banco, esa operación le cuenta como salvamento. Es una excepción acordada con el gerente
  de radicación.
applies_to: ["Salvamentos CO"]
logic_summary: "desde 2026-08-01, solo para 2 analistas identificados por correo: el mismo cliente tiene una radicación en otro banco anterior a la aprobación → cuenta como salvamento. No se hereda al total del supervisor"
sql_reference: |
  -- comisiones_internas_hc.sql:447-469,509-510
exceptions: "no aplica a otros analistas ni al total del supervisor"
owner: "sin evidencia en el material fuente (acordada con el gerente de radicación)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
