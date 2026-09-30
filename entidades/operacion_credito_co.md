# Operación de crédito (main_board) — HabiCredit CO

```yaml
entity: "Operación de crédito CO"
aliases: ["operación", "negocio", "report_id", "NID", "card_id", "radicación"]
domain: "Comisiones"
market: ["CO"]
description: >
  Solicitud de crédito que HabiCredit Colombia tramita ante un banco. Recorre las fases de
  radicación, aprobación o sanción, legalización y desembolso (el desembolso cierra la
  legalización). Es la unidad a partir de la cual se calcula la ejecución de la mayoría
  de indicadores comisionables.
grain: "sin evidencia en el material fuente sobre la llave exacta de main_board (se usan report_id, NID y card_id según la tabla)"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - papyrus-master.liquidez_platinum_co.fct_radicacion
key_attributes:
  - name: "fecha_radicacion / fecha_radicacion_u / fecha_radicacion_colex"
    description: "radicación total, radicación única (primera por cliente) y radicación de clientes en el exterior"
  - name: "fecha_aprobacion / fecha_desembolso"
    description: "fechas de aprobación y desembolso del banco"
  - name: "monto_solicitado / monto_solicitado_u / monto_aprobado / monto_desembolso"
    description: "montos (COP)"
  - name: "banco / tipo_producto / linea_credito / tu_credito_es"
    description: "atributos del crédito (tu_credito_es='Tradicional' filtra los días de aprobación/sanción)"
  - name: "correo_director_comercial / correo_broker / kam / analistas"
    description: "a quién se atribuye la operación en cada indicador"
relationships:
  - related_entity: "Beneficiado de comisiones CO"
    relationship: "una operación se atribuye a varios beneficiados según el rol (director, KAM, analista)"
  - related_entity: "Broker CO"
    relationship: "una operación puede venir de un broker"
business_rules_ref: ["RN-CO-016", "RN-CO-017"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3); Habicredit_2024.docx (fuentes/documentos; desactualizado - por validar)"
# evidencia: sql/comisiones_co/comisiones_internas_hc.sql:10-50,394,888,987-988
```

## Notas
- La columna `mes_aprob_vs_rad` se usa pero no se define en la CTE, así que viene de `main_board`. Su definición de origen no tiene evidencia en el material fuente.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: corregido el orden de las fases (antes decía "desembolso y legalización"). Ese orden era redacción de la extracción, no evidencia del SQL. Decisión del usuario tras el cruce con Habicredit_2024.docx, que se agrega como fuente adicional (flujo de negocio por validar: ver [funnel_habicredit_co.md](funnel_habicredit_co.md)).
