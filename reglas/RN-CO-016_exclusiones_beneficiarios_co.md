# RN-CO-016 — Exclusiones de beneficiarios por posición (CO)

```yaml
rule_id: "RN-CO-016"
name: "Exclusiones de beneficiarios"
domain: "Comisiones"
market: ["CO"]
description: >
  Algunas personas se excluyen explícitamente del cálculo de ciertas posiciones (p. ej.
  porque comisionan en otra posición o son buzones genéricos), para no pagarles dos veces
  ni pagar a cuentas que no son personas.
applies_to: ["Beneficiado de comisiones CO", "Operación de crédito CO"]
logic_summary: "Director non ibuyer: excluye 3 correos (director iBuyer y buzones) y exige monto_desembolso no nulo o radicacion > 0. KAM: excluye 3 correos. Analista Radicación: excluye 2 correos (uno es el buzón COLEX). Analista Legalización: excluye a los supervisores. Mayo 2026: no cuentan los desembolsos cargados a una supervisora como analista"
sql_reference: |
  -- comisiones_internas_hc.sql:58,1723-1725,1833,2117,2380 (listas de correos en el SQL)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
