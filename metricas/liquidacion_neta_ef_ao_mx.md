# Liquidación neta EF / AO — MX

```yaml
metric: "Liquidación neta EF/AO MX"
aliases: ["70% restante", "pago_final", "Comisión EF", "Comisión AO", "neto"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Monto que se le paga al EF o al AO al escriturar: la comisión bruta menos lo que ya se
  le pagó como anticipo por ese negocio.
formula_business: "comisión bruta − anticipos efectivamente pagados (card_id, colaborador); el AO no tiene anticipo, así que su neto = bruto"
formula_sql: |
  # python (src/comisiones/motor.py:174-182)
  anticipo = anticipos_pagados.get((neg["card_id"], quien), CERO)
  neto = bruto - anticipo
  if quien in salidas and mes >= salidas[quien]: neto = CERO
grain: "negocio × rol × colaborador, en el mes de escrituración"
filters_exclusions: "forzado a 0 si el colaborador tiene fecha_salida en o antes del mes de pago"
source_tables:
  - "derivada de comision_bruta_ef_ao_mx y del registro de anticipos (data/clean/anticipos.csv)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. Modelo "adelanto_puro" (reglas.yaml:97; confirmado en docs/reglas.md:633).
  Contradicción: reglas.yaml:84 (permitir_pago_negativo: false) y docs/reglas.md:399 dicen
  que no se emite pago negativo, pero motor.py:181-182 deja el neto negativo y solo
  reporta la excepción liquidacion_negativa (salvo el caso de fecha_salida). Mayo 2026
  tuvo clawbacks indebidos a una EF que ya había salido (3 negocios, total 1.185,34 MXN;
  test_meses_cerrados.py:38-45). El neteo usa la llave (card_id, colaborador) sin el rol;
  habría colisión si una persona tuviera dos roles en el mismo negocio (riesgo teórico).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
