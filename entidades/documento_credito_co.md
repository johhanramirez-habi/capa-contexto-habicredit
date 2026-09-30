# Documento de crédito (viabilidad, pre-aprobado, aprobado) — CO

```yaml
entity: "Documento de crédito CO"
aliases: ["viabilidad", "pre-aprobado", "aprobado", "carta de aprobación"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Documentos que dan al cliente o al broker distintos niveles de certeza sobre el crédito,
  desde una estimación sin validez bancaria hasta la oferta formal del banco.
grain: "operación × tipo de documento"
source_tables:
  - "sin evidencia en el material fuente"
key_attributes:
  - name: "Viabilidad"
    description: "documento generado por la herramienta HabiCredit para que el cliente entienda las posibles condiciones del crédito; no tiene validez ante ninguna entidad financiera. Puede hacerse en Creditool (viabilidad propia) o en el link que algunos bancos crearon para clientes Habi (el link asegura que la operación quede asignada a Habi)"
  - name: "Pre-Aprobado"
    description: "documento del banco con una estimación preliminar de lo que podría prestar; sujeto a la radicación formal con todos los documentos"
  - name: "Aprobado / carta de aprobación"
    description: "documento del banco con la oferta formal y las condiciones del crédito; el monto puede variar según el avalúo del inmueble en legalización"
relationships:
  - related_entity: "Funnel de HabiCredit CO"
    relationship: "la viabilidad y el pre-aprobado anteceden la radicación; el aprobado sale de la etapa de aprobación"
  - related_entity: "Creditool"
    relationship: "la viabilidad propia se genera en Creditool"
business_rules_ref: ["RN-CO-031", "RN-CO-034"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Viabilidad y pre-aprobado.** El documento las define como cosas distintas, pero en el funnel las agrupa como una sola etapa (ver [funnel_habicredit_co.md](funnel_habicredit_co.md)).
- **Centrales de riesgo.** La información de la viabilidad debe cruzar con centrales de riesgo. El documento las nombra; no se copian aquí porque la lista puede estar desactualizada.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
