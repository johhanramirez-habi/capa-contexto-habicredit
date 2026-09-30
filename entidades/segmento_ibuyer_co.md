# Segmento iBuyer / non-iBuyer — CO

```yaml
entity: "Segmento iBuyer / non-iBuyer CO"
aliases: ["iBuyer", "ibuyer", "non-iBuyer", "non ibuyer", "no iBuyer", "Inmobiliaria"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Clasificación de las operaciones según el inmueble. iBuyer son las operaciones de venta
  o financiamiento de inmuebles del inventario Habi (incluidos los captados por
  Habinmobiliaria), que tienen NID. non-iBuyer son las que financian inmuebles fuera del
  inventario Habi, sin NID (casas, lotes, locales comerciales, entre otros).
grain: "operación"
source_tables:
  - "sin evidencia en el material fuente"
key_attributes:
  - name: "segmento"
    description: "iBuyer | non-iBuyer"
  - name: "NID"
    description: "presente en iBuyer, ausente en non-iBuyer (ver inmueble_nid_co)"
relationships:
  - related_entity: "Inmueble Habi (NID) CO"
    relationship: "una operación iBuyer está asociada a un inmueble con NID"
  - related_entity: "Posición comisionable CO"
    relationship: "el proyecto vivo tiene posiciones separadas por segmento (Director ibuyer, Director non ibuyer)"
business_rules_ref: []
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Criterios distintos en el proyecto vivo.** En comisiones, las operaciones iBuyer se identifican por el correo del director comercial asignado (comisiones_internas_hc.sql:247, 1903), no por la presencia de NID. Los dos criterios podrían no coincidir; queda por validar.
- **"Inmobiliaria" como segmento.** El documento menciona "Inmobiliaria" como segmento aparte de iBuyer para medir el attachment rate. No queda claro si es lo mismo que non-iBuyer.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
