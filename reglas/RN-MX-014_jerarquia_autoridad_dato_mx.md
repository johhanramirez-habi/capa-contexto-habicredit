# RN-MX-014 — Jerarquía de autoridad del dato y overrides (MX)

```yaml
rule_id: "RN-MX-014"
name: "Jerarquía de autoridad del dato"
domain: "Comisiones"
market: ["MX"]
description: >
  Cuando un dato del negocio (EF, AO, montos) viene distinto en varias fuentes, manda la
  de mayor autoridad. Los overrides manuales se aplican al final y quedan registrados.
applies_to: ["Negocio HabiCredit MX", "Override de comisiones MX", "Conteo individual de aceptaciones con inmueble MX"]
logic_summary: "overrides.csv > observaciones (backfill único) > bloque manual (Experto_financiero.1, Monto solicitado) > BBDD; un override con mes afecta solo esa fila; campo 'excluido' saca el negocio del cálculo"
sql_reference: |
  # src/comisiones/normalizar.py:7-8
  # autoridad: overrides.csv > bloque manual (.1) > BBDD
exceptions: "las observaciones no se procesan en cada cálculo; se migraron una sola vez a overrides/referidos (normalizar.py:344-359)"
owner: "sin evidencia en el material fuente (confirmada por el 'responsable del cálculo')"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/fuentes.md:196-202; CLAUDE.md:87-93; src/comisiones/normalizar.py:314-341
```

## Notas
- El impacto de elegir una fuente u otra es real: en julio 2026, contar por BBDD daba el tramo de 0,1% y contar por el bloque manual daba el de 0,125%.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
