# Confirmación de comisión

```yaml
entity: "Confirmación de comisión"
aliases: ["confirmación", "comisiones_confirmaciones", "comisiones_resultado"]
domain: "Comisiones"
market: ["CO"]
description: >
  Respuesta del beneficiado a su comisión calculada: la acepta o la rechaza con un
  comentario. Los rechazos van a BI y deberían alimentar un futuro motor de retroactivos.
grain: "id_comision (1 a 1 con la fila de comisión)"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_confirmaciones
key_attributes:
  - name: "id_comision / periodo / correo_usuario"
    description: "fila de comisión confirmada, mes (YYYY-MM) y beneficiado"
  - name: "monto_comision"
    description: "monto de la comisión en el momento de responder (snapshot)"
  - name: "estado"
    description: "PENDIENTE | ACEPTADA | RECHAZADA"
  - name: "comentario"
    description: "obligatorio al rechazar"
  - name: "fecha_respuesta / fecha_creacion / fecha_modificacion"
    description: "trazabilidad"
relationships:
  - related_entity: "Comisión interna CO"
    relationship: "una comisión tiene 0..1 confirmación"
business_rules_ref: ["RN-CO-020"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: sql/create_comisiones_confirmaciones.sql:7-21; config.py:54; services/data_service.py:215-251
```

## Notas
- **Alcance de país.** README.md y agent.md dicen que la app es para usuarios de CO y de MX, pero la tabla no tiene columna de país. Por eso la dejé en `market: ["CO"]` hasta que haya evidencia de uso en MX.
- **Dos esquemas distintos para la misma tabla.** La Guía (`Guia_App_Confirmacion_Comisiones.md`) describe `comisiones_resultado`, con estados en minúscula y la columna `negocio_id`. El DDL describe `comisiones_confirmaciones`. Además, `Codigo.gs` escribe una columna `respondido_por` que no existe en el DDL.
- El motor de retroactivos todavía no existe (README.md:201).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
