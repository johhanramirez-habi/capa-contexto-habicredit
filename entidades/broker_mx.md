# Broker inmobiliario — HabiCredit MX

```yaml
entity: "Broker MX"
aliases: ["BRK", "broker", "broker inmobiliario"]
domain: "Comisiones"
market: ["MX"]
description: >
  Intermediario inmobiliario externo que cobra comisión por los negocios que trae. Su pago
  es un proceso separado del de colaboradores internos: exige desembolso y factura
  aprobada. En el proyecto está documentado pero no implementado.
grain: "sin evidencia en el material fuente"
source_tables:
  - papyrus-master.operations_habi_mx_buyers.funnel_buyers_mx
  - papyrus-master.dm_habi_mx_dwh_bi.operacion_general_buyers_mx
key_attributes:
  - name: "c_correo_broker"
    description: "correo del broker (filtro c_status like '%Venta 1%' y broker no nulo)"
  - name: "c_canal_venta"
    description: "sin evidencia en el material fuente sobre su significado"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un broker trae muchos negocios"
business_rules_ref: ["RN-MX-018"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:42,493-510; config/reglas.yaml:230-255; sql/escrituracion_mes.plain.sql:4-10
```

## Notas
- Ver [broker_co.md](broker_co.md). En CO el broker no cobra en este motor; solo alimenta indicadores de los directores comerciales. Es otro concepto, no el mismo con otros parámetros.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
