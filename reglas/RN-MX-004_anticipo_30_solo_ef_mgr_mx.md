# RN-MX-004 — Anticipo del 30% solo para EF y Manager (MX)

```yaml
rule_id: "RN-MX-004"
name: "Anticipo del 30% solo EF y Manager"
domain: "Comisiones"
market: ["MX"]
description: >
  En la aceptación se anticipa el 30% de la comisión al Experto Financiero y al Manager.
  El Analista de Operaciones no recibe anticipo: cobra el 100% al escriturar.
applies_to: ["Anticipo EF MX", "Anticipo Manager MX", "Colaborador comisionable MX"]
logic_summary: "anticipo = 30%; aplica_a = [EF, MGR]"
sql_reference: |
  # config/reglas.yaml:73-81
  porcentaje: 0.30
  base: monto_del_banco_seleccionado
  aplica_a: [EF, MGR]
exceptions: "AO excluido"
owner: "sin evidencia en el material fuente (lo ratificó el 'responsable del cálculo', docs/reglas.md:334)"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/reglas.md:330-335; src/comisiones/motor.py:133
```

## Notas
- El documento de esquema de julio 2026 incluye al AO en los anticipos. El proyecto verificó que en la práctica no es así (43 de 45 negocios) y concluye que "el documento está mal en este punto" (docs/reglas.md:335).

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
