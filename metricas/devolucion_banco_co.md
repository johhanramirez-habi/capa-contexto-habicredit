# Devolución banco — CO

```yaml
metric: "Devolución banco CO"
aliases: ["Devolución banco", "devoluciones de banco"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
regional_variant_of: ""
description: >
  Mide qué tanto devuelven los bancos a Habi las operaciones radicadas porque tienen
  novedades que hay que subsanar. Refleja la calidad de la radicación desde el primer
  envío.
formula_business: "proporción de operaciones radicadas en banco que el banco devuelve a Habi por novedades; el documento no precisa el numerador ni el denominador exactos"
formula_sql: |
  -- sin evidencia en el material fuente
grain: "sin evidencia en el material fuente"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "sin evidencia en el material fuente"
known_caveats: >
  Según el documento, la devolución no siempre es un error del analista de Habi: también
  la generan factores de calificación interna del banco que llevan a rechazar al
  cliente. No se sabe si es el mismo indicador que dev_banco_broker del proyecto vivo
  (bono del KAM, RN-CO-013), cuyos valores se cargan a mano. Queda por validar.
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
