# Aceptación — HabiCredit MX

```yaml
entity: "Aceptación MX"
aliases: ["aceptación", "aprobación con inmueble asignado", "aprobación", "base de aceptaciones del mes", "base de anticipos"]
domain: "Comisiones"
market: ["MX"]
description: >
  Hito en el que ya no hay duda de que el cliente quiere avanzar con el negocio. Es el
  evento que define la cohorte (mes de aceptación) con la que se cuenta la meta, se
  resuelve el esquema vigente y se paga el anticipo del 30%.
grain: "negocio (card_id) × mes de aceptación"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
key_attributes:
  - name: "Fecha_de_aceptacion"
    description: "DATE(c.fecha_salida_eleccion_propiedad) desde el 2024-07-01"
  - name: "Fecha_de_aceptacion_Forma_Anterior"
    description: "c.Fecha_de_aceptacion; se usa si Fecha_de_aceptacion es nula"
  - name: "corte_aceptacion"
    description: "presente en la fuente; documentado como irrelevante (docs/reglas.md:640)"
  - name: "banco_seleccionado + monto del banco"
    description: "su presencia marca la aceptación y da la base del anticipo"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "cada aceptación pertenece a un negocio"
  - related_entity: "Anticipo de comisión MX"
    relationship: "la aceptación genera los anticipos de EF y Manager"
business_rules_ref: ["RN-MX-002", "RN-MX-004", "RN-MX-005", "RN-MX-006"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/fuentes.md:74; sql/anticipos_mes.plain.sql:8-13,28; CLAUDE.md:26; docs/reglas.md:164-172
```

## Notas
- La pregunta abierta #4 de docs/reglas.md sigue sin respuesta: ¿"aceptación" y "aprobación con inmueble" son el mismo hito?

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
