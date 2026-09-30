# Broker — HabiCredit CO

```yaml
entity: "Broker CO"
aliases: ["broker", "h_broker_pk", "correo_broker"]
domain: "Comisiones"
market: ["CO"]
description: >
  Intermediario externo vinculado a HabiCredit Colombia que trae operaciones de crédito.
  Hay tres tipos: brokers financieros, aliados/referidos e inmobiliarios. En el motor de
  comisiones internas de CO no cobra comisión. Se usa como insumo de indicadores de los directores
  comerciales (brokers nuevos, graduaciones por categoría) y para atribuir operaciones a
  ejecutivos.
grain: "h_broker_pk"
source_tables:
  - papyrus-master.liquidez_platinum_co.dim_brokers
key_attributes:
  - name: "h_broker_pk"
    description: "llave del broker"
  - name: "correo_director / correo_personal"
    description: "director comercial al que pertenece y correo del broker"
  - name: "fecha_inicio_contrato"
    description: "define si el broker es 'nuevo' en un mes"
  - name: "categoría"
    description: "standard, elite, plus (graduaciones)"
relationships:
  - related_entity: "Beneficiado de comisiones CO"
    relationship: "un director comercial tiene muchos brokers"
  - related_entity: "Operación de crédito CO"
    relationship: "un broker trae muchas operaciones"
business_rules_ref: []
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app); Habicredit_2024.docx (fuentes/documentos; desactualizado - por validar)"
# evidencia: sql/comisiones_co/comisiones_internas_hc.sql:1014-1058,1586-1657
```

## Notas
- Es un concepto distinto de [broker_mx.md](broker_mx.md): en MX el broker cobra su propia comisión. Por eso los dejé en dos archivos separados.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: descripción ajustada tras el cruce con Habicredit_2024.docx. El usuario confirmó que hay brokers financieros, aliados/referidos e inmobiliarios (antes decía solo "intermediario inmobiliario"). El documento se agrega como fuente adicional.

## Tipos de broker
- **Confirmación del usuario (2026-09-30).** Hay brokers **financieros**, **aliados/referidos** e **inmobiliarios**.
- **Definiciones del documento** (Habicredit_2024.docx, desactualizado, por validar):
  - *Broker inmobiliario*: acompaña al cliente a encontrar el inmueble.
  - *Broker financiero*: perfila al cliente, conoce la oferta de los bancos y radica la operación. Una misma persona puede ser las dos cosas.
  - El documento no define el tipo "aliado/referido".
- **Vacío.** No hay evidencia en el material fuente de una columna en `dim_brokers` que distinga el tipo de broker.

