# Beneficiado de comisiones — HabiCredit CO

```yaml
entity: "Beneficiado de comisiones CO"
aliases: ["beneficiado", "email", "correo_usuario", "employee", "analista", "correo_analista", "analista_legalizacion", "analista_radicacion", "asignacion_analista", "kam", "correo_director_comercial", "director", "email_director"]
domain: "Comisiones"
market: ["CO"]
description: >
  Empleado de HabiCredit Colombia que recibe comisión interna. Se identifica siempre por
  su correo, nunca por el nombre.
grain: "correo (normalizado con LOWER(TRIM()))"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
key_attributes:
  - name: "beneficiado / email"
    description: "correo, llave estable del beneficiado"
  - name: "employee"
    description: "nombre tal como viene en metas; no se usa como llave"
relationships:
  - related_entity: "Posición comisionable CO"
    relationship: "un beneficiado puede tener más de una posición en el mismo periodo (observado)"
  - related_entity: "Comisión interna CO"
    relationship: "un beneficiado tiene muchas filas de comisión por mes"
  - related_entity: "Equipo de supervisor de legalización CO"
    relationship: "un analista pertenece al equipo de un supervisor en un mes"
business_rules_ref: ["RN-CO-001", "RN-CO-016"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: .claude/skills/extraccion-metas/SKILL.md:106-109; Guia_App_Confirmacion_Comisiones.md:37; sql/validaciones/barrido_cambios_mes.sql:29; visor_vista.sql:50
```

## Notas
- Conviven los dominios `@habi.co` y `@habicredit.co`, y hay variantes de un mismo correo en el SQL (comisiones_internas_hc.sql:130).
- Hay beneficiados con varias posiciones a la vez; por ejemplo, un supervisor de legalización aparece también como Ejecutivo Cero Goles y en posiciones de pre-legalización.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
