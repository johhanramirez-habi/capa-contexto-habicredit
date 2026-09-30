# RN-MX-015 — Redondeo de montos (MX)

```yaml
rule_id: "RN-MX-015"
name: "Redondeo"
domain: "Comisiones"
market: ["MX"]
description: >
  Los montos de comisión se redondean a 2 decimales con redondeo half-up y se manejan en
  aritmética decimal exacta.
applies_to: ["Anticipo EF MX", "Anticipo Manager MX", "Liquidación neta EF/AO MX", "Liquidación Manager MX"]
logic_summary: "2 decimales, ROUND_HALF_UP"
sql_reference: |
  # config/reglas.yaml:68-71
  decimales: 2
  modo: ROUND_HALF_UP
  aplicar_en: total_por_colaborador_mes   # TODO confirmar
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: src/comisiones/motor.py:49-52; CLAUDE.md:66
```

## Notas
- Contradicción entre config y código: el yaml dice que se redondea el total por colaborador y mes (marcado TODO), pero el código redondea cada línea de pago.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
