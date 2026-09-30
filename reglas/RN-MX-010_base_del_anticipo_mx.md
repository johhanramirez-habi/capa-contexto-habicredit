# RN-MX-010 — Base del anticipo = monto del banco seleccionado (MX)

```yaml
rule_id: "RN-MX-010"
name: "Base del anticipo"
domain: "Comisiones"
market: ["MX"]
description: >
  El anticipo del EF se calcula sobre el monto aprobado por el banco que eligió el
  cliente, no sobre el monto solicitado. Si ese monto falta, no hay anticipo para el EF
  hasta que llegue el dato. Si el monto trae un error evidente de separador decimal (×100),
  se corrige y se reporta.
applies_to: ["Anticipo EF MX"]
logic_summary: "base = monto_<banco_seleccionado>; si es nulo → excepción base_anticipo_sin_monto y no se paga al EF (el MGR sí cobra); si monto_banco > 20 × monto_bbdd y |monto/100 − bbdd| <= bbdd/10 → dividir entre 100 y reportar base_anticipo_a_revisar; si los montos difieren, manda el del banco sin reportar"
sql_reference: |
  # config/reglas.yaml:64-66,78
  fuente_de_verdad_si_difieren: monto_del_banco_seleccionado
  base: monto_del_banco_seleccionado
  # src/comisiones/normalizar.py:224-255 (corrección ×100)
exceptions: "no se sustituye por otro monto cuando falta el del banco"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:337-349; docs/fuentes.md:139-149; src/comisiones/motor.py:116-127
```

## Notas
- **Contradicción documental.** CLAUDE.md:26, docs/reglas.md:103, 183, 377 y 543 y docs/fuentes.md:113 y 163-165 dicen que la base es `monto_solicitado_de_cr_dito`. reglas.yaml (marcado CONFIRMADO), docs/reglas.md:322 y el código usan el monto del banco. Los dos montos difieren en ~52% de las filas.
- **Mapa de bancos.** El mapa banco → columna está escrito en el código (normalizar.py:20-27), no se lee del yaml. El yaml aún marca "yave = BBVA" como TODO por confirmar; docs/reglas.md:638 lo da por confirmado.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
