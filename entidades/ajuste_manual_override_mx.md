# Ajuste manual (override) — HabiCredit MX

```yaml
entity: "Override de comisiones MX"
aliases: ["override", "overrides.csv", "ajuste manual"]
domain: "Comisiones"
market: ["MX"]
description: >
  Corrección manual de un dato de un negocio (EF, AO, base del anticipo, monto final,
  exclusión). Se aplica encima del cálculo base, queda registrada con motivo y autor, y
  tiene la máxima autoridad sobre cualquier otra fuente.
grain: "mes × negocio × campo"
source_tables:
  - "sin tabla BigQuery: data/clean/overrides.csv"
key_attributes:
  - name: "mes / negocio_id / colaborador_id"
    description: "a qué mes, negocio y colaborador aplica"
  - name: "campo"
    description: "valores observados: ao, excluido, ef, base_anticipo, monto_final"
  - name: "valor_nuevo / motivo / autor / fecha"
    description: "valor corregido y trazabilidad del cambio"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un negocio puede tener 0..n overrides"
business_rules_ref: ["RN-MX-014"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: CLAUDE.md:87-93; src/comisiones/normalizar.py:314-341; data/clean/overrides.csv (encabezado)
```

## Notas
- La llave está documentada distinto en cada sitio. docs/fuentes.md:287 dice `card_id + campo`. El CSV real usa `negocio_id + mes + campo`. `__main__.py:73` declara columnas vacías con `card_id`.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
