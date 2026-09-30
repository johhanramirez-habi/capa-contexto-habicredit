# RN-CO-014 — Castigo del 10% a posiciones no-Habicredit (CO)

```yaml
rule_id: "RN-CO-014"
name: "Castigo no-Habicredit"
domain: "Comisiones"
market: ["CO"]
description: >
  A las posiciones de legalización no-Habicredit se les aplicaba un castigo del 10% sobre
  la comisión si el desembolso quedaba por debajo del 70% de la meta.
applies_to: ["Pago de comisión CO"]
logic_summary: "si monto_desembolso / meta_legalizacion < 0,7 → multiplicador 0,9; si no, 1"
sql_reference: |
  -- comisiones_internas_hc_final.sql:217-227; comisiones_internas_hc.sql:1566
  IF(ejecucion = 1.0, 0.9, 1) AS multiplicador_castigo
exceptions: "hoy inactivo: esas posiciones salieron del UNPIVOT en 2026"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
```

## Notas
- La fecha de inicio es contradictoria dentro del mismo SQL: un comentario dice "2025-03 es de 10%" (final.sql:223) y otro "2025-04 es de 10%" (final.sql:575).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
