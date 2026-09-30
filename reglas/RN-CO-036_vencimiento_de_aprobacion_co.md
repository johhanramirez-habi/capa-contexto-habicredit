# RN-CO-036 — Vencimiento de la aprobación (CO)

```yaml
rule_id: "RN-CO-036"
name: "Vencimiento de la aprobación"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Una aprobación tiene vigencia limitada. Si el crédito no sale de la bolsa antes de que
  venza, pasa a "créditos apagados". La vigencia depende del banco y de la línea de
  producto.
applies_to: ["Bolsa de aprobados CO"]
logic_summary: "el crédito permanece en su categoría de bolsa hasta salir de ella o hasta que vence la aprobación → créditos apagados. Vigencia variable según banco y línea (nueva, usada, compra de cartera, constructor individual, etc.)"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Plazos omitidos.** El documento da plazos de vigencia (promedio y extremos por banco); se omiten por instrucción del usuario.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
