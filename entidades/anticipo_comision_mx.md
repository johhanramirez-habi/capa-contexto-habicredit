# Anticipo de comisión — HabiCredit MX

```yaml
entity: "Anticipo de comisión MX"
aliases: ["anticipo", "base de anticipos", "consolidado de anticipos", "anticipos.csv", "Comision experto", "Comisión manager"]
domain: "Comisiones"
market: ["MX"]
description: >
  Pago adelantado del 30% de la comisión que se hace en el mes de aceptación al EF y al
  Manager. Queda registrado y se resta de la liquidación al escriturar. El registro es
  estado: si se pierde, se paga dos veces.
grain: "card_id × colaborador × rol"
source_tables:
  - "sin tabla BigQuery: data/clean/anticipos.csv"
  - "histórico: data/raw/consolidado_anticipos_comisiones_mx.csv"
  - "Google Sheet 'Base de anticipos' (id 1HoJq8Prey-M48BNdSWZ-lQExq8j4q7R8GMVqAuRHJN8)"
key_attributes:
  - name: "mes"
    description: "mes de aceptación en que se pagó el anticipo"
  - name: "pct / base / monto"
    description: "% del tramo, base (monto del banco seleccionado) y monto anticipado (MXN)"
  - name: "banco"
    description: "banco seleccionado"
  - name: "origen"
    description: "consolidado_historico (inmutable) o motor (recalculable por mes)"
  - name: "fecha_registro"
    description: "fecha en que se registró el anticipo"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un negocio tiene 0..n anticipos"
  - related_entity: "Colaborador comisionable MX"
    relationship: "cada anticipo es de un colaborador y un rol (EF o MGR)"
business_rules_ref: ["RN-MX-003", "RN-MX-004", "RN-MX-010", "RN-MX-011", "RN-MX-019"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: src/comisiones/registro.py:12,23-24,60-94; README.md:54; docs/reglas.md:14; src/comisiones/normalizar.py:60-111
```

## Notas
- En `anticipos.csv` aparece `banco = "Yave"` en 2 filas (2024-08) y el banco vacío en 19. docs/fuentes.md:134 dice que solo hay seis valores posibles.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
