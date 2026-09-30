# RN-CO-028 — La originación ocurre con la aprobación (CO)

```yaml
rule_id: "RN-CO-028"
name: "Originación = aprobación, no desembolso"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Un crédito se considera originado cuando el banco lo aprueba formalmente, no cuando lo
  desembolsa. La originación es el inicio formal del financiamiento por parte del banco.
applies_to: ["Operación de crédito CO", "Funnel de HabiCredit CO", "Tasa de aprobación CO"]
logic_summary: "hito de originación = aprobación del crédito por el banco; el desembolso es un hito posterior"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
