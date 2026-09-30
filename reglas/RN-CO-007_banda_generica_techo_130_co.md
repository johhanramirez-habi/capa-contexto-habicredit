# RN-CO-007 — Banda de pago genérica con techo de 130% (CO)

```yaml
rule_id: "RN-CO-007"
name: "Banda genérica 70/80/130"
domain: "Comisiones"
market: ["CO"]
description: >
  Tabla de pago estándar del esquema de Colombia. Por debajo del 70% de cumplimiento no se
  paga; entre 70% y 79,99% se paga el 30% de la base; desde 80% se paga el % logrado,
  hasta un máximo de 130%.
applies_to: ["Pago de comisión CO", "Posición comisionable CO"]
logic_summary: "p <= 69,99% → 0; p <= 79,99% → base × 0,3; p <= 129,99% → base × p; p > 129,99% → base × 1,3"
sql_reference: |
  -- comisiones_internas_hc_final.sql (CTE reglas_generales)
  WHEN p_ejecucion <= .6999 THEN 0
  WHEN p_ejecucion <= .7999 THEN base_commission *.3
  WHEN p_ejecucion <= 1.2999 THEN base_commission * p_ejecucion
  WHEN p_ejecucion > 1.2999 THEN base_commission * 1.3
exceptions: "indicadores sin techo (RN-CO-008), analistas de radicación con techo de 150% (RN-CO-009), Supervisor Legalización con piso de 50% (RN-CO-010), tramos fijos por desembolso (RN-CO-011), directores nuevos (RN-CO-012), bonos KAM (RN-CO-013)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: coincide con la tabla del PDF Esquemas/202608 (~líneas 39-44)
```

## Notas
- Aplica a: Gerente Comercial, Director non ibuyer y KAM (en sus indicadores no especiales), Convenios, Graduaciones, Analista Devoluciones, Director/Ejecutivo ibuyer, COLEX, Gerente Ops, Supervisor Radicación y Supervisor/Analista Pre Legalización.
- La penalización CSAT del 20% que menciona el PDF no está aplicada en el SQL (RN-CO-018).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
