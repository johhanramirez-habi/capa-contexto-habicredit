# Serie diaria del WBR de Liquidez — CO

```yaml
entity: "Serie diaria WBR Liquidez CO"
aliases: ["wbr_liquidez", "habicredit.wbr_liquidez", "base del WBR de Liquidez"]
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  Tabla diaria con los indicadores de la infraestructura de Liquidez Colombia que alimenta
  el Weekly Business Review (WBR), el tablero semanal que se presenta los martes a los
  líderes de la empresa. Trae flujos diarios (radicaciones, desembolsos) y, para la
  rotación de legalización, la foto ya calculada de cada semana y de cada mes.
grain: "una fila por fecha (día); las filas del lunes y del día 1 del mes traen además la foto semanal y mensual de la rotación"
source_tables:
  - papyrus-delivery-data.habicredit.wbr_liquidez
key_attributes:
  - name: "fecha"
    description: "día del registro"
  - name: "radicaciones / monto_solicitado"
    description: "radicaciones del día y su monto solicitado (COP)"
  - name: "desembolsos / monto_desembolsos"
    description: "desembolsos HC Bancario del día y su monto (COP)"
  - name: "backlog_semana / desembolsos_semana_leg_non_ibuyer / rotacion_semana_leg_non_ibuyer"
    description: "foto semanal de legalización non ibuyer (en la fila del lunes)"
  - name: "backlog / desembolsos_leg_non_ibuyer / rotacion_leg_non_ibuyer"
    description: "foto mensual de legalización non ibuyer (en la fila del día 1)"
relationships:
  - related_entity: "Meta WBR por país"
    relationship: "los indicadores de flujo se comparan contra la meta mensual de wbr_metas_pais"
  - related_entity: "Operación de crédito CO"
    relationship: "sin evidencia en el material fuente de cómo se agrega desde main_board u otra tabla"
business_rules_ref: ["RN-CO-023", "RN-CO-024", "RN-CO-027"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
# evidencia: liquidez/wbr_liquidez_co.sql:20-23,70-103; liquidez/historico/README.md
```

## Notas
- **La tabla se reexpresa.** Los días ya cargados pueden cambiar después: los días del 3 al 9 de agosto 2026 cambiaron tres días después del corte (liquidez/historico/README.md).
- **El proceso que la llena no está documentado.** No hay evidencia en el material fuente de qué proceso la construye ni de sus tablas de origen.
- **Falta declarar el día de la serie semanal.** El repo exige que cada área declare en su README qué día toma la serie semanal (CLAUDE.md §6), pero la carpeta `liquidez/` no tiene README. En el SQL, la rotación se toma de la fila del lunes y los flujos semanales son semanas que empiezan en lunes.

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
