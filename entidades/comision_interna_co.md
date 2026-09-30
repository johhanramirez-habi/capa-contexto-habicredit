# Comisión interna — HabiCredit CO

```yaml
entity: "Comisión interna CO"
aliases: ["comisión", "fila de comisión", "id_comision", "comisión final", "indicador comisionable"]
domain: "Comisiones"
market: ["CO"]
description: >
  Pago variable mensual de un empleado de HabiCredit Colombia por un indicador concreto.
  Sale de comparar su ejecución del mes contra la meta y aplicar la banda de pago de su
  posición sobre la base comisionable. No hay anticipos: se paga por cumplimiento mensual.
grain: "mes_comision × beneficiado × indicador (id_comision = 'YYYY-MM|correo|indicador')"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_fn_table
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_final
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_finanzas
key_attributes:
  - name: "mes_comision"
    description: "primer día del mes comisionado (DATE)"
  - name: "posicion"
    description: "cargo que define qué bandas de pago aplican"
  - name: "beneficiado"
    description: "correo de la persona que cobra"
  - name: "indicador"
    description: "métrica comisionable (metric_category)"
  - name: "ejecucion / meta_value / p_ejecucion"
    description: "valor logrado, meta y % de cumplimiento"
  - name: "base_commission / pago"
    description: "base comisionable y monto a pagar (COP)"
  - name: "tipo (solo en la base de finanzas)"
    description: "Indicador / Retroactivo / Bonos"
relationships:
  - related_entity: "Beneficiado de comisiones CO"
    relationship: "cada fila pertenece a un beneficiado"
  - related_entity: "Posición comisionable CO"
    relationship: "cada fila se calcula con las bandas de una posición"
  - related_entity: "Indicador de comisiones CO"
    relationship: "cada fila mide un indicador"
  - related_entity: "Meta de comisiones CO"
    relationship: "cada fila se cruza con exactamente una meta (email + indicador + mes)"
  - related_entity: "Confirmación de comisión"
    relationship: "cada fila tiene 0..1 confirmación del beneficiado"
business_rules_ref: ["RN-CO-001", "RN-CO-002", "RN-CO-003", "RN-CO-004", "RN-CO-005", "RN-CO-006", "RN-CO-007", "RN-CO-008", "RN-CO-009", "RN-CO-010", "RN-CO-021", "RN-CO-022"]
owner: "sin evidencia en el material fuente (agent.md:7: BI Liquidez la calcula desde marzo 2025; el traslado a Finanzas es manual)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: CLAUDE.md:3-17; sql/comisiones_co/README.md:24-37; sql/comisiones_co/comisiones_internas_hc.sql:1-4; comisiones_internas_hc_final.sql
```

## Notas
- El destino no está claro:
  - La vista `comisiones_internas_hc_final_vw` está comentada en el SQL del paso 2, pero `visor_vista.sql` y `conciliacion.sql` leen `comisiones_internas_hc_final`.
  - `sql/comisiones_co/README.md:13-16` dice que la salida del paso 1 es `comisiones_internas_hc`, pero el código escribe en `comisiones_internas_hc_fn_table`.
- La cobertura también difiere: agent.md dice "desde marzo 2025", mientras que las metas y la base de finanzas empiezan en 2025-02.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
