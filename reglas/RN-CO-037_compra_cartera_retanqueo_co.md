# RN-CO-037 — Compra de cartera y retanqueo siguen un camino corto de legalización (CO)

```yaml
rule_id: "RN-CO-037"
name: "Legalización abreviada para compra de cartera y retanqueo"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Las compras de cartera y los créditos "Permanecerá Vigente" (retanqueo) no constituyen
  hipoteca nueva. Por eso no pasan por estudio de títulos, escrituración ni registro:
  después del avalúo van directo a "Documentos Desembolso".
applies_to: ["Funnel de HabiCredit CO"]
logic_summary: "si la línea es compra de cartera o Permanecerá Vigente → avalúo → Documentos Desembolso (oferta vinculante y/o valorización de la garantía) → desembolso"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "si el crédito va atado a un crédito hipotecario sí requiere escrituración"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
