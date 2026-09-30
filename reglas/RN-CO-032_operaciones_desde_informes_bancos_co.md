# RN-CO-032 — Operaciones no reportadas por el broker se incorporan desde los informes de bancos (CO)

```yaml
rule_id: "RN-CO-032"
name: "Incorporación de operaciones desde informes de bancos"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Algunas operaciones se radican directamente en el banco (con el link para clientes Habi)
  sin pasar por la mesa Habi, y el broker puede no reportarlas en Creditool. El equipo de
  radicación cruza los informes que envían los bancos y las agrega a Pipefy para hacerles
  seguimiento. Para recibir su comisión, el broker tiene que registrarse.
applies_to: ["Operación de crédito CO", "Creditool", "Broker CO"]
logic_summary: "fuente de operaciones = registro del broker en Creditool + cruce de los informes de bancos; el broker debe estar registrado para cobrar comisión"
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
