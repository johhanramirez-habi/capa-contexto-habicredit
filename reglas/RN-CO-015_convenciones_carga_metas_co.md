# RN-CO-015 — Convenciones de carga de metas desde el PDF (CO)

```yaml
rule_id: "RN-CO-015"
name: "Convenciones de carga de metas"
domain: "Comisiones"
market: ["CO"]
description: >
  Reglas para convertir el PDF del esquema mensual en filas de metas (persona × indicador).
  Aseguran que el motor interprete bien cada meta.
applies_to: ["Meta de comisiones CO", "Base comisionable CO"]
logic_summary: >
  radicacion_monto = radicacion × 200.000.000; directores: radicacion = N × 0,85 (clientes
  únicos); cib_u = cib × 0,85; "menos del X%" se carga como 1 − X; NPS >= 4 se carga como
  0,40; indicadores ponderados: meta_value = 1; escalonados: tramo superior + descripción;
  bonos por rango: meta = 1 y base vacía. Se reutilizan los nombres de metric_category y
  el string de employee. Los montos del PDF se escalan según la sección (×1.000.000 en
  legalización, ×1.000 en gerencias, etc.)
sql_reference: |
  -- sin SQL: .claude/skills/extraccion-metas/references/convenciones.md:3-45
exceptions: "no se cargan vacantes, tablas de rango de cumplimiento, bonos por sobreejecución, concursos (plan carrera/Rocket) ni penalizaciones transversales (CSAT)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: .claude/skills/extraccion-metas/SKILL.md:104-129; convenciones.md:47-54
```

## Notas
- **Unidades inconsistentes.** El NPS de agosto 2026 llega en escala 1-5 (4,88) contra una meta de 0,40, lo que daría un cumplimiento de ~12,2 (comisiones_internas_hc.sql:1762-1767).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
