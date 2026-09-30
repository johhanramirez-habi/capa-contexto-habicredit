# RN-CO-026 — Cómo se califica el cumplimiento en el WBR de Liquidez (CO)

```yaml
rule_id: "RN-CO-026"
name: "Cumplimiento WBR: flujos contra meta corrida, rotación invertida"
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  En los flujos, más es mejor: el cumplimiento es el acumulado del mes sobre la meta del
  mes corrido. En la rotación, la meta de 70 días es un techo y menos días es mejor: el
  cumplimiento es la meta sobre la rotación real, medida en la última semana cerrada.
applies_to: ["Cumplimiento de meta WBR Liquidez CO", "Rotación Legalización non ibuyer CO"]
logic_summary: "flujos: MTD actual / meta corrida; rotación: meta / rotación de la última semana cuyo domingo ya pasó (fecha + 6 <= corte). Verde desde 100%"
sql_reference: |
  -- liquidez/wbr_liquidez_co.sql:230-236
  ROUND(SAFE_DIVIDE(meta_rotacion, NULLIF(
    (SELECT valor FROM rot_semanal r
      WHERE r.serie = 'Rotación non ibuyer' AND DATE_ADD(r.fecha, INTERVAL 6 DAY) <= fecha_corte
      ORDER BY r.fecha DESC LIMIT 1), 0)) * 100, 4)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
```

## Notas
- **Por qué se invierte.** Con la fórmula normal, 90 días contra una meta de 70 daría 129% y saldría en verde, cuando en realidad se está tardando un 29% de más.
- **Relación con comisiones.** Es el mismo principio de RN-CO-005, que invierte el cumplimiento cuando menos es mejor, aplicado al WBR.
- **Corrección previa.** La rotación se calificaba contra el último punto mensual, que era el mes anterior al corte: en el corte del 6 de septiembre se estaba calificando agosto.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
