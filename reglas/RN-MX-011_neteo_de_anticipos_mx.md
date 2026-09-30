# RN-MX-011 — Neteo de anticipos en la liquidación (MX)

```yaml
rule_id: "RN-MX-011"
name: "Neteo de anticipos (adelanto puro)"
domain: "Comisiones"
market: ["MX"]
description: >
  Al escriturar se resta lo que efectivamente se pagó como anticipo (según el registro),
  no un recálculo. El % queda congelado al del mes de aceptación.
applies_to: ["Liquidación neta EF/AO MX", "Liquidación Manager MX", "Anticipo de comisión MX"]
logic_summary: "liquidación = pct × Monto_final_credito − anticipos pagados registrados; % congelado en la aceptación; no se emite pago negativo (el saldo se arrastra); sin tope mensual de descuento definido"
sql_reference: |
  # config/reglas.yaml:82-97
  congelar_porcentaje_en_aceptacion: true
  max_descuento_mensual: null
  permitir_pago_negativo: false
  modelo_liquidacion: adelanto_puro
exceptions: "colaborador que salió: el saldo no se recupera (RN-MX-009)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:325-327,399,633,639; src/comisiones/__main__.py:102-112
```

## Notas
- **Contradicción entre config y código.** `permitir_pago_negativo: false` dice que no hay pagos negativos, pero motor.py:181-182 deja el neto negativo en `monto` y solo reporta `liquidacion_negativa`.
- **Pregunta abierta.** ¿Hay tope de descuento mensual? (pregunta #9).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
