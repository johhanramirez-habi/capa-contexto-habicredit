# Cumplimiento de meta en el WBR de Liquidez — CO

```yaml
metric: "Cumplimiento de meta WBR Liquidez CO"
aliases: ["cumplimiento", "% cumplimiento (WBR)"]
domain: "Liquidez (WBR)"
market: ["CO"]
regional_variant_of: ""
description: >
  Qué tanto va el mes contra su meta en el WBR. En radicaciones y desembolsos compara el
  acumulado del mes contra la meta prorrateada al día del corte; en la rotación compara la
  meta de días contra la última semana cerrada.
formula_business: "flujos: MTD actual / meta del mes corrido × 100. Rotación: meta (70 días) / rotación de la última semana cerrada × 100"
formula_sql: |
  -- liquidez/wbr_liquidez_co.sql:219-239 (extracto)
  ROUND(SAFE_DIVIDE(<mtd_actual del conteo>, NULLIF(meta_corrida, 0)) * 100, 4)
  ROUND(SAFE_DIVIDE(meta_rotacion, NULLIF(<rotación última semana cerrada>, 0)) * 100, 4)
grain: "indicador × fecha de corte"
filters_exclusions: "flujos: solo la serie de conteo (radicaciones, desembolsos), no la de monto; rotación: semana cerrada = su domingo ya pasó (fecha + 6 <= corte)"
source_tables:
  - papyrus-delivery-data.habicredit.wbr_liquidez
  - papyrus-delivery-data.corp_gov_global.wbr_metas_pais
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
known_caveats: >
  Unidad: %. Se pinta verde desde 100%. La meta del mes corrido usa la curva estacional
  (RN-CO-025), no un prorrateo lineal. Antes, la rotación se calificaba contra el último
  punto mensual, que era el mes anterior al corte; se corrigió para usar la última semana
  cerrada (RN-CO-026). Es una métrica distinta de pct_cumplimiento_indicador_co
  (comisiones), aunque comparte la idea de invertir cuando menos es mejor (RN-CO-005).
```

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
