# RN-CO-008 — Indicadores sin techo (CO)

```yaml
rule_id: "RN-CO-008"
name: "Sin techo desde 80%"
domain: "Comisiones"
market: ["CO"]
description: >
  En radicación, aprobado de reprocesos, desembolsos y salvamento no hay techo: desde el
  80% de cumplimiento se paga el % logrado sin límite.
applies_to: ["Radicaciones CO", "Monto radicado CO", "Reprocesos KAM CO", "Salvamentos CO", "Monto desembolsado CO"]
logic_summary: "p <= 69,99% → 0; p <= 79,99% → base × 0,3; p > 79,99% → base × p"
sql_reference: |
  -- comisiones_internas_hc_final.sql:324-335 (y equivalentes)
  WHEN indicador IN ('radicacion_monto','radicacion', 'reprocesos_monto', 'reprocesos_kam', 'aprobaciones_kam') THEN
    CASE WHEN p_ejecucion <= .6999 THEN 0
         WHEN p_ejecucion <= .7999 THEN base_commission *.3
         WHEN p_ejecucion > .7999 THEN base_commission * p_ejecucion END
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app)"
# evidencia: PDF 202608: "NO SE TENDRÁ TECHO EN RADICACIÓN / APROBADO DE REPROCESOS / DESEMBOLSOS / PARA EL INDICADOR DE SALVAMENTO"
```

## Notas
- Aplica a:
  - radicacion, radicacion_monto, reprocesos_monto, reprocesos_kam y aprobaciones_kam en Gerente, Director y KAM;
  - radicaciones_inmo;
  - monto_desembolso de COLEX;
  - todo el Ejecutivo Cero Goles;
  - reproceso_creditos(_monto) en Gerente Ops, Supervisor Radicación y Analista Radicación/filtros;
  - todo el Analista Legalización.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
