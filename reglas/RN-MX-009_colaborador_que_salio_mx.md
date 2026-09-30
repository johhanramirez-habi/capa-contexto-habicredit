# RN-MX-009 — Colaborador que salió: se filtra en el pago, no en el conteo (MX)

```yaml
rule_id: "RN-MX-009"
name: "Colaborador con fecha de salida"
domain: "Comisiones"
market: ["MX"]
description: >
  Un colaborador que dejó la empresa no cobra desde su mes de salida: su pago se fuerza a
  cero y se reporta. Sus negocios siguen contando para el total del equipo, y el anticipo
  que ya recibió no se le recupera.
applies_to: ["Liquidación neta EF/AO MX", "Conteo de equipo de aceptaciones con inmueble MX", "Colaborador comisionable MX"]
logic_summary: "si mes de pago >= mes de salida → neto = 0 + excepción pago_en_cero; el conteo de equipo no filtra; saldo de anticipos pendiente = no se recupera"
sql_reference: |
  # src/comisiones/motor.py:179-180
  if quien in salidas and mes >= salidas[quien]:
      neto, motivo_cero = CERO, f"{rol} con fecha_salida ..."
exceptions: "no se aplica a los anticipos ni al Manager en el código; ¿el Manager cobra sobre negocios de quien salió? = sin definir (reglas.yaml:112)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: config/reglas.yaml:99-116; docs/reglas.md:50-93; CLAUDE.md:75-80; tests/golden/test_meses_cerrados.py:146-156
```

## Notas
- En mayo 2026, el pago real hizo lo contrario en 3 negocios: clawbacks por 1.185,34 MXN a una EF que ya había salido. La fecha real de salida de esa colaboradora sigue en duda (docs/reglas.md:623-625).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
