# Equipo de supervisor de legalización — HabiCredit CO

```yaml
entity: "Equipo de supervisor de legalización CO"
aliases: ["listas_supervisores_analistas", "analistas_sup_<supervisor>", "padrón supervisor → analistas"]
domain: "Comisiones"
market: ["CO"]
description: >
  Asignación mensual de analistas de legalización a cada supervisor. Define qué ejecución
  se suma al supervisor en los indicadores de equipo, como órdenes/escrituras o rotación.
grain: "mes × supervisor × analista"
source_tables:
  - "sin tabla: arrays de correos escritos a mano en comisiones_internas_hc.sql:53-149"
key_attributes:
  - name: "supervisor"
    description: "correo del supervisor"
  - name: "analistas"
    description: "array de correos de su equipo en el mes"
relationships:
  - related_entity: "Beneficiado de comisiones CO"
    relationship: "un supervisor tiene muchos analistas por mes"
business_rules_ref: []
owner: "sin evidencia en el material fuente (la asignación la entrega el área de Legalización, comisiones_internas_hc.sql:65)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: sql/comisiones_co/comisiones_internas_hc.sql:53-149
```

## Notas
- La asignación cambió en 2026-05, 2026-07, 2026-08 y 2026-09.
- Queda un mapeo marcado "CONFIRMAR": un supervisor que aparece con otro nombre en la tabla de Legalización (comisiones_internas_hc.sql:93-96).
- El visor no tiene un padrón líder → persona equivalente (apps_script/README.md:80-81).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
