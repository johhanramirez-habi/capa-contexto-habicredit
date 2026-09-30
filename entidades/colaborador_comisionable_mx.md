# Colaborador comisionable — HabiCredit MX

```yaml
entity: "Colaborador comisionable MX"
aliases: ["colaborador", "colaborador_id", "persona", "implicado", "EF", "AO", "MGR", "MO", "Experto financiero", "Analista de operaciones", "Manager operativo"]
domain: "Comisiones"
market: ["MX"]
description: >
  Empleado interno de HabiCredit MX que cobra comisión por los negocios en los que
  participa. Cobra según el rol que tuvo en el negocio: Experto Financiero (EF, % sobre
  el crédito), Analista de Operaciones (AO, % sobre el crédito, sin anticipo) o Manager
  (MGR, monto fijo por aprobación según el tamaño del equipo).
grain: "colaborador_id (ej. COL-001)"
source_tables:
  - "sin tabla BigQuery: archivos locales data/private/colaboradores.csv y data/private/equipo.yaml"
key_attributes:
  - name: "colaborador_id"
    description: "id interno estable; la fuente identifica al colaborador por texto libre con alias"
  - name: "rol"
    description: "EF, AO, MGR (también BRK y REF como roles de otros procesos)"
  - name: "fecha_salida"
    description: "si existe, el pago se fuerza a cero desde ese mes (sus negocios siguen contando para el equipo)"
  - name: "alias / nombre_correo / email"
    description: "mapeo de los nombres de la fuente al id y datos de contacto"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un colaborador participa en muchos negocios; cada negocio tiene 1 EF, 1 AO y 1 Manager"
  - related_entity: "Referido interno MX"
    relationship: "un colaborador puede ser referidor de un negocio"
business_rules_ref: ["RN-MX-007", "RN-MX-008", "RN-MX-009", "RN-MX-012", "RN-MX-013"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/reglas.md:37-45; docs/fuentes.md:183-205; src/comisiones/normalizar.py:36-49,184,274,287-288; src/comisiones/__main__.py:57-77
```

## Notas
- El EF viene de `Experto_financiero`. El SQL de aceptaciones aplica `coalesce(c.Experto_financiero, <nombre por defecto>)`, así que en aceptaciones el EF nunca llega nulo. Esto choca con la regla que manda un negocio sin EF a excepción (ver RN-MX-013).
- El AO llega de la fuente solo con el nombre de pila y viene vacío en 21 de 373 filas (docs/fuentes.md:183).
- El Manager no está en la fuente: hay uno solo y se inyecta desde `data/private/equipo.yaml`. docs/fuentes.md:184 dice que viene de `config/reglas.yaml`; el código lo contradice.
- ¿Se soportan varios Managers? Sin evidencia en el material fuente.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
