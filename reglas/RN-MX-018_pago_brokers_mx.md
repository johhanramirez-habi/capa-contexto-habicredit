# RN-MX-018 — Pago a brokers (MX)

```yaml
rule_id: "RN-MX-018"
name: "Condiciones de pago a brokers"
domain: "Comisiones"
market: ["MX"]
description: >
  La comisión de un broker solo se paga si el crédito se desembolsó y hay una factura
  aprobada. Si falta la factura, el monto se calcula igual y queda BLOQUEADO; no se
  omite.
applies_to: ["Comisión broker MX", "Broker MX"]
logic_summary: "requiere desembolso + factura aprobada; sin factura → calcular y marcar BLOQUEADO; % según fecha y tipo de inmueble (ver comision_broker_mx)"
sql_reference: |
  # config/reglas.yaml:230-235
  requiere_desembolso: true
  requiere_factura_aprobada: true
  aprobadores_factura: [facturasmx@tuhabi.mx]
  aprobadores_pago: [auditoria@habi.co, juanjo@tuhabi.mx]
exceptions: "sin esquema documentado entre 2023-12-12 y 2024-03-31"
owner: "sin evidencia en el material fuente (aprobación de factura y pago por los buzones listados)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/reglas.md:493-510
```

## Notas
- No está implementado en código. Según docs/reglas.md:495, el proceso de correo a brokers pasa por el Manager, el VP de HabiCredit MX y el analista de BI.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
