# Órdenes, ofertas y escrituras firmadas — CO

```yaml
metric: "Órdenes, ofertas y escrituras CO"
aliases: ["firma_ordenes_ofertas_escrituras"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Número de eventos de legalización logrados en el mes por el analista: orden de
  escrituración, oferta vinculante y firma de escritura.
formula_business: "conteo de eventos de orden de escrituración + oferta vinculante + firma de escritura, por analista y mes; supervisor = suma de su equipo"
formula_sql: |
  -- comisiones_internas_hc.sql:1136-1219 (desde 2026-08: unión de los tres eventos)
grain: "mes_comision × analista (supervisor: suma del equipo)"
filters_exclusions: "limpia comas del campo analista y excluye un correo no válido"
source_tables:
  - "ordenes_escrituracion (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: >
  Unidad: eventos. Antes de 2026-08 se usaba una versión legacy en la que se perdían
  analistas sin orden de escrituración. Julio y agosto 2026 tienen ajustes manuales de la
  ejecución (RN-CO-022). Meta del supervisor: "100% del total de la meta asignada para
  órdenes y escrituras del equipo".
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
