# Conteo de equipo de aceptaciones con inmueble — MX

```yaml
metric: "Conteo de equipo de aceptaciones con inmueble MX"
aliases: ["conteo_equipo", "total del equipo", "Cumplimiento MO"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Total de negocios aceptados con inmueble definido en el mes por todo el equipo. Es la
  segunda condición de los tramos EF/AO (con 8 o menos nadie cobra) y define el monto por
  aprobación del Manager.
formula_business: "total de negocios aceptados en el mes con NID asignado y no excluidos"
formula_sql: |
  # python (src/comisiones/motor.py:67)
  contables.groupby("mes_aceptacion").size()
grain: "mes de aceptación"
filters_exclusions: "mismos filtros que el conteo individual; incluye los negocios de colaboradores que ya salieron"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Valores observados en outputs: entre 12 (2024-09) y 29 (2026-04). Filtrar a quienes
  salieron antes de contar subcuenta al equipo y puede dejar a todos en 0%
  (config/reglas.yaml:108).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
