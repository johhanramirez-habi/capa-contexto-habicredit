# Cumplimiento de rotación — CO

```yaml
metric: "Cumplimiento de rotación CO"
aliases: ["cumplimiento_rotacion", "cumplimiento_gestion_rotacion"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Qué tanto logra el analista (o el equipo) sacar operaciones de sus fases de
  legalización frente al objetivo semanal.
formula_business: "suma de salidas semanales / suma del objetivo semanal, en las semanas de rotación del mes"
formula_sql: |
  -- comisiones_internas_hc.sql:674-781 (resumen)
  SUM(salidas_semana) / SUM(objetivo_semanal)   -- excluye 'Fase 5'
grain: "mes_comision × analista (supervisor: su equipo; gerente: global)"
filters_exclusions: "excluye 'Fase 5'; analista: solo foto del viernes y semanas del array semanas_rotacion"
source_tables:
  - "tablas de rotación de legalización (histórica y actual; proyecto/dataset no especificado en el extracto)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: >
  Unidad: %. Metas: 0,75 para el analista y 0,7 para el supervisor. En agosto 2026 se quitó
  la semana del 2026-08-03 "por falta de confianza en los datos"; hay que revisar
  festivos. Marzo 2026 tiene overrides manuales por analista. El PDF describe cortes a
  mediados y a final de mes.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
