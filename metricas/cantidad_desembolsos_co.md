# Cantidad de desembolsos — CO

```yaml
metric: "Cantidad de desembolsos CO"
aliases: ["desembolsos", "cantidad_desembolsos", "Desembolsos HC Bancario (WBR)"]
domain: "Comisiones"
market: ["CO"]
regional_variant_of: ""
description: >
  Número de créditos desembolsados en el mes. Se paga promediado con el monto
  desembolsado.
formula_business: "conteo de operaciones con fecha de desembolso en el mes"
formula_sql: |
  -- comisiones_internas_hc.sql:47
  if(date_trunc(fecha_desembolso, month) = mes_comision_input, 1.0, null) as desembolsos,
grain: "mes_comision × beneficiado"
filters_exclusions: "'desembolsos' = analista de legalización; 'cantidad_desembolsos' = supervisor y gerente"
source_tables:
  - papyrus-delivery-data.habicredit.main_board
  - papyrus-delivery-data.habicredit.wbr_liquidez
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
known_caveats: "Unidad: operaciones. p_ejecucion = promedio de p(cantidad) y p(monto) (RN-CO-004)."
```

## Uso en el WBR de Liquidez CO
- **Qué muestra el WBR.** El indicador "Desembolsos HC Bancario" usa la serie `desembolsos` como barras y `monto_desembolsos` como línea.
- **Tipo y agregación.** Es un flujo (suma diaria) con MTD recortado, WoW, MoM, meta del mes corrido y cumplimiento (RN-CO-023 a RN-CO-026).
- **Meta truncada.** La meta del mes corrido de este indicador se trunca a entero y la de Radicaciones no. Eso cambia el cumplimiento: 58/89 = 65,17%, no 64,85%.
- **La fuente se reexpresa.** La semana del 3 de agosto 2026 cerró en 58 en el tablero y en 64 en la tabla tres días después. Al comparar cifras hay que usar la misma foto (RN-CO-027).
- **Universo sin confirmar.** "HC Bancario" sugiere un universo acotado (crédito bancario de HabiCredit). No hay evidencia de que coincida con el conteo de desembolsos de comisiones (`main_board.fecha_desembolso`).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
- 2026-09-30: enriquecida con el WBR de Liquidez CO (docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)).
