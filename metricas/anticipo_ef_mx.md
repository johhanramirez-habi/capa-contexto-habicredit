# Anticipo del Experto Financiero — MX

```yaml
metric: "Anticipo EF MX"
aliases: ["anticipo", "Comision experto", "30% anticipo"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Pago adelantado al Experto Financiero en el mes de aceptación: 30% de la comisión
  calculada sobre el monto aprobado por el banco seleccionado. Se resta después de la
  liquidación.
formula_business: "30% × % de comisión EF × monto del banco seleccionado (MXN)"
formula_sql: |
  # python (src/comisiones/motor.py:126)
  "monto": redondear(pct_anticipo * pct * base)   # pct_anticipo = 0.30
grain: "negocio × EF, en el mes de aceptación"
filters_exclusions: "sin monto del banco seleccionado no hay anticipo (va a excepción base_anticipo_sin_monto); un negocio excluido por override no genera anticipo; si el EF es el referidor, pct = 1%"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. Contradicción documental sobre la base: varios pasajes (CLAUDE.md:26,
  docs/reglas.md:103,183,377,543, docs/fuentes.md:113,163-165) dicen
  monto_solicitado_de_cr_dito, mientras que reglas.yaml:78, docs/reglas.md:322 y el
  código usan el monto del banco seleccionado (CONFIRMADO en el yaml). Los anticipos a un
  colaborador que ya salió no se fuerzan a cero (solo se hace en la liquidación).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
