# Brokers nuevos productivos — CO

```yaml
metric: "Brokers nuevos CO"
aliases: ["nuevos_brokers", "brokers_mas_2_rad", "vinculaciones"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Mide si los brokers vinculados por un director comercial en el mes anterior empiezan a
  producir (radican al menos 2 operaciones).
formula_business: "desde 2026-08-01: brokers nuevos con al menos 2 radicaciones / brokers nuevos. Antes: promedio de (vinculaciones / meta de brokers nuevos) y (brokers con 2 o más radicaciones / meta mínima)"
formula_sql: |
  -- comisiones_internas_hc.sql:1652-1657 (extracto)
  -- >= 2026-08-01: SAFE_DIVIDE(brokers_mas_2_rad, brokers_nuevos)
  -- antes:         (vinculaciones/brokers_nuevos + brokers_mas_2_rad/broker_min_rad)/2
grain: "mes_comision × director comercial"
filters_exclusions: "universo: brokers con fecha_inicio_contrato en el mes anterior; radicaciones contadas entre el mes anterior y el mes de comisión"
source_tables:
  - papyrus-master.liquidez_platinum_co.dim_brokers
  - papyrus-delivery-data.habicredit.main_board
  - papyrus-delivery-data.habicredit.nuevos_brokers_meta_comsiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: % (meta_value = 1). El Gerente Comercial mantiene la fórmula de dos indicadores
  (PDF de agosto: "30 brokers nuevos y 20 brokers radicando mínimo 2 operaciones"). El
  diccionario (DIC:35) describe la fórmula anterior a 2026-08.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
