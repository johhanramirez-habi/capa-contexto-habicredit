# RN-CO-009 — Techo de 150% para analistas de radicación y filtros (CO)

```yaml
rule_id: "RN-CO-009"
name: "Techo 150% analistas de radicación"
domain: "Comisiones"
market: ["CO"]
description: >
  Los analistas de radicación y de filtros tienen un techo de pago de 150% en lugar del
  130% genérico.
applies_to: ["Pago de comisión CO"]
logic_summary: "Analista Radicación / Analista de filtros (Estados): p <= 69,99% → 0; p <= 79,99% → base × 0,3; p <= 149,99% → base × p; p > 149,99% → base × 1,5"
sql_reference: |
  -- comisiones_internas_hc_final.sql:522-536
  WHEN p_ejecucion <= 1.4999 THEN base_commission *p_ejecucion
  WHEN p_ejecucion > 1.4999 THEN base_commission * 1.5
exceptions: "reproceso_creditos(_monto) de estas posiciones no tiene techo (RN-CO-008)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: PDF 202608 (~1062-1067): "80.0% En adelante al 150%"
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
