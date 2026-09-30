# RN-CO-035 — Cambio de condiciones de un crédito aprobado (CO)

```yaml
rule_id: "RN-CO-035"
name: "Cambio de condiciones"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Mientras el crédito está en la bolsa, el cliente puede pedir que se cambien las
  condiciones aprobadas. Los analistas de bolsa lo apoyan, pero el cambio lo decide el
  banco y se formaliza con una nueva carta de aprobación.
applies_to: ["Bolsa de aprobados CO", "Documento de crédito CO", "Reprocesos KAM CO"]
logic_summary: "condiciones que se pueden cambiar: monto, tasa, plazo, número de solicitantes, asegurado, entre otras. Aprueba el banco y emite una nueva carta"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Relación con el proyecto vivo.** El indicador de reprocesos KAM cuenta "reprocesos por cambio de condiciones" (`es_cambio_condiciones`). No se validó que sea el mismo concepto.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
