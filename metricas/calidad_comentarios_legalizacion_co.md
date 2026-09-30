# Cantidad y calidad de comentarios — CO

```yaml
metric: "Cantidad y calidad de comentarios CO"
aliases: ["cantidad_calidad_comentarios", "cantidad_calidad_comentarios_analista"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Combina la calidad (score) y la cantidad de comentarios de seguimiento que el analista
  de legalización registra en las operaciones.
formula_business: "promedio de (score promedio / 8) y (comentarios promedio / 80); supervisor = promedio de su equipo"
formula_sql: |
  -- comisiones_internas_hc.sql:602-606 (opción B vigente)
  (AVG(score)/8 + AVG(comentarios)/80)/2   -- "8 Es la meta en mayo"
grain: "mes_comision × analista"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "score_comentarios_calidad_legalizacion (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: índice (meta siempre 1). La opción A (score > 8 y comentarios > 80) se calcula
  pero no se usa. El diccionario (DIC:11-12) la describe como "calificación mínima
  8/10", que no coincide con la fórmula del SQL.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
