# Attachment rate (AR) — CO

```yaml
metric: "Attachment rate CO"
aliases: ["AR_CI", "AR_PCV", "AR_E", "AR", "PCV"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Porcentaje de los negocios aplicables que terminan con crédito HabiCredit, medido en tres
  hitos: carta de intención (CI), promesa de compraventa (PCV) y escritura (E).
formula_business: "cierres con HabiCredit / negocios aplicables, por mes del hito"
formula_sql: |
  -- comisiones_internas_hc.sql:251-284 (extracto)
  SAFE_DIVIDE(SUM(cierres_habicredit_final), SUM(aplicable_final))
grain: "mes (valor global, igual para todos los beneficiados)"
filters_exclusions: "mes según c_fecha_carta_intencion, c_fecha_promesa o c_fecha_escritura"
source_tables:
  - "ar_ci_co, ar_pcv_co, ar_escritura_co (proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
known_caveats: "Unidad: %. No se mide por persona. El PDF cita como fuente el 'Tablero Attachment Rate OCD'."
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: conflicto con Habicredit_2024.docx resuelto por el usuario: el documento está desactualizado y prevalece la definición del SQL. La definición no cambió.

## Conflicto resuelto — Habicredit_2024.docx (2026-09-30)
El documento definía el AR de Carta de Intención sobre *radicación* y segmentado entre iBuyer e Inmobiliaria. **Decisión del usuario:** el documento está desactualizado, así que se usa la definición tal como está en el SQL (cierres / aplicables, valor global). El documento no se agrega como fuente de esta métrica.
