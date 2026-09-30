# Net Promoter Score (NPS) — CO

```yaml
metric: "NPS CO"
aliases: ["NPS", "Net Promoter Score"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
regional_variant_of: ""
description: >
  Mide la lealtad de los clientes a partir de si recomendarían el producto. Se basa en
  una sola pregunta: qué tan probable es que recomiende el producto o servicio a un
  familiar o amigo.
formula_business: "los clientes califican su probabilidad de recomendar en una escala; según la respuesta se clasifican en promotores, pasivos (indiferentes) y detractores. El documento no da la fórmula del índice ni los cortes de cada grupo"
formula_sql: |
  -- sin evidencia en el material fuente
grain: "sin evidencia en el material fuente"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "sin evidencia en el material fuente"
known_caveats: >
  El proyecto vivo de comisiones tiene un indicador nps_director_devoluciones con otra
  escala y otra convención de carga (ver RN-CO-015). Que las dos mediciones sean el
  mismo NPS queda por validar.
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
