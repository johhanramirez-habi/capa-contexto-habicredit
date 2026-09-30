# Bolsa de aprobados — CO

```yaml
entity: "Bolsa de aprobados CO"
aliases: ["bolsa", "gestión de bolsa", "bolsa de aprobados"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Etapa donde quedan los créditos aprobados que, por alguna condición, todavía no entran
  al proceso de legalización con el banco. También llegan aquí los créditos que el equipo
  de legalización devuelve porque no pueden continuar. Los analistas de bolsa los
  clasifican y les hacen seguimiento hasta que salen de su categoría o vence la
  aprobación.
grain: "operación aprobada × categoría de bolsa"
source_tables:
  - "sin evidencia en el material fuente (en el proyecto vivo de comisiones existen pipe_bolsa y HC_OKR_dias_habiles_bolsa, no cruzadas con este documento)"
key_attributes:
  - name: "Inmueble indefinido"
    description: "aprobado sin inmueble definido (nuevo o usado) para constituir la hipoteca"
  - name: "Gestión con cliente"
    description: "inmueble definido pero falta que el cliente aporte el certificado de tradición (CTL) o la promesa de compraventa (PCV), o que firme documentos en el banco; incluye clientes indecisos, clientes ilocalizados y operaciones que requieren cambio de condiciones"
  - name: "Inmueble en proceso"
    description: "el inmueble aún no cumple requisitos: en vivienda nueva, fecha de escrituración, avance de obra, estudio de títulos del proyecto o reglamento de propiedad horizontal; en usada, problemas jurídicos (gravámenes o limitaciones)"
  - name: "Suspendido pendiente confirmación banco"
    description: "documentos en revisión del banco para iniciar la legalización"
  - name: "Créditos apagados"
    description: "operaciones desistidas por el cliente, negadas en definitiva o con la aprobación vencida"
relationships:
  - related_entity: "Funnel de HabiCredit CO"
    relationship: "etapa entre la aprobación y la legalización"
  - related_entity: "Broker CO"
    relationship: "el broker informa por un buzón del equipo de bolsa cuando el cliente destraba la operación"
business_rules_ref: ["RN-CO-035", "RN-CO-036"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Entrada directa al banco.** El cliente también puede enviar directamente al banco lo que falta para iniciar la legalización. En ese caso, el equipo de bolsa detecta el avance en los informes del banco y mueve la operación a legalización.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
