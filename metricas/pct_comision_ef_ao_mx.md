# % de comisión EF / AO — MX

```yaml
metric: "% de comisión EF/AO MX"
aliases: ["pct", "tramo", "% Comisión EF", "% Comisión AO"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Porcentaje sobre el crédito que cobra el Experto Financiero o el Analista de Operaciones
  por cada negocio, según su conteo individual y el conteo del equipo en el mes de
  aceptación (esquema 2024-2026).
formula_business: "0% si el equipo tiene 8 aceptaciones o menos, o si el individuo tiene 3 o menos; 0,100% si el individuo tiene 4-7; 0,125% si tiene 8 o más"
formula_sql: |
  # python (src/comisiones/motor.py:31-36); parámetros en config/reglas.yaml:212-216
  if n_equipo <= esquema["equipo_min"] - 1 or n_individual <= esquema["individual_cero"]: return CERO
  # tramos: {individual_max: 7, valor: 0.00100}, {individual_max: null, valor: 0.00125}
grain: "colaborador × negocio (resuelto con el mes de aceptación)"
filters_exclusions: "si el colaborador es el referidor del negocio se reemplaza por el 1% de referido (RN-MX-012)"
source_tables:
  - "derivada de conteo_individual_aceptaciones_mx y conteo_equipo_aceptaciones_mx"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  El documento de julio 2026 publica 0,2% / 0,25% "pagaderas 50% al EF y 50% al AO".
  Eso equivale a 0,1% / 0,125% por rol: el cambio es de redacción, no de dinero
  (reglas.yaml:196-199). Hay una contradicción documental: docs/reglas.md:219 y los pasos
  5 y 11 del proceso mencionan un "reparto 50/50", mientras que el yaml y el código usan
  el % completo por rol. El % queda congelado al valor del mes de aceptación. Aplica
  sobre montos en MXN.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
