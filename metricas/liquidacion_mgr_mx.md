# Liquidación del Manager — MX

```yaml
metric: "Liquidación Manager MX"
aliases: ["Comision MO", "liquidación MGR"]
domain: "Comisiones"
market: ["MX"]
regional_variant_of: ""
description: >
  Pago al Manager al escriturar cada negocio: el monto total por aprobación (reconstruido
  desde su anticipo) menos el anticipo ya pagado.
formula_business: "total = anticipo registrado / 30%; neto = total − anticipo. Si no hay anticipo registrado, total = tramo del mes de aceptación y se asume que el anticipo del 30% ya se pagó"
formula_sql: |
  # python (src/comisiones/motor.py:199-215)
  if anticipo_mgr is not None:
      total_mgr = anticipo_mgr / Decimal(str(params["anticipos"]["porcentaje"]))
  else:
      total_mgr = monto_por_aprobacion_mgr(n_equipo, esquema)
      anticipo_mgr = total_mgr - resto * total_mgr
grain: "negocio × Manager, en el mes de escrituración"
filters_exclusions: "sujeto al tope de 25.000 MXN por periodo (RN-MX-008)"
source_tables:
  - "derivada del registro de anticipos (data/clean/anticipos.csv) y conteo_equipo_aceptaciones_mx"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
known_caveats: >
  Moneda MXN. El tramo no se recalcula al escriturar (evita pagar de más a un negocio
  anticipado con un tramo menor). Valores observados (bruto / anticipo / neto):
  1000/300/700 y 500/150/350. Sin registro de anticipo, el código liquida solo el 70%;
  la doc solo dice "cae al tramo del mes de aceptación y lo reporta"
  (docs/reglas.md:488-489), sin aclarar si se paga el 70% o el 100%. ¿El Manager cobra
  sobre negocios de colaboradores que salieron? Sin definir (reglas.yaml:112).
```

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
