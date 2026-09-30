# RN-MX-008 — Manager: monto por aprobación y tope del periodo (MX)

```yaml
rule_id: "RN-MX-008"
name: "Monto por aprobación del Manager con tope"
domain: "Comisiones"
market: ["MX"]
description: >
  El Manager gana un monto fijo por cada aprobación del equipo, según el tamaño del
  equipo en el mes de aceptación, con un tope de 25.000 MXN por periodo. Al escriturar
  no se recalcula el tramo: se usa lo que se anticipó.
applies_to: ["Anticipo Manager MX", "Liquidación Manager MX"]
logic_summary: "equipo 0-8 → 0; 9-16 → 500 MXN; 17+ → 1.000 MXN por aprobación; al liquidar, total = anticipo / 30%; si el total del mes supera el tope, se prorratea con factor = tope / total"
sql_reference: |
  # config/reglas.yaml:220-224
  mgr_tramos:
    - {equipo_min: 0,  equipo_max: 8,    valor: 0}
    - {equipo_min: 9,  equipo_max: 16,   valor: 500}
    - {equipo_min: 17, equipo_max: null, valor: 1000}
  mgr_tope_periodo: 25000
exceptions: "el tope no se aplica a los anticipos; en el esquema 2023 la bolsa del Manager era de 10.000 MXN (RN-MX-020)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:471-489; src/comisiones/motor.py:40-46,196-241
```

## Notas
- La tabla se reconstruyó por ingeniería inversa de la práctica 2025-2026 (docs/reglas.md:471-482).
- Pregunta abierta: ¿el tope aplica al mes de pago o a la cohorte de aceptación? (reglas.yaml:225-226). El código lo aplica al mes de pago. Abril 2026 fue el primer mes que tensionó el tope.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
