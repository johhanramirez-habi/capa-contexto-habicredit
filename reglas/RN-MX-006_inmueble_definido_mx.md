# RN-MX-006 — Solo cuentan aceptaciones con inmueble definido (MX)

```yaml
rule_id: "RN-MX-006"
name: "Inmueble definido para contar en la meta"
domain: "Comisiones"
market: ["MX"]
description: >
  Para la meta solo cuentan los negocios aceptados que ya tienen un inmueble asignado (NID
  no nulo), y solo en el mes calendario de la aceptación. Una aprobación sin inmueble no
  cuenta hasta el mes en que se firme.
applies_to: ["Conteo individual de aceptaciones con inmueble MX", "Conteo de equipo de aceptaciones con inmueble MX"]
logic_summary: "cuenta_para_meta = NID no nulo AND mes de aceptación resuelto AND no excluido"
sql_reference: |
  # src/comisiones/normalizar.py:216
  cuenta_para_meta = nid.notna() & mes_aceptacion.notna() & (excluido == False)
exceptions: "negocios excluidos por override"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX)"
# evidencia: config/reglas.yaml:50,207; docs/reglas.md:157-158
```

## Notas
- Sigue marcada como hipótesis sin confirmar (pregunta #5: ¿el NID se asigna al firmar?).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
