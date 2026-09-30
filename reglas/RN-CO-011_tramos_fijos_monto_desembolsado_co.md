# RN-CO-011 — Tramos fijos por monto desembolsado (CO)

```yaml
rule_id: "RN-CO-011"
name: "Tramos fijos por monto desembolsado"
domain: "Comisiones"
market: ["CO"]
description: >
  En gerencia comercial y direcciones, el indicador de monto desembolsado no paga por
  banda de cumplimiento sino con montos fijos (COP) al superar umbrales de desembolso
  del mes.
applies_to: ["Monto desembolsado CO", "Pago de comisión CO"]
logic_summary: >
  Desde 2026-08-01:
  Gerente Comercial <134.000MM → 0, <156.000MM → 3.000.000, resto → 5.000.000.
  Director non ibuyer, por grupo de directores (lista de correos en el SQL):
  3.000MM/4.000MM → 500.000/1.000.000; 10.000MM/12.000MM → 1.500.000/2.500.000;
  18.000MM/20.000MM → 3.000.000/5.000.000; 21.000MM/24.000MM → 3.000.000/5.000.000.
  Director ibuyer (sin fecha de corte): <5.400MM → 0; 5.400-8.000MM → 600.000;
  >8.000-9.600MM → 1.000.000; >=9.600MM → 0 (base por definir).
  Ejecutivo ibuyer: <1.400MM → 0; 1.400-2.500MM → 300.000; >2.500-3.000MM → 500.000;
  >3.000-<3.333MM → 800.000; >=3.333MM → 900.000
sql_reference: |
  -- comisiones_internas_hc_final.sql:336-344 (Gerente Comercial)
  WHEN indicador = 'monto_desembolso' AND mes_comision >= DATE('2026-08-01') THEN
    CASE WHEN posicion = 'Gerente Comercial' THEN
      CASE WHEN ejecucion < 134000000000 THEN 0
           WHEN ejecucion < 156000000000 THEN 3000000
           ELSE 5000000 END
  -- Director ibuyer (final.sql:425): WHEN ejecucion >= 9600000000 THEN ejecucion * 0 --Se debe definir cuál es la base
exceptions: "antes de 2026-08-01, Gerente Comercial y Director non ibuyer caen a la banda genérica; un director non ibuyer que no esté en ninguna lista recibe NULL (el CASE no tiene ELSE)"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: comisiones_internas_hc_final.sql:336-369,419-445; Esquemas/202608
```

## Notas
- **Director iBuyer: el SQL no coincide con las convenciones de metas.** convenciones.md:109-112 y SKILL.md:125-129 describen una tarifa por millón: $600/millón y $1.000/millón, y % directo por encima de 9.600MM. El SQL paga montos fijos y, en el tramo superior, 0.
- Las listas de directores por tramo se identifican por correo en el SQL. Aquí no se copian los correos personales; ver la fuente.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
