# RN-MX-005 — Resolución del mes de aceptación (MX)

```yaml
rule_id: "RN-MX-005"
name: "Resolución del mes de aceptación"
domain: "Comisiones"
market: ["MX"]
description: >
  Define a qué mes (cohorte) pertenece la aceptación de un negocio. De ese mes dependen el
  conteo de la meta, el esquema y el % de comisión.
applies_to: ["Aceptación MX", "Conteo individual de aceptaciones con inmueble MX", "Conteo de equipo de aceptaciones con inmueble MX"]
logic_summary: "mes = mes de Fecha_de_aceptacion; si es nula, Fecha_de_aceptacion_Forma_Anterior. En escrituraciones, el mes viene de la base de aceptaciones y, si falta, del propio extracto"
sql_reference: |
  # src/comisiones/normalizar.py:171
  d["fecha_aceptacion"] = fa.fillna(fa_anterior)
  -- sql/anticipos_mes.plain.sql:8-13: desde 2024-07-01 Fecha_de_aceptacion = DATE(c.fecha_salida_eleccion_propiedad)
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: docs/reglas.md:118-132,632,640; config/reglas.yaml:33-46; normalizar.py:290-293
```

## Notas
- **Contradicción interna del proyecto.** CLAUDE.md:32-37, reglas.yaml:33-38 y docs/reglas.md §2.1 dicen que manda el mes pagado en anticipos.csv y que una discrepancia sin anticipo es una excepción bloqueante. docs/reglas.md:632 y 640 lo resuelven después como "Fecha_de_aceptacion; si es nula, Forma_Anterior" y dicen que `corte_aceptacion` es irrelevante. El código implementa esta segunda versión, y reglas.yaml:42 conserva `default_mes_en_curso: null` como TODO.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
