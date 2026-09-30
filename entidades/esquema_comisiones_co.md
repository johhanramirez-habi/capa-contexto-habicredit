# Esquema de comisiones mensual (PDF) — HabiCredit CO

```yaml
entity: "Esquema de comisiones CO"
aliases: ["Esquemas", "Esquema de Comisiones Habicredit COL", "PDF del mes"]
domain: "Comisiones"
market: ["CO"]
description: >
  Documento mensual (PDF) aprobado por el negocio. Define, por cargo, los indicadores, las
  metas, los pesos, las bandas de pago, las penalizaciones y los bonos. Es la fuente de
  verdad del negocio y cambia cada mes.
grain: "un documento por mes (ej. 202607, 202608)"
source_tables:
  - "sin tabla BigQuery: Esquemas/2026MM Comisiones Habicredit COL.pdf"
key_attributes:
  - name: "sección por cargo"
    description: "Gerente Comercial, Director Comercial non-iBuyer, K.A.M., Ejecutivos, Supervisores y Analistas de Radicación/Legalización, Gerente de Ops Liquidez, Bono por sobreejecución"
  - name: "fuentes de cumplimiento citadas"
    description: "Seguimiento Comercial-Modelo OCD, Tablero Comercial OCD, Tablero UX CSAT, Tablero Attachment Rate OCD, Informes de pipefy"
relationships:
  - related_entity: "Meta de comisiones CO"
    relationship: "las metas del mes se extraen de este documento"
  - related_entity: "Posición comisionable CO"
    relationship: "el documento tiene una sección por posición"
business_rules_ref: ["RN-CO-007", "RN-CO-014", "RN-CO-018", "RN-CO-019"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: CLAUDE.md:16-23; Esquemas/202607 y 202608 (PDF)
```

## Notas
- Es la variante de Colombia de [esquema_comisiones_mx.md](esquema_comisiones_mx.md), pero la estructura es distinta. En CO hay un documento por mes y cargo con bandas de cumplimiento. En MX hay esquemas plurianuales resueltos por la fecha de aceptación.
- Algunas reglas del PDF no están en el SQL: la penalización CSAT y el bono por sobreejecución.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
