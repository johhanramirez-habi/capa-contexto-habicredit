# Base de Finanzas (comisiones auditadas) — HabiCredit CO

```yaml
entity: "Base de Finanzas de comisiones CO"
aliases: ["comisiones_internas_hc_finanzas", "congelado", "base auditada"]
domain: "Comisiones"
market: ["CO"]
description: >
  Registro de lo que auditoría aprobó y efectivamente se pagó cada mes, incluidos los
  retroactivos y los bonos. Es la versión "congelada" de las comisiones y prevalece sobre
  el cálculo del motor para los meses ya pagados.
grain: "mes_comision × beneficiado × indicador (× tipo)"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_finanzas
key_attributes:
  - name: "tipo"
    description: "Indicador / Retroactivo / Bonos (en el visor se renombra a 'concepto')"
  - name: "pago"
    description: "monto aprobado y pagado (COP)"
relationships:
  - related_entity: "Comisión interna CO"
    relationship: "cada mes auditado reemplaza el cálculo del motor para ese mes"
business_rules_ref: ["RN-CO-021"]
owner: "sin evidencia en el material fuente (visor_vista.sql:6 la atribuye a auditoría/Finanzas)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: sql/comisiones_co/visor_vista.sql:6-7,28-32; sql/validaciones/conciliacion.sql:4-5,24; apps_script/README.md:29; agent.md:7
```

## Notas
- Cobertura según apps_script/README.md:29: 18 meses, de 2025-02 a 2026-07.
- La base se llena con un traslado manual.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
