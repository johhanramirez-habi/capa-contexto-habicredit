# Posición comisionable (cargo) — HabiCredit CO

```yaml
entity: "Posición comisionable CO"
aliases: ["posicion", "role", "cargo", "Esquema (nómina)", "equipo"]
domain: "Comisiones"
market: ["CO"]
description: >
  Cargo del beneficiado dentro del esquema de comisiones de Colombia. Define qué
  indicadores mide y qué bandas de pago se le aplican (techo, piso, tramos fijos).
grain: "una fila por posición"
source_tables:
  - papyrus-delivery-data.habicredit.comisiones_internas_hc_fn_table
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
key_attributes:
  - name: "posicion (motor)"
    description: "Gerente Comercial; Director non ibuyer; Director non ibuyer Graduaciones; KAM; Ejecutivo Comercial Habicredit (Comercial Convenios inmobiliarios Ciudades); Analista Devoluciones; Director ibuyer; Ejecutivo ibuyer; Ejecutivo COLEX; Ejecutivo Cero Goles; Gerente Ops Liquidez; Supervisor Radicación; Analista Radicación; Analista de filtros (Estados); Supervisor Legalización; Analista Legalización; Supervisor Pre Legalización; Analista Pre Legalización; Analista de Legalización (Recaudo); Supervisor/Analista Legalización no Habicredit; Analista Legalización Operaciones iBuyer (Abogada)"
  - name: "role (metas)"
    description: "nombres largos del Sheet de metas, p. ej. 'K.A.M. - General', 'Gerente de Ops Liquidez', 'Ejecutivo Comercial Colombianos en el exterior'"
relationships:
  - related_entity: "Comisión interna CO"
    relationship: "cada fila de comisión se calcula con las bandas de su posición"
  - related_entity: "Esquema de comisiones CO"
    relationship: "cada posición tiene una sección en el PDF mensual"
business_rules_ref: ["RN-CO-007", "RN-CO-008", "RN-CO-009", "RN-CO-010", "RN-CO-011", "RN-CO-012", "RN-CO-013"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: sql/comisiones_co/comisiones_internas_hc.sql:1684-2609; comisiones_internas_hc_final.sql:315-617; data/Metas (columna role)
```

## Notas
- **Nombres inconsistentes entre fuentes.** El motor (`posicion`), las metas (`role`) y el PDF usan nombres distintos para el mismo cargo; por ejemplo 'KAM', 'K.A.M. - General' y 'K.A.M. (Key Account Manager) - General'. El único mapeo explícito está en una CTE comentada (`validacion_base_nomina`, final.sql:234-242).
- **El cruce con metas no usa la posición**, solo `email + metric_category + effective_date`.
- **Cambio de 2026.** Las posiciones "no-Habicredit" y "Abogada" están comentadas en el UNPIVOT desde 2026 ("A partir de 2026 el equipo deja de ser parte de Habicredit", comisiones_internas_hc.sql:2755).
- Hay un typo original en el nombre de posición 'Operacaciones'.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
