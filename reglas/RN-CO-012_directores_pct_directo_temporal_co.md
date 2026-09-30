# RN-CO-012 — Directores con % directo por un periodo definido (CO)

```yaml
rule_id: "RN-CO-012"
name: "Directores específicos cobran % directo temporalmente"
domain: "Comisiones"
market: ["CO"]
description: >
  Durante un periodo definido, tres directores comerciales específicos cobran radicación y
  reprocesos proporcionalmente a su cumplimiento, sin el piso del 70% ni la banda del
  30%.
applies_to: ["Radicaciones CO", "Monto radicado CO", "Reprocesos KAM CO", "Pago de comisión CO"]
logic_summary: "para 3 directores identificados por correo: pago = base × p_ejecucion; vigencia 2026-07-01 a 2027-02-01 (dos de ellos) y 2026-07-01 a 2027-04-01 (uno)"
sql_reference: |
  -- comisiones_internas_hc_final.sql:327-330
  WHEN beneficiado IN (...) AND mes_comision BETWEEN '2026-07-01' AND '2027-02-01' THEN base_commission * p_ejecucion
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
```

## Notas
- El motivo de negocio de esta excepción no tiene evidencia en el material fuente; el SQL no explica por qué estos tres directores reciben este trato.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
