# Comisión "Directa y buyers" — MX

```yaml
metric: "Comisión Directa y buyers MX"
aliases: ["Directa y buyers", "comisión buyer"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Cálculo informativo de la comisión asociada al buyer o asesor comercial de negocios no
  externos. Aparece en el reporte de auditoría y no genera pago en el motor.
formula_business: "Monto_final_credito × 0,3% si tipo_de_negocio ≠ 'externo'; 0 si es externo"
formula_sql: |
  # python (src/comisiones/reporte.py:122,197-203)
  PCT_DIRECTA = Decimal("0.003")
  # fórmula del sheet original: =Q8*SI(N8<>"externo";0,3%;0)*SI(CONTARA(V8)>0;0,5;1)
grain: "negocio escriturado"
filters_exclusions: "negocios externos = 0"
source_tables:
  - papyrus-master.operations_habi_mx_buyers.funnel_buyers_mx
  - papyrus-master.dm_habi_mx_dwh_bi.operacion_general_buyers_mx
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Moneda MXN. El factor ×0,5 por "Perfilador" del sheet original no está implementado, y
  no hay evidencia de qué es el Perfilador (pregunta #19b).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
