# Escrituración / Desembolso — HabiCredit MX

```yaml
entity: "Escrituración MX"
aliases: ["escritura", "escrituración", "desembolso", "liquidación", "base de escrituras del mes"]
domain: "Comisiones"
market: ["MX"]
description: >
  Hito en que se firma la escritura y el banco desembolsa el crédito (en MX son el mismo
  evento). Dispara la liquidación de la comisión: la comisión total del colaborador menos
  lo que ya recibió como anticipo.
grain: "negocio (card_id) × mes de escrituración"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
  - papyrus-master.operations_habi_mx_buyers.funnel_buyers_mx
  - papyrus-master.dm_habi_mx_dwh_bi.operacion_general_buyers_mx
key_attributes:
  - name: "Fecha_de_escrituracion"
    description: "fecha de escritura = desembolso; nula => solo existe anticipo"
  - name: "Monto_final_credito"
    description: "base de la liquidación (MXN)"
  - name: "c_correo_comercial (Buyer)"
    description: "asesor comercial; coalesce con correo_del_cerrador_o_asesor_inmobiliario"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "cada escrituración pertenece a un negocio"
  - related_entity: "Aceptación MX"
    relationship: "la liquidación usa el % resuelto con el mes de aceptación del negocio"
business_rules_ref: ["RN-MX-003", "RN-MX-011", "RN-MX-013"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/reglas.md:113-116; docs/fuentes.md:78-83; sql/escrituracion_mes.plain.sql:4-10,29-34
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
