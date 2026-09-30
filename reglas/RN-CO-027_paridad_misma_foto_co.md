# RN-CO-027 — Comparar cifras del WBR contra la misma foto de la fuente (CO)

```yaml
rule_id: "RN-CO-027"
name: "Paridad contra la misma foto"
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  La tabla fuente del WBR puede reexpresar días ya cargados. Por eso, al comparar una
  cifra del WBR con otra (el PDF anterior, Tableau, otro reporte) hay que hacerlo contra
  la misma foto de los datos, o dejar dicho contra qué versión se comparó.
applies_to: ["Serie diaria WBR Liquidez CO", "Cantidad de desembolsos CO", "Radicaciones CO"]
logic_summary: "diferencias entre cortes no son necesariamente error de la consulta; verificar contra la misma versión de wbr_liquidez. Un tablero no se declara migrado sin paridad (dos martes en paralelo contra el PDF)"
sql_reference: |
  -- sin SQL: liquidez/historico/README.md; CLAUDE.md §9 del repo
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
```

## Notas
- **Caso documentado.** Desembolsos HC Bancario cerró la semana del 3 de agosto 2026 en 58 en el tablero y en 64 en la tabla tres días después, porque `habicredit.wbr_liquidez` reexpresó los días del 3 al 9 de agosto. Todo lo demás cuadró exacto.
- **Uso histórico.** Cada semana, el `datos.js` y el PDF presentado se versionan en `liquidez/historico/AAAA-MM-DD/`. Esa es la foto que hay que usar para comparar.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
