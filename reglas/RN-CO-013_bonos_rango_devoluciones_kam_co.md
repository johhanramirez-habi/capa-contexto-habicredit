# RN-CO-013 — Bonos por rango de devoluciones (KAM) (CO)

```yaml
rule_id: "RN-CO-013"
name: "Bonos KAM por rango de devoluciones"
domain: "Comisiones"
market: ["CO"]
description: >
  El KAM recibe un bono fijo mayor cuanto menor sea su tasa de devoluciones (del banco al
  broker y por documentos de Habi).
applies_to: ["Pago de comisión CO"]
logic_summary: "dev_banco_broker: 15-20% → 50.000; 10-14,99% → 100.000; 5-9,99% → 150.000; 0-4,99% → 200.000. dev_docs_habi: 4-5% → 50.000; 3-3,99% → 100.000; 2-2,99% → 150.000; 0-1,99% → 200.000 (COP)"
sql_reference: |
  -- comisiones_internas_hc_final.sql:370-385
  WHEN indicador IN ('dev_banco_broker') THEN CASE
    WHEN p_ejecucion BETWEEN 0.15 AND 0.20 THEN 50000
    WHEN p_ejecucion BETWEEN 0.10 AND 0.1499 THEN 100000
    WHEN p_ejecucion BETWEEN 0.05 AND 0.0999 THEN 150000
    WHEN p_ejecucion BETWEEN 0 AND 0.0499 THEN 200000 END
exceptions: "por encima del rango máximo, o en los huecos entre bandas (p. ej. 0,04995), el pago es NULL"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
```

## Notas
- **p_ejecucion = ejecución.** Se evalúa p_ejecucion, que equivale a la ejecución porque la meta es 1 (convenciones.md:44-45).
- **Valores a mano.** dev_banco_broker y dev_docs_habi se cargan a mano: la fórmula obvia daba ~2,3 veces lo reportado (sql/comisiones_co/README.md:104-106).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
