# RN-CO-021 — La base auditada de Finanzas prevalece sobre el motor (CO)

```yaml
rule_id: "RN-CO-021"
name: "Prevalencia de la base auditada"
domain: "Comisiones"
market: ["CO"]
description: >
  Para cualquier mes ya auditado y pagado, la cifra válida es la de la base de Finanzas
  (congelada), no la que calcule hoy el motor. El motor solo se muestra para el mes
  abierto que Finanzas aún no tiene.
applies_to: ["Base de Finanzas de comisiones CO", "Comisión interna CO"]
logic_summary: "meses en finanzas → origen 'auditado', congelado = TRUE; meses no presentes en finanzas → origen 'motor'; unión por LEFT JOIN … IS NULL (nunca NOT IN)"
sql_reference: |
  -- sql/comisiones_co/visor_vista.sql:39-90 (resumen)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: visor_vista.sql:6-7; sql/validaciones/conciliacion.sql (conciliación motor vs finanzas)
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
