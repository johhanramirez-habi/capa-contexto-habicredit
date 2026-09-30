# Funnel de HabiCredit (flujo de negocio) — CO

```yaml
entity: "Funnel de HabiCredit CO"
aliases: ["funnel", "modelo operativo", "flujo de negocio", "etapas del crédito"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Secuencia de etapas por las que pasa una solicitud de crédito hipotecario en HabiCredit,
  desde el análisis previo del cliente hasta que el banco desembolsa. Cada etapa tiene
  indicadores y acuerdos de servicio (ANS) propios, y su ejecución varía por banco.
grain: "una fila por etapa del funnel"
source_tables:
  - "sin tabla BigQuery: descrito en Habicredit_2024.docx (el documento menciona Pipefy y Creditool como sistemas de registro)"
key_attributes:
  - name: "Viabilidad (Pre-Aprobado)"
    description: "análisis previo del cliente potencial (situación financiera, historial, ingresos, score). Opcional para radicar"
  - name: "Radicación en Mesa Habi"
    description: "el broker crea la solicitud en Creditool; llega por Pipefy a la mesa de radicación, que la ajusta a la política documental de cada banco o la devuelve al broker"
  - name: "Radicación en Banco"
    description: "la operación entra al banco (correo o plataforma del banco); si tiene novedades se devuelve a Habi para subsanar"
  - name: "Aprobación"
    description: "análisis de crédito del banco con tres resultados posibles: aprobado, aprobado por menor valor o negado"
  - name: "Bolsa de aprobados"
    description: "créditos aprobados que todavía no entran a legalización (ver bolsa_aprobados_co)"
  - name: "Legalización"
    description: "constitución de la garantía hipotecaria, desde el contacto inicial del banco hasta el desembolso. Subetapas típicas: contacto inicial / examen médico, avalúo, consecución de documentos para el estudio de títulos, estudio de títulos, escrituración, firma del apoderado, registro y documentos para desembolso"
  - name: "Desembolso"
    description: "el banco entrega los fondos; la etapa se da por cumplida con el informe oficial del banco"
relationships:
  - related_entity: "Operación de crédito CO"
    relationship: "cada operación recorre las etapas del funnel"
  - related_entity: "Bolsa de aprobados CO"
    relationship: "la bolsa es la etapa intermedia entre la aprobación y la legalización"
  - related_entity: "Documento de crédito CO"
    relationship: "viabilidad, pre-aprobado y aprobado se emiten en etapas distintas del funnel"
  - related_entity: "Entidad financiera aliada CO"
    relationship: "cada banco ejecuta las etapas a su manera (legalización tercerizada, abogados internos o externos, notarías convenio, desembolso contra boleta de registro o primera copia, etc.)"
business_rules_ref: ["RN-CO-031", "RN-CO-033", "RN-CO-034", "RN-CO-037", "RN-CO-038"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Inconsistencia del propio documento.** Sus definiciones separan *Viabilidad* (documento de la herramienta HabiCredit, sin validez ante bancos) y *Pre-Aprobado* (documento emitido por un banco), pero el funnel las presenta como una sola etapa: "Viabilidad (Pre-Aprobado)".
- **Diferencia entre el diagrama y el texto.** El diagrama muestra: Viabilidad → Radicado en Mesa Habi → Radicado en Banco → Aprobación → Inicio legalización → Escrituración → Desembolso. El texto agrega la etapa de Bolsa y las subetapas de legalización.
- **Excepción de producto.** Compra de cartera y retanqueo siguen un camino más corto (RN-CO-037).
- **Fuentes que el documento menciona y no están en esta carpeta.** Los manuales operativos del equipo de Liquidez (gestión comercial y OPS) y los tableros de Looker con los KPI por etapa.
- La etapa de la operación en `main_board` (proyecto vivo) no se cruzó con este flujo. Queda por validar si las fases actuales coinciden.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
