# Entidad financiera aliada (banco) — CO

```yaml
entity: "Entidad financiera aliada CO"
aliases: ["banco", "banco aliado", "entidad financiera"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Banco o cooperativa con el que HabiCredit tiene un contrato de corretaje. Analiza y
  aprueba los créditos, ejecuta la legalización con sus propios proveedores (peritos,
  abogados, notarías) y le paga a HabiCredit una comisión sobre lo desembolsado.
grain: "una fila por entidad"
source_tables:
  - "sin evidencia en el material fuente (en el proyecto vivo, el banco aparece como columna banco de main_board)"
key_attributes:
  - name: "nombre"
    description: "el documento lista AV Villas, BBVA, Bancolombia, Banco de Bogotá, Itaú, Scotiabank Colpatria, Credifamilia, Banco Caja Social y Grupo Coomeva (banco y cooperativa); lista desactualizada"
  - name: "escala de comisión"
    description: "comisión negociada por entidad según volumen y monto desembolsado (valores omitidos)"
  - name: "particularidades de proceso"
    description: "cada banco ejecuta distinto la legalización: tercerización, abogados internos o externos, notarías convenio, desembolso contra boleta de registro o primera copia, momento de la carta de aprobación en firme, entre otras"
relationships:
  - related_entity: "Funnel de HabiCredit CO"
    relationship: "cada banco ejecuta las etapas del funnel a su manera"
  - related_entity: "Operación de crédito CO"
    relationship: "cada operación se radica ante un banco"
business_rules_ref: ["RN-CO-029", "RN-CO-030"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Lista de bancos sin validar.** Es la del documento antiguo y puede haber cambiado: se pueden haber sumado o retirado entidades.
- **Bancos en el proyecto vivo.** El proyecto vivo de comisiones menciona bancos en reglas y exclusiones, por ejemplo COLPATRIA y BANCODEBOGOTA; los nombres no se cruzaron con esta lista.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
