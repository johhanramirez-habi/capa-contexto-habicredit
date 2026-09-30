# Tasa de aprobación — CO

```yaml
metric: "Tasa de aprobación CO"
aliases: ["aprobación", "% aprobación"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
regional_variant_of: ""
description: >
  Proporción de las solicitudes que el banco analiza y termina aprobando. Incluye las
  aprobadas por el monto solicitado y las aprobadas por menor valor.
formula_business: "operaciones aprobadas (por el monto solicitado + por menor valor) / operaciones analizadas por el banco; el documento no define el denominador ni la ventana de tiempo"
formula_sql: |
  -- sin evidencia en el material fuente
grain: "sin evidencia en el material fuente"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "sin evidencia en el material fuente"
known_caveats: >
  No es la misma métrica que aprobacion_dual_co del proyecto vivo, que mide las
  radicaciones del mes anterior aprobadas al cierre del mes actual. Esta definición del
  documento no dice ventana ni denominador, así que no se puede afirmar que coincidan ni
  que se contradigan. Un aprobado por menor valor que el cliente no acepta se reclasifica
  como negado (RN-CO-034).
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
