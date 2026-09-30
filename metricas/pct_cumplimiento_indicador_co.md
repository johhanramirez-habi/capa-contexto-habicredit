# % de cumplimiento del indicador (p_ejecucion) — CO

```yaml
metric: "% cumplimiento de indicador CO"
aliases: ["p_ejecucion", "cumplimiento", "% de ejecución"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: "pct_cumplimiento_meta_mx.md"
description: >
  Grado en que un beneficiado alcanzó la meta de un indicador en el mes. Es el insumo de
  las bandas de pago: define si cobra y cuánto de su base comisionable.
formula_business: "ejecución / meta, con excepciones: invertido (meta/ejecución) en indicadores donde menos es mejor, binario en ANS, y en parejas unidades/monto solo cuenta el mayor"
formula_sql: |
  -- comisiones_internas_hc_final.sql:259-297 (extracto)
  WHEN ci.indicador = 'dias_sancion' THEN SAFE_DIVIDE(meta_value, ejecucion)
  WHEN ci.indicador = 'cumplimiento_ans' THEN IF(ejecucion <= meta_value, 1, NULL)
  ELSE SAFE_DIVIDE(ejecucion, meta_value)
grain: "mes_comision × beneficiado × indicador"
filters_exclusions: "solo filas con meta (meta_value IS NOT NULL); en las parejas de indicadores, la fila perdedora queda en NULL"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_fn_table
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Es una variante de pct_cumplimiento_meta_mx.md, pero la lógica es distinta (por
  indicador, con inversiones y binarios). Un NULL en p_ejecucion puede ser intencional
  (la otra fila de la pareja paga por promedio): el visor marca varias de esas filas como
  "a revisar" por error (VISOR.md:99-121 contra final.sql:275-282). Ver RN-CO-003 a RN-CO-006.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
