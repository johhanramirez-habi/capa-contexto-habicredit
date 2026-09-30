# Variación semanal (WoW) y mensual (MoM) — WBR Liquidez CO

```yaml
metric: "Variación WoW / MoM WBR Liquidez CO"
aliases: ["WoW", "MoM", "week over week", "month over month", "variación"]
domain: "Liquidez (WBR)"
market: ["CO"]
regional_variant_of: ""
description: >
  Cambio porcentual de un indicador del WBR contra el periodo anterior: la última semana
  contra la previa (WoW) y el MTD del mes en curso contra el MTD del mes anterior al
  mismo día (MoM).
formula_business: "(actual − anterior) / anterior × 100, con 2 decimales; NULL si falta alguno de los dos o si el anterior es 0"
formula_sql: |
  -- liquidez/wbr_liquidez_co.sql:121-150 (extracto)
  CASE WHEN actual IS NULL OR anterior IS NULL OR anterior = 0 THEN NULL
       ELSE ROUND((actual - anterior) / anterior * 100, 2) END
grain: "indicador × fecha de corte"
filters_exclusions: "WoW: sobre la serie de conteo de Radicaciones y Desembolsos y sobre la rotación; MoM: solo Radicaciones y Desembolsos, sobre el MTD recortado (RN-CO-023); la rotación no tiene MoM"
source_tables:
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
known_caveats: >
  Unidad: %. Convención estándar para WoW y MoM. En otras áreas del mismo repo (p. ej.
  Franquicias) el MoM replicó hasta el 2026-08-20 un defecto de Tableau que lo invertía,
  (anterior − actual) / actual. Liquidez siempre mostró la convención estándar; la paridad
  se verificó contra el PDF del corte 2026-08-09 (Radicaciones 723 contra 1077 → −32,87%;
  Desembolsos 58 contra 119 → −51,26%). Dos decimales por decisión del área. En la
  rotación, un WoW positivo es mala noticia.
```

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
