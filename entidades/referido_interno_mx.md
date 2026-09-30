# Referido interno — HabiCredit MX

```yaml
entity: "Referido interno MX"
aliases: ["REF", "referido", "referidor"]
domain: "Comisiones"
market: ["MX"]
description: >
  Negocio que un empleado de Habi, TuHabi, Merbos o HabiCredit refirió. En vez del tramo
  normal, el referidor cobra un 1% del crédito. El referido se declara a mano; no se
  deriva de otros campos.
grain: "negocio (card_id)"
source_tables:
  - "sin tabla BigQuery: data/clean/referidos.csv"
key_attributes:
  - name: "card_id"
    description: "negocio referido"
  - name: "colaborador_referidor"
    description: "colaborador que refirió (en docs/reglas.md:286 aparece como colaborador_id_referidor)"
  - name: "rol_referidor"
    description: "rol del referidor en el negocio (observado: EF, AO, MGR)"
  - name: "aprobado_por / fecha_aprobacion"
    description: "aprobación requerida del head de HabiCredit o del director; vacía en todas las filas observadas"
  - name: "fuente"
    description: "valores observados: declarado, backfill_observaciones, backfill_pct_1pct"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un negocio tiene 0..1 referido"
  - related_entity: "Colaborador comisionable MX"
    relationship: "el referidor es un colaborador implicado en el negocio"
business_rules_ref: ["RN-MX-012"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: config/reglas.yaml:123-146; docs/reglas.md:264-286; data/clean/referidos.csv (encabezado)
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
