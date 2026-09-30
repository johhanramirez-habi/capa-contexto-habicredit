# RN-MX-012 — Referido interno al 1%, rama excluyente (MX)

```yaml
rule_id: "RN-MX-012"
name: "Referido interno al 1%"
domain: "Comisiones"
market: ["MX"]
description: >
  Si un colaborador implicado en el negocio es quien lo refirió, cobra el 1% del crédito
  final en lugar de su tramo normal. Aplica a propiedades externas sin broker; si la
  persona es de Merbos o HabiCredit, solo recibe el 1%. El referido se declara a mano y
  requiere aprobación.
applies_to: ["Comisión referido interno MX", "% de comisión EF/AO MX", "Referido interno MX"]
logic_summary: "si colaborador == referidor → pct = 1% sobre Monto_final_credito (excluyente a nivel negocio); anticipo 30% × 1% si está declarado al aceptar; vigente desde 2023-07-01 (retroactivo)"
sql_reference: |
  # config/reglas.yaml:123-146 (extracto)
  porcentaje: 0.01
  base: Monto_final_credito
  vigente_desde: 2023-07-01
  fuente: referidos.csv
  referidor_debe_ser_implicado: true
  excluyente: true
  requiere_aprobacion: [head_habicredit, director]
  aplica_anticipo: true
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente (aprobación: head de HabiCredit o director)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:264-286; src/comisiones/motor.py:106-108,171-172
```

## Notas
- **Validaciones del yaml sin implementar.** `referidor_debe_ser_implicado`, `validar_rol_declarado` y `requiere_aprobacion` no se validan en el código; `aprobado_por` está vacío en las 20 filas.
- **Rol MGR sin cubrir.** El referido de rol MGR no tiene rama en el motor.
- **Preguntas abiertas.** ¿Los otros implicados cobran? ¿El referido cuenta para la meta?

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
