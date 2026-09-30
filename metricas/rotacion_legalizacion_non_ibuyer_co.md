# Rotación de Legalización non ibuyer — CO

```yaml
metric: "Rotación Legalización non ibuyer CO"
aliases: ["Rotación Legalización non ibuyer", "Rotación non ibuyer", "rotacion_leg_non_ibuyer", "rotacion_semana_leg_non_ibuyer"]
domain: "Liquidez (WBR)"
market: ["CO"]
regional_variant_of: ""
description: >
  Días que tarda en rotar el backlog de legalización de negocios non ibuyer. Indica qué tan
  rápido se legalizan los créditos; menos días es mejor.
formula_business: "sin evidencia en el material fuente: la tabla trae la rotación ya calculada por semana y por mes; el WBR solo la redondea a días enteros"
formula_sql: |
  -- liquidez/wbr_liquidez_co.sql:75-103 (extracto)
  STRUCT('Rotación non ibuyer', ROUND(rotacion_semana_leg_non_ibuyer))   -- semanal: fila del lunes
  STRUCT('Rotación non ibuyer', ROUND(rotacion_leg_non_ibuyer))          -- mensual: fila del día 1
grain: "semana (foto del lunes) y mes (foto del día 1)"
filters_exclusions: "solo negocios non ibuyer; la vista mensual oculta el mes en curso (queda incompleto y la rotación se dispara); 8 semanas y 12 meses de ventana"
source_tables:
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
known_caveats: >
  Unidad: días. Se grafica con el backlog y los desembolsos non ibuyer como barras
  agrupadas (no apiladas: un nivel más un flujo no suman nada con sentido) y la rotación
  como línea. Meta: 70 días como TECHO (constante en el SQL, marcada "PENDIENTE: confirmar
  el origen con el dueño del tablero"; no está en wbr_metas_pais). Cumplimiento
  invertido meta/actual contra la última semana cerrada (RN-CO-026). WoW sí, MoM y MTD
  no (la rotación no se acumula en el mes). En el WBR, un WoW que sube se pinta como mala
  noticia (menosEsMejor). La fórmula de la rotación no está en el material fuente; el
  CLAUDE.md del repo menciona como ejemplo general "backlog de apertura ÷ salidas", pero
  no la atribuye a este indicador. Es una métrica distinta de cumplimiento_rotacion_co
  (comisiones).
```

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
