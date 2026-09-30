# Inmueble Habi (NID) — CO

```yaml
entity: "Inmueble Habi (NID) CO"
aliases: ["NID", "inmueble", "inmueble Habi"]
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Inmueble gestionado por las unidades de negocio iBuyer y Habinmobiliaria, identificado
  por el NID, un número único que asigna Habi. Es la garantía hipotecaria del crédito
  en las operaciones iBuyer.
grain: "un inmueble por NID"
source_tables:
  - "sin evidencia en el material fuente"
key_attributes:
  - name: "NID"
    description: "identificador único del inmueble asignado por Habi"
relationships:
  - related_entity: "Segmento iBuyer / non-iBuyer CO"
    relationship: "tener NID marca la operación como iBuyer"
  - related_entity: "Operación de crédito CO"
    relationship: "sin evidencia en el material fuente de la cardinalidad (un inmueble podría tener varias operaciones)"
business_rules_ref: []
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **MX es otro mercado.** En MX (negocio_hc_mx), el NID de la propiedad no es único por negocio y nunca se usa como llave. Esa regla no se traslada a CO sin validar.
- **NID en el proyecto vivo CO.** En comisiones CO, `NID` aparece como alias de identificación de la operación en `operacion_credito_co`. El documento lo define como identificador del *inmueble*, no de la operación. Queda por validar.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
