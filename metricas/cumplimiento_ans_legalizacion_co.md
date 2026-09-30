# Cumplimiento de ANS en legalización (Flow Manager) — CO

```yaml
metric: "Cumplimiento ANS legalización CO"
aliases: ["cumplimiento_ans", "ANS Flow Manager"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Proporción de las operaciones en cola de legalización que están fuera del acuerdo de
  nivel de servicio (ANS), medida martes y jueves.
formula_business: "operaciones 'Fuera de ANS' / operaciones medidas (último registro del día, martes y jueves)"
formula_sql: |
  -- comisiones_internas_hc.sql:1262-1272
  SAFE_DIVIDE(SUM(IF(fuera_de_ans_string = "Fuera de ANS", 1, 0)), COUNT(...))
grain: "mes_comision × analista (supervisor: promedio; gerente: global)"
filters_exclusions: "excluye fases de notaría y peritos; solo martes y jueves"
source_tables:
  - "dias_en_cola_legalizacion_flow_manager_actual_y_corregido_historia (proyecto/dataset no especificado en el extracto)"
  - papyrus-master.general_dwh_mx.dim_calendario
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: %. Aunque se llama "cumplimiento", mide el % FUERA de ANS. El pago es binario:
  1 si la ejecución es menor o igual a la meta; NULL si no (RN-CO-006). El diccionario lo
  marca "PENDIENTE: definir". Usa un calendario de un dataset MX (general_dwh_mx) dentro
  del cálculo CO.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
