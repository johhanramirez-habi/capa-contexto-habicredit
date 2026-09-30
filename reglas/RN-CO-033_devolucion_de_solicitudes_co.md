# RN-CO-033 — Devolución de solicitudes en la radicación (CO)

```yaml
rule_id: "RN-CO-033"
name: "Devolución de solicitudes (mesa y banco)"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  La mesa de radicación de Habi ajusta la solicitud a la política documental de cada
  banco. Si hace falta que intervenga el broker, se la devuelve por la plataforma con
  las mejoras requeridas. Si el banco encuentra novedades, devuelve la operación a Habi
  para subsanarla y repetir el paso por la mesa.
applies_to: ["Funnel de HabiCredit CO", "Devolución banco CO", "Creditool"]
logic_summary: "mesa → broker: devolución por plataforma con el listado de mejoras; banco → Habi: devolución para subsanar y volver a radicar. El canal de radicación (digital o documentado) lo decide el broker según la actividad económica del cliente (asalariado, pensionado o independiente)"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "según el documento, la mesa puede corregir el formulario solo si llega en PDF editable; si no, se devuelve al broker"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Tiempos omitidos.** El documento fija ANS para la mesa y para el banco; se omiten por instrucción del usuario.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
