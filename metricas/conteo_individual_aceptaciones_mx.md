# Conteo individual de aceptaciones con inmueble — MX

```yaml
metric: "Conteo individual de aceptaciones con inmueble MX"
aliases: ["conteo_individual", "meta de aprobación con inmueble", "Cumplimiento EF", "Cumplimiento AO"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Número de negocios aceptados con inmueble definido en el mes en los que participó cada
  colaborador (por rol). Junto con el conteo de equipo, define el tramo de % que cobra
  el EF o el AO.
formula_business: "negocios aceptados en el mes, con NID asignado y no excluidos, en los que el colaborador es EF (o AO)"
formula_sql: |
  # python (src/comisiones/motor.py:65-69; normalizar.py:216)
  cuenta_para_meta = nid.notna() & mes_aceptacion.notna() & (excluido == False)
  contables = aceptaciones[aceptaciones["cuenta_para_meta"]]
  "EF": contables.dropna(subset=["ef"]).groupby(["mes_aceptacion","ef"]).size()
grain: "mes de aceptación × rol × colaborador"
filters_exclusions: "excluye negocios sin NID, sin mes de aceptación o excluidos por override; solo cuenta el mes calendario; NO excluye colaboradores que salieron"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
known_caveats: >
  Unidad: negocios (no monto). Cada rol usa su propio conteo individual (lectura B,
  confirmada en 7 de 8 negocios discriminantes may-jul 2026). La regla de "inmueble
  definido" (NID no nulo) sigue marcada como hipótesis sin confirmar (pregunta #5). El
  conteo cambia según qué fuente de EF/AO se use: en jul-2026, BBDD daba 7 y 4, y el
  bloque manual 9 y 11 (docs/fuentes.md:200-202). La deduplicación por card_id da
  prioridad al consolidado histórico.
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
