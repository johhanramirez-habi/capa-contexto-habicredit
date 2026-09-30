# Convertidos de pre-legalización — CO

```yaml
metric: "Convertidos de pre-legalización CO"
aliases: ["conversion_pre_leg_director", "convertidos_pre_legalizacion", "negocios_convertidos_hc", "negocios_pre_legalizados"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Número de negocios que terminan la pre-legalización en el mes. Se mide por director
  (conversion_pre_leg_director) y en total para el supervisor de pre-legalización.
formula_business: "conteo de negocios con fecha de fin de pre-legalización en el mes, deduplicados por report_id y ciclo"
formula_sql: |
  -- comisiones_internas_hc.sql:304-364 (resumen)
  -- COUNT DISTINCT (report_id, ciclo) con fecha_fin_pre_legalizacion en el mes
grain: "mes_comision × director (o total)"
filters_exclusions: "sin evidencia en el material fuente"
source_tables:
  - "bt_pre_legalizacion_bi_new (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: >
  Unidad: negocios. El conteo baja al re-correr porque la base de salidas/backlog se
  reduce día a día; por eso hay valores fijados a mano (agosto 2026 = 1.001, contra 970 del
  motor, confirmado el 2026-09-09; julio 2026 = 1.176; un director fijado en 80 en agosto).
  negocios_convertidos_hc está fijado en 7,0 de abril a junio 2026. Meta del supervisor
  de pre-legalización reactivado en 2026-08: 950. Relacionado con el proyecto
  bt_pre_legalizacion (no revisado en esta extracción).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
