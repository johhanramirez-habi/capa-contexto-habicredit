# Excepción de comisiones — HabiCredit MX

```yaml
entity: "Excepción de comisiones MX"
aliases: ["excepción", "excepciones_YYYY-MM.csv"]
domain: "Comisiones"
market: ["MX"]
description: >
  Caso que el motor no puede pagar o que paga con una advertencia. Se reporta por mes para
  revisión humana, para que ningún cero o ajuste pase en silencio.
grain: "mes × card_id × tipo (× rol × colaborador)"
source_tables:
  - "sin tabla BigQuery: outputs/excepciones_YYYY-MM.csv"
key_attributes:
  - name: "tipo"
    description: "implementados: negocio_excluido, base_anticipo_sin_monto, base_anticipo_a_revisar, monto_final_invalido, mes_aceptacion_sin_resolver, negocio_sin_ef, negocio_sin_ao, pago_en_cero, liquidacion_negativa, anticipo_mgr_sin_registro, tope_manager_alcanzado"
  - name: "detalle / monto"
    description: "explicación y monto afectado"
relationships:
  - related_entity: "Negocio HabiCredit MX"
    relationship: "un negocio puede tener 0..n excepciones por mes"
business_rules_ref: ["RN-MX-008", "RN-MX-009", "RN-MX-010", "RN-MX-013"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: src/comisiones/motor.py; outputs/excepciones_*.csv (encabezado); docs/reglas.md §11
```

## Notas
- La lista de excepciones documentada en docs/reglas.md §11 es bastante más amplia que la que está implementada.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
