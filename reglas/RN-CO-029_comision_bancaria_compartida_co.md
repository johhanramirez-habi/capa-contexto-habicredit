# RN-CO-029 — Comisión bancaria sobre lo desembolsado, compartida con los actores (CO)

```yaml
rule_id: "RN-CO-029"
name: "Comisión bancaria y su distribución"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  HabiCredit opera como broker financiero: los bancos le pagan una comisión sobre el
  valor desembolsado, según una escala negociada con cada entidad por volumen y monto.
  HabiCredit comparte esa comisión con los actores que ayudaron a que el crédito se
  desembolsara y se queda con una parte.
applies_to: ["Entidad financiera aliada CO", "Broker CO", "Monto desembolsado CO"]
logic_summary: "ingreso = comisión del banco sobre el valor desembolsado (escala por entidad según volumen y monto); se reparte con Sellers Habi, Buyers Habi, brokers inmobiliarios Habi y no-Habi y brokers financieros; HabiCredit retiene el resto"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Valores omitidos a propósito.** El documento daba porcentajes de la comisión bancaria y de la retención; se omiten por instrucción del usuario.
- **Tipos de broker.** La lista de actores es la del documento. El usuario confirmó que hoy existen brokers financieros, aliados/referidos e inmobiliarios ([broker_co.md](../entidades/broker_co.md)); el documento no menciona los aliados/referidos.
- **Qué comisión es.** Es la comisión que HabiCredit recibe de los bancos y reparte a actores externos o de Habi. No es la comisión interna a empleados que calcula el proyecto de comisiones.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
