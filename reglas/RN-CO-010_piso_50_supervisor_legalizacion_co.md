# RN-CO-010 — Supervisor de Legalización: banda mínima de 50% y sin techo (CO)

```yaml
rule_id: "RN-CO-010"
name: "Banda 50% Supervisor Legalización"
domain: "Comisiones"
market: ["CO"]
description: >
  Entre 70% y 79,99% de cumplimiento, el Supervisor de Legalización cobra el 50% de la
  base (en vez del 30% genérico), y desde 80% cobra el % logrado sin techo.
applies_to: ["Pago de comisión CO"]
logic_summary: "p <= 69,99% → 0; p <= 79,99% → base × 0,5; p > 79,99% → base × p"
sql_reference: |
  -- comisiones_internas_hc_final.sql:538-544
  WHEN posicion IN ('Supervisor Legalización') THEN
    CASE WHEN p_ejecucion <= .6999 THEN 0
         WHEN p_ejecucion <= .7999 THEN base_commission *.5
         WHEN p_ejecucion > .7999 THEN base_commission * p_ejecucion END
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: PDF 202608 (~1137): "70.0% 79,99% 50 %" / "80.0% En adelante % Directo"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
