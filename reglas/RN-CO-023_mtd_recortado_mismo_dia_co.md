# RN-CO-023 — MTD del mes anterior recortado al mismo día del corte (CO)

```yaml
rule_id: "RN-CO-023"
name: "MTD recortado al mismo día"
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  Para comparar el mes en curso contra el anterior, el acumulado del mes anterior se corta
  en el mismo día del mes que la fecha de corte, con un tope en el día 30. Sin esta regla
  ningún MoM cuadra con lo que el negocio conoce.
applies_to: ["Radicaciones CO", "Monto radicado CO", "Cantidad de desembolsos CO", "Monto desembolsado CO", "Variación WoW / MoM WBR Liquidez CO", "Cumplimiento de meta WBR Liquidez CO"]
logic_summary: "MTD actual y MTD anterior = suma de los días con LEAST(día del mes, 30) <= LEAST(día del corte, 30)"
sql_reference: |
  -- liquidez/wbr_liquidez_co.sql:58-68
  WHERE LEAST(numero_dia_mes, 30) <= LEAST(EXTRACT(DAY FROM fecha_corte), 30)
    AND mes IN (DATE_TRUNC(fecha_corte, MONTH),
                DATE_SUB(DATE_TRUNC(fecha_corte, MONTH), INTERVAL 1 MONTH))
exceptions: "la rotación de legalización no tiene MTD (no se acumula en el mes)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
# evidencia: CLAUDE.md §5 del repo ("la regla que no se negocia"); equivale al campo 'Comparacion fechas mes a mes' de los workbooks de Tableau
```

## Notas
- Es una regla común a todas las áreas del repo de WBR, no exclusiva de Liquidez. Aquí se documenta por su uso en Liquidez CO.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
