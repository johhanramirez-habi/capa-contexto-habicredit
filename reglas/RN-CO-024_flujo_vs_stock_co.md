# RN-CO-024 — Un flujo se suma, un stock se toma de un día (CO)

```yaml
rule_id: "RN-CO-024"
name: "Agregación de flujos y stocks"
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  Antes de agregar un indicador por semana o mes hay que saber si es un flujo (algo que
  pasa cada día y se acumula) o un stock (un nivel que existe todo el tiempo). Los flujos
  se suman; los stocks nunca se suman ni se promedian: se toma el valor de un solo día.
applies_to: ["Radicaciones CO", "Cantidad de desembolsos CO", "Monto desembolsado CO", "Backlog legalización non ibuyer CO", "Rotación Legalización non ibuyer CO"]
logic_summary: "flujo → SUM(COALESCE(valor, 0)); stock → valor de UN día (mensual: último día con dato; MTD: último día de la ventana; semanal: lo declara el área). En Liquidez, radicaciones y desembolsos son flujos; backlog y rotación vienen como foto precalculada (fila del lunes y del día 1)"
sql_reference: |
  -- liquidez/wbr_liquidez_co.sql:43-47 (flujo)
  SUM(COALESCE(valor, 0)) AS valor
  -- CLAUDE.md §6 del repo (stock)
  ARRAY_AGG(valor IGNORE NULLS ORDER BY dia ASC|DESC LIMIT 1)[SAFE_OFFSET(0)]
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
# evidencia: CLAUDE.md §6 del repo ("Eso no se negocia"); liquidez/wbr_liquidez_co.sql:25-103
```

## Notas
- **Día semanal sin declarar.** El repo exige que cada área declare en su README qué día toma para la serie semanal. Liquidez no tiene README en su carpeta. En el SQL, la rotación y el backlog se toman de la fila del lunes, que es el nivel de apertura de la semana.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
