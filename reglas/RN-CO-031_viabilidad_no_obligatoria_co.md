# RN-CO-031 — La viabilidad no es requisito para radicar (CO)

```yaml
rule_id: "RN-CO-031"
name: "Viabilidad opcional para radicar"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  La viabilidad (o el pre-aprobado) maximiza la probabilidad de aprobación, pero no la
  garantiza ni es obligatoria. El broker puede iniciar la radicación en la mesa Habi sin
  tener el pre-aprobado del banco.
applies_to: ["Funnel de HabiCredit CO", "Documento de crédito CO"]
logic_summary: "radicación permitida sin viabilidad previa; la viabilidad puede hacerse en Creditool o en el link del banco para clientes Habi"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "según el documento, al menos un banco exige por política su propia viabilidad, realizada por el broker"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
