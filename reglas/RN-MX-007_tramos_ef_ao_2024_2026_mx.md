# RN-MX-007 — Tramos EF/AO del esquema 2024-2026 (MX)

```yaml
rule_id: "RN-MX-007"
name: "Tramos de % EF/AO con doble condición"
domain: "Comisiones"
market: ["MX"]
description: >
  El EF y el AO cobran un % del crédito que depende de dos condiciones en el mes de
  aceptación: el tamaño del equipo y su propio conteo individual.
applies_to: ["% de comisión EF/AO MX"]
logic_summary: "equipo <= 8 o individual <= 3 → 0%; individual 4-7 → 0,100%; individual >= 8 → 0,125%. Cada rol usa su propio conteo individual"
sql_reference: |
  # config/reglas.yaml:212-216
  equipo_min: 9
  individual_cero: 3
  tramos:
    - {individual_max: 7,    valor: 0.00100}
    - {individual_max: null, valor: 0.00125}
exceptions: "referidor del negocio → 1% (RN-MX-012)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: config/reglas.yaml:196-216; docs/reglas.md:219-244; src/comisiones/motor.py:25-37
```

## Notas
- Contradicción documental: docs/reglas.md:219 y los pasos 5 y 11 del proceso mencionan un "reparto 50/50". El yaml y el código usan el % completo por rol; la tabla publicada de 0,2%/0,25% ya equivale a 0,1%/0,125% por rol.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
