# RN-MX-013 — Requisitos para liquidar un negocio (MX)

```yaml
rule_id: "RN-MX-013"
name: "Requisitos para liquidar"
domain: "Comisiones"
market: ["MX"]
description: >
  Un negocio solo se liquida si escrituró con un monto final válido, si aparece en la base
  de aceptaciones (para conocer su cohorte) y si tiene EF y AO asignados. En otro caso se
  reporta como excepción y no se paga.
applies_to: ["Comisión bruta EF/AO MX", "Liquidación neta EF/AO MX"]
logic_summary: "Fecha_de_escrituracion nula → solo anticipo; Monto_final_credito nulo o <= 0 → monto_final_invalido; sin mes de aceptación → mes_aceptacion_sin_resolver; sin EF/AO → negocio_sin_ef / negocio_sin_ao (avisar a TechOps producto)"
sql_reference: |
  # src/comisiones/motor.py:153-167
  if monto is None or pd.isna(monto) or monto <= 0: excepción "monto_final_invalido"
  if not mes_ace or mes_ace not in conteos["equipo"]: excepción "mes_aceptacion_sin_resolver"
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/reglas.md:116,572; docs/proceso_mensual.md:88
```

## Notas
- El SQL de aceptaciones rellena el EF faltante con un nombre por defecto (`coalesce(c.Experto_financiero, ...)`, anticipos_mes.plain.sql:15). Por eso, en aceptaciones, la excepción "negocio sin EF" nunca se dispara.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
