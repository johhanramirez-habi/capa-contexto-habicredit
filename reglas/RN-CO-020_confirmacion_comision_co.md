# RN-CO-020 — Confirmación de comisión por el beneficiado (CO)

```yaml
rule_id: "RN-CO-020"
name: "Confirmación de comisión"
domain: "Comisiones"
market: ["CO"]
description: >
  Cada persona revisa sus comisiones del mes y las acepta o rechaza. Solo puede responder
  las suyas, y un rechazo debe llevar un comentario.
applies_to: ["Confirmación de comisión", "Comisión interna CO"]
logic_summary: "MERGE por id_comision; estados PENDIENTE → ACEPTADA / RECHAZADA (se puede volver a PENDIENTE); rechazo sin comentario = error; la persona solo ve y responde lo suyo (filtro en servidor, fallo cerrado si no hay correo); quien responde se toma de la sesión"
sql_reference: |
  -- sql/create_comisiones_confirmaciones.sql:7-19
  estado: PENDIENTE | ACEPTADA | RECHAZADA
exceptions: "administradores configurados pueden ver más allá de lo propio (apps_script/Codigo.gs:45-49)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: services/data_service.py:215-251; api/schemas.py:15-19; apps_script/Codigo.gs:59-67,177-182,300-330
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
