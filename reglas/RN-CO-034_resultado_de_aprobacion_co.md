# RN-CO-034 — Tratamiento según el resultado de la aprobación (CO)

```yaml
rule_id: "RN-CO-034"
name: "Resultado de aprobación: aprobado, menor valor o negado"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  El análisis de crédito del banco tiene tres resultados posibles, y cada uno sigue un
  camino distinto en la operación de Habi.
applies_to: ["Tasa de aprobación CO", "Funnel de HabiCredit CO", "Salvamentos CO", "Documento de crédito CO"]
logic_summary: "aprobado → se pide la carta de aprobación, un analista carga la información y el caso pasa a legalización. Aprobado por menor valor → se pide la carta y se contacta al cliente; si acepta, pasa a legalización; si no, se clasifica como negado. Negado → se registra la causal de negación y la Mesa de Salvamento evalúa si es candidato a reproceso"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Coincide con el proyecto vivo.** La Mesa de Salvamento es la misma que usa el indicador de salvamentos (ver [salvamentos_reproceso_creditos_co.md](../metricas/salvamentos_reproceso_creditos_co.md)).
- **Carga posterior a la aprobación.** La información se carga después de aprobar porque durante el proceso cambian condiciones: monto, plazo y sistema de amortización.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
