# RN-MX-020 — Esquema 2023 por % de cumplimiento de meta (MX)

```yaml
rule_id: "RN-MX-020"
name: "Esquema 2023"
domain: "Comisiones"
market: ["MX"]
description: >
  Para aceptaciones de 2023, la comisión dependía del % de cumplimiento de una meta
  individual de aceptaciones: el EF cobraba un % del crédito, el AO un monto fijo y el
  Manager una parte de una bolsa según el cumplimiento del equipo.
applies_to: ["% cumplimiento de meta MX (esquema 2023)", "Esquema de comisiones MX"]
logic_summary: "EF: <70% → 0; 70-80% → 0,08%; 80-90% → 0,16%; 90-100% → 0,18%; =100% → 0,20%; 100-111% → 0,22%; >111% → 0,24%. AO: 0/100/200/400/600/800/1.000 MXN en los mismos rangos. MGR: bolsa de 10.000 MXN; <70% → 0, 70-80% → 40%, >80% → 100%; por negocio = bolsa × pct / negocios aceptados del mes. Sin reparto EF/AO"
sql_reference: |
  # config/reglas.yaml:152-193 (no ejecutable en código)
exceptions: "vigente solo para aceptaciones del 2023-01-01 al 2023-12-31"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:405-451
```

## Notas
- **Huecos en los bordes.** Los rangos no cubren exactamente el 80% ni el 111% (reglas.yaml:168, 189; pregunta #14).
- **Residuo sin definir.** No se sabe qué pasa con el residuo del reparto de la bolsa (pregunta #13).
- **No es ejecutable.** El código no puede correrlo (`resolver_esquema` exige `individual_cero`) y no existe `metas.csv`.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
