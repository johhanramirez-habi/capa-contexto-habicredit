# RN-CO-018 — Penalización por CSAT (CO) — solo en el PDF

```yaml
rule_id: "RN-CO-018"
name: "Penalización CSAT 20%"
domain: "Comisiones"
market: ["CO"]
description: >
  Según el esquema mensual, cada persona debe mantener una calificación de satisfacción
  (CSAT) de 4,5 estrellas; si no la logra, se le descuenta el 20% de la comisión obtenida.
applies_to: ["Pago de comisión CO"]
logic_summary: "CSAT individual < 4,5 → comisión × 0,8"
sql_reference: |
  -- sin evidencia en el material fuente: no está implementada en el SQL
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: Esquemas/202608 (PDF, ~línea 55 y en cada sección)
```

## Notas
- Existe en el PDF pero no en el motor. Las convenciones de carga de metas la excluyen (convenciones.md:54). No hay evidencia de si se aplica manualmente después.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
