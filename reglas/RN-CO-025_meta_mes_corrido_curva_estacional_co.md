# RN-CO-025 — Meta del mes corrido con curva estacional (CO)

```yaml
rule_id: "RN-CO-025"
name: "Meta del mes corrido con curva estacional"
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  La meta mensual no se reparte en línea recta entre los días del mes. Se aplica un factor
  por día que sigue el patrón estacional del mes y depende de si el mes tiene 31, 30 o
  menos días. La meta del mes corrido es la meta mensual por el factor del día del corte.
applies_to: ["Cumplimiento de meta WBR Liquidez CO", "Meta WBR por país", "Radicaciones CO", "Cantidad de desembolsos CO"]
logic_summary: "meta_corrida = meta mensual (wbr_metas_pais) × factor[día del corte] de la curva del indicador (31 días, 30 días, o rama para 28/29); Desembolsos HC Bancario trunca el resultado a entero, Radicaciones no"
sql_reference: |
  -- liquidez/wbr_liquidez_co.sql:159-191 (extracto)
  CASE WHEN m.indicador = 'Desembolsos HC Bancario'
       THEN TRUNC(m.meta * f.factor) ELSE m.meta * f.factor END AS valor
  -- factor = c.factores[ORDINAL(LEAST(EXTRACT(DAY FROM fecha_corte), ARRAY_LENGTH(c.factores)))]
exceptions: "la rotación de legalización tiene meta fija (70 días), sin curva"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
# evidencia: factores copiados literalmente de los campos 'Meta Radicaciones' y 'Meta Desembolsos' del .twbx de Tableau
```

## Notas
- **Dónde están los factores.** Los factores diarios completos están en el SQL fuente (líneas 161-166). No se copian aquí: son 6 curvas de 28 a 31 valores.
- **El truncamiento cambia el resultado.** No es cosmético: 58/89 = 65,17% en lugar de 64,85%.
- **Curvas sin actualización documentada.** No hay evidencia de quién mantiene las curvas ni de si se revisan periódicamente.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
