# Comisión bruta EF / AO al escriturar — MX

```yaml
metric: "Comisión bruta EF/AO MX"
aliases: ["bruto", "comisión total"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Comisión total que le corresponde al EF o al AO por un negocio escriturado, antes de
  restar anticipos.
formula_business: "% de comisión del rol (resuelto con el mes de aceptación) × Monto_final_credito (MXN)"
formula_sql: |
  # python (src/comisiones/motor.py:175)
  bruto = pct * monto   # monto = Monto_final_credito
grain: "negocio × rol, en el mes de escrituración"
filters_exclusions: "requiere Fecha_de_escrituracion y Monto_final_credito > 0; requiere que el negocio exista en la base de aceptaciones; requiere EF/AO asignado"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: "Moneda MXN. ¿Los montos incluyen IVA? Sin evidencia en el material fuente (pregunta abierta #16)."
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
