# RN-CO-030 — Las comisiones se facturan contra el informe oficial de desembolso (CO)

```yaml
rule_id: "RN-CO-030"
name: "Facturación contra informe oficial del banco"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Un crédito se da por desembolsado cuando el banco lo confirma oficialmente en sus
  informes. Después del desembolso, HabiCredit factura al banco su comisión, y lo hace
  contra ese informe oficial. Una confirmación informal (p. ej. pantallazos de personal
  del banco) sirve para anticipar, pero no para facturar.
applies_to: ["Entidad financiera aliada CO", "Funnel de HabiCredit CO", "Cantidad de desembolsos CO", "Monto desembolsado CO"]
logic_summary: "etapa Desembolso = confirmación oficial del banco en su informe; facturación de comisión posterior al desembolso y contra el informe oficial"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Origen de la fecha en el proyecto vivo.** No hay evidencia de si `fecha_desembolso` de `main_board` (usada por las métricas de desembolso) sale del informe oficial del banco o de otra confirmación. Queda por validar.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
