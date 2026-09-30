# RN-MX-003 — Pago en dos eventos: anticipo y liquidación (MX)

```yaml
rule_id: "RN-MX-003"
name: "Pago en dos eventos"
domain: "Comisiones"
market: ["MX"]
description: >
  La comisión de un negocio se paga en dos momentos: un anticipo del 30% en el mes de
  aceptación y la liquidación (comisión total menos anticipo) en el mes de escrituración.
applies_to: ["Anticipo EF MX", "Anticipo Manager MX", "Liquidación neta EF/AO MX", "Liquidación Manager MX"]
logic_summary: "aceptación → anticipo 30% (EF, MGR); escrituración → total − anticipo. Si acepta y escritura en el mismo mes, se genera primero el anticipo y luego se descuenta; el anticipo nunca se omite"
sql_reference: |
  # config/reglas.yaml:86-90
  generar_aunque_escriture_mismo_mes: true
exceptions: "el AO no tiene anticipo (RN-MX-004); escrituración nula = solo anticipo"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: CLAUDE.md:24-28; docs/reglas.md:97-104,365-378; src/comisiones/__main__.py:158-165
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
