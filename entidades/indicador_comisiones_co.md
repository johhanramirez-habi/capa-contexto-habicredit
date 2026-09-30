# Indicador de comisiones (catálogo) — HabiCredit CO

```yaml
entity: "Indicador de comisiones CO"
aliases: ["indicador", "metric_category", "métrica", "concepto"]
domain: "Comisiones"
market: ["CO"]
description: >
  Catálogo de las métricas comisionables de Colombia, como radicaciones, desembolsos, ANS
  o rotación. Para cada una indica qué mide, en qué unidad y de qué fuente sale su
  ejecución.
grain: "un indicador (55 en el diccionario local)"
source_tables:
  - "papyrus-delivery-data.habicredit.diccionario_indicadores_comisiones_co (nombre asumido; PENDIENTE confirmar según README.md:103-106)"
key_attributes:
  - name: "indicador"
    description: "nombre técnico, igual a metric_category de metas"
  - name: "definicion / unidad"
    description: "unidades: ops, COP, %, days (en metas aparecen además descriptive, rating, count)"
  - name: "fuente / vista_ejecucion"
    description: "de dónde sale la ejecución (automática o por definir)"
  - name: "activo_desde / activo_hasta"
    description: "todos activo_desde = 2026-07-01, sin activo_hasta"
relationships:
  - related_entity: "Meta de comisiones CO"
    relationship: "un indicador tiene metas por beneficiado y mes"
  - related_entity: "Comisión interna CO"
    relationship: "un indicador genera filas de comisión"
business_rules_ref: ["RN-CO-003", "RN-CO-004", "RN-CO-005", "RN-CO-006"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: data/diccionario_indicadores_comisiones_co.csv; README.md:100-106; sql/validaciones/validacion_metas.sql:31; diff_indicadores.sql:16
```

## Notas
- **Diccionario desalineado con el motor.** Hay indicadores que el diccionario marca "automática" pero que el SQL tiene quemados, y otros marcados "por definir" que ya tienen valor en el SQL. Ver el detalle en las métricas de [metricas/](../metricas/).
- **Nombre del diccionario.** `diff_indicadores.sql` y `validacion_metas.sql` citan otro archivo: "Diccionario_indicadores_comisiones_CO_v2".

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
