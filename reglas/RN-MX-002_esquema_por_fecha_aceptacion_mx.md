# RN-MX-002 — El esquema se resuelve por fecha de aceptación (MX)

```yaml
rule_id: "RN-MX-002"
name: "Esquema vigente según fecha de aceptación"
domain: "Comisiones"
market: ["MX"]
description: >
  A cada negocio se le aplica el esquema de comisiones vigente en su fecha de aceptación,
  nunca el del mes en que se liquida. Si la fecha no cae en ningún esquema, el negocio va
  a excepción; no se toma el esquema "más cercano".
applies_to: ["Esquema de comisiones MX", "% de comisión EF/AO MX", "Liquidación Manager MX"]
logic_summary: "fecha_aceptacion → esquema cuyo rango la contiene; si no hay → excepción EsquemaNoVigente"
sql_reference: |
  # src/comisiones/parametros.py:33-47 (resolución por el primer día del mes que se corre)
exceptions: "esquema 2023 definido pero no ejecutable en código (ver RN-MX-020)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: config/reglas.yaml:5-7; CLAUDE.md:16-22
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
