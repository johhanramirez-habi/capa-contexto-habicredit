# Esquema de comisiones — HabiCredit MX

```yaml
entity: "Esquema de comisiones MX"
aliases: ["esquema", "Esquema 2023", "Esquema 2024", "Esquema 2024-2026", "Esquema de Comisiones Liquidez MX — Julio 2026"]
domain: "Comisiones"
market: ["MX"]
description: >
  Conjunto de tablas de % y montos que define cuánto cobra cada rol. Cada esquema tiene
  un rango de vigencia, y a cada negocio se le aplica el esquema vigente en su fecha de
  aceptación. Finanzas aprueba los esquemas.
grain: "un esquema por rango de fechas de aceptación"
source_tables:
  - "sin tabla BigQuery: config/reglas.yaml (esquemas) y documentos de esquema aprobados por finanzas"
key_attributes:
  - name: "id"
    description: "'2023' (2023-01-01 a 2023-12-31) y '2024-2026' (desde 2024-01-01, sin fecha de fin)"
  - name: "vigente_desde / vigente_hasta"
    description: "rango de fechas de aceptación a las que aplica"
  - name: "equipo_min / individual_cero / tramos"
    description: "doble condición y tramos de % para EF/AO (esquema 2024-2026)"
  - name: "mgr_tramos / mgr_tope_periodo"
    description: "monto por aprobación del Manager y tope del periodo (MXN)"
  - name: "etiqueta_correo"
    description: "nombre del esquema en los correos ('Esquema 2024')"
relationships:
  - related_entity: "Aceptación MX"
    relationship: "la fecha de aceptación de cada negocio determina su esquema"
business_rules_ref: ["RN-MX-002", "RN-MX-007", "RN-MX-008", "RN-MX-020"]
owner: "sin evidencia en el material fuente (docs/reglas.md:12: 'esquemas aprobados por finanzas')"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: config/reglas.yaml:149-226; docs/reglas.md:10-27,405-482
```

## Notas
- Contradicción sobre la vigencia. docs/reglas.md:23-27 separa "2024 hasta 2026-06-30" y "2026 desde 2026-07-01". El yaml tiene un solo esquema, "2024-2026", y docs/reglas.md:634 lo cierra con "no hay corte de dinero": el documento de julio 2026 cambió la redacción, no los montos.
- La tabla del Manager del PDF de julio 2026 "está mal formada" (docs/reglas.md:256).
- Ver también la variante de Colombia: [esquema_comisiones_co.md](esquema_comisiones_co.md). Es otro concepto: un PDF mensual por cargo.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
