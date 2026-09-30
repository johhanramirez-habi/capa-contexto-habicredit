# Creditool (plataforma) — CO

```yaml
entity: "Creditool"
aliases: ["Creditool", "herramienta Habicredit", "plataforma Habicredit"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Plataforma desarrollada por Habi para gestionar los créditos de principio a fin. El
  broker crea ahí la solicitud, genera la viabilidad propia y consulta la trazabilidad
  del caso. Está conectada con Pipefy, desde donde llega a la mesa de radicación.
grain: "sin evidencia en el material fuente"
source_tables:
  - "sin evidencia en el material fuente"
key_attributes:
  - name: "solicitud"
    description: "creada por el broker; asocia el cliente al broker"
  - name: "trazabilidad"
    description: "estado del caso visible para el broker y el cliente"
relationships:
  - related_entity: "Broker CO"
    relationship: "el broker registra a sus clientes y debe estar registrado para recibir comisión"
  - related_entity: "Documento de crédito CO"
    relationship: "genera la viabilidad propia"
  - related_entity: "Funnel de HabiCredit CO"
    relationship: "punto de entrada de la radicación en mesa Habi"
business_rules_ref: ["RN-CO-032", "RN-CO-033"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Visión de producto del documento.** Según el documento, HabiCredit usa integraciones con los bancos bajo un esquema *Banking-as-a-Service* (BaaS). Así acelera la radicación, la pre-aprobación, la aprobación y la legalización, y muestra en la plataforma el estado en tiempo real. Es la visión de producto del documento; el alcance real de esas integraciones queda por validar.
- **Atención al broker.** El documento describe una atención multicanal: plataforma, teléfono, chat y presencial.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
