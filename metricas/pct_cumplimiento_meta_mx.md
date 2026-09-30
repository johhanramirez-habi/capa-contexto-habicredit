# % de cumplimiento de meta (esquema 2023) — MX

```yaml
metric: "% cumplimiento de meta MX (esquema 2023)"
aliases: ["% de cumplimiento", "cumplimiento_equipo_pct"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Porcentaje de la meta mensual de aceptaciones que logró cada colaborador (o el equipo,
  en el caso del Manager). Solo se usa en el esquema 2023 para elegir el tramo de pago.
formula_business: "aceptaciones logradas en el mes / meta individual del mes (para el Manager: cumplimiento del equipo)"
formula_sql: |
  # config/reglas.yaml:155,184 (no implementado en código)
  aceptaciones_logradas / meta_individual_mes
grain: "colaborador × mes"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "metas.csv (colaborador_id, mes, meta_aceptaciones) — no existe en la carpeta"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
known_caveats: >
  No es ejecutable: resolver_esquema exige 'individual_cero' (parametros.py:43), así que
  cualquier mes de 2023 lanza EsquemaNoVigente, y no hay datos de metas. Ver
  pct_cumplimiento_indicador_co.md: el nombre de negocio es parecido, pero la lógica es
  distinta.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
