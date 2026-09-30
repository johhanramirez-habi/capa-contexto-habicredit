# RN-CO-019 — Bono por sobreejecución (CO) — solo en el PDF

```yaml
rule_id: "RN-CO-019"
name: "Bono por sobreejecución"
domain: "Comisiones"
market: ["CO"]
description: >
  Bono adicional para quienes superan ampliamente su meta. Se paga máximo un bono por
  periodo (el mayor).
applies_to: ["Pago de comisión CO"]
logic_summary: >
  Analistas de legalización: con meta de 5.000MM o 7.000MM y llegando a >=10.000MM →
  400.000; con meta de 9.000MM o 10.000MM y llegando a >=12.000MM → 800.000; con meta de
  10.000MM y llegando a >=15.000MM → 1.200.000. Coordinaciones: 120-134% → 800.000;
  135-149% → 1.000.000; >=150% → 1.200.000. Gerencia: 1.000.000 / 1.200.000 / 1.400.000
  en los mismos tramos. Montos en COP
sql_reference: |
  -- sin evidencia en el material fuente: no está implementado en el SQL
exceptions: "máximo un bono por periodo"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: Esquemas/202608 (PDF, ~1343-1398), vigente desde abril 2026 según el PDF
```

## Notas
- En la base de Finanzas aparecen filas "Bono sobrejecucion" con tipo "Bonos". El origen de esas filas no tiene evidencia (se presume una carga manual, sin confirmar).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
