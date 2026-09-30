# Meta de comisiones — HabiCredit CO

```yaml
entity: "Meta de comisiones CO"
aliases: ["meta", "meta_value", "rule_id", "base comisionable", "base_commission", "Metas comisiones internas HC", "Ejecución y comisiones"]
domain: "Comisiones"
market: ["CO"]
description: >
  Meta mensual y base comisionable de cada persona para cada indicador. Se extrae del PDF
  del esquema mensual, se carga a un Google Sheet y de ahí a BigQuery. Si una persona no
  tiene meta para un indicador, no cobra ese indicador.
grain: "email × metric_category × effective_date"
source_tables:
  - papyrus-delivery-data.habicredit.metas_comisiones_internas
  - papyrus-delivery-data.habicredit.metas_sop
  - papyrus-delivery-data.habicredit.metas_directores_comerciales
  - papyrus-delivery-data.habicredit.meta_analistas_hc
  - papyrus-delivery-data.habicredit.nuevos_brokers_meta_comsiones
  - papyrus-delivery-data.habicredit.tabla_productividad_brokers_comisiones
key_attributes:
  - name: "email / employee / role"
    description: "beneficiado (correo como llave), nombre y cargo"
  - name: "metric_category / unit / description"
    description: "indicador, unidad y descripción textual de la meta"
  - name: "meta_value"
    description: "valor meta"
  - name: "base_commission"
    description: "monto base sobre el que se aplica la banda de pago (COP)"
  - name: "effective_date"
    description: "mes al que aplica la meta"
relationships:
  - related_entity: "Comisión interna CO"
    relationship: "cada comisión se cruza con una meta por email + indicador + mes"
  - related_entity: "Esquema de comisiones CO"
    relationship: "las metas se extraen del PDF del mes"
business_rules_ref: ["RN-CO-001", "RN-CO-015"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-app, commit 838b8e3)"
# evidencia: CLAUDE.md:15-17,25-28,71-72; README.md:75-89; .claude/skills/extraccion-metas/SKILL.md; sql/validaciones/validacion_metas.sql:43
```

## Notas
- **Origen sin confirmar.**
  - No está confirmado que los Sheets "Ejecución y comisiones" y "Metas comisiones internas HC" sean el mismo.
  - No se sabe si la tabla es externa o nativa.
  - No se sabe si las metas auxiliares del paso 1 salen de la misma fuente que las del paso 2 (README.md:34-35, 75-89).
- **Unidades mal cargadas en el CSV local.** Por ejemplo, `calidad_kam` aparece con unidad COP y `reprocesos_kam` con unidad %.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
