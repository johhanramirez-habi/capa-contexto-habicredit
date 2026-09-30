# Meta WBR por país

```yaml
entity: "Meta WBR por país"
aliases: ["wbr_metas_pais", "corp_gov_global.wbr_metas_pais", "meta del mes (WBR)"]
domain: "Liquidez (WBR)"
market: ["CO"]
description: >
  Metas mensuales de los indicadores del WBR, por infraestructura (área) y país. Liquidez
  Colombia toma de aquí las metas de Radicaciones y de Desembolsos HC Bancario.
grain: "infraestructura × país × mes × nombre_de_meta"
source_tables:
  - papyrus-delivery-data.corp_gov_global.wbr_metas_pais
key_attributes:
  - name: "infraestructura"
    description: "área de negocio; Liquidez filtra 'liquidez'"
  - name: "pais"
    description: "Liquidez filtra 'Colombia'"
  - name: "mes"
    description: "primer día del mes de la meta"
  - name: "nombre_de_meta"
    description: "nombre del indicador (igual al nombre del indicador en el WBR, p. ej. 'Radicaciones', 'Desembolsos HC Bancario')"
  - name: "meta"
    description: "meta mensual completa (se prorratea con la curva estacional, RN-CO-025)"
relationships:
  - related_entity: "Serie diaria WBR Liquidez CO"
    relationship: "cada indicador de flujo del WBR se compara contra su meta del mes"
business_rules_ref: ["RN-CO-025", "RN-CO-026"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "docs-wbr-reportes/liquidez (fuentes/docs-wbr-reportes, commit a2f98cc)"
# evidencia: liquidez/wbr_liquidez_co.sql:169-174
```

## Notas
- **Alcance de la tabla.** Es global: tiene columnas de infraestructura y país. Aquí solo se documenta el uso de Liquidez Colombia, por eso `market: ["CO"]`.
- **Metas de otro origen.** No es la misma tabla que las metas de comisiones ([meta_comisiones_co.md](meta_comisiones_co.md)), que son por persona. La meta de la rotación de legalización (70 días) no viene de esta tabla: es una constante del SQL de origen todavía no confirmado (ver [rotacion_legalizacion_non_ibuyer_co.md](../metricas/rotacion_legalizacion_non_ibuyer_co.md)).

## Historial
- 2026-09-30: creación inicial (extracción del WBR de Liquidez).
