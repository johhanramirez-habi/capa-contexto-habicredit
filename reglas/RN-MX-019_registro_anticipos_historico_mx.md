# RN-MX-019 — Registro de anticipos: el histórico es inmutable (MX)

```yaml
rule_id: "RN-MX-019"
name: "Inmutabilidad del registro histórico de anticipos"
domain: "Comisiones"
market: ["MX"]
description: >
  El registro de anticipos es la memoria de lo que ya se pagó. Recalcular un mes solo
  reemplaza lo que el motor generó para ese mes; lo que viene del consolidado histórico
  nunca se sobrescribe.
applies_to: ["Anticipo de comisión MX"]
logic_summary: "llave card_id + colaborador + rol; recálculo reemplaza filas origen=motor del mes; origen=consolidado_historico es intocable"
sql_reference: |
  # src/comisiones/registro.py:12,60-94
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: README.md:54; tests/golden/test_meses_cerrados.py:162-198
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
