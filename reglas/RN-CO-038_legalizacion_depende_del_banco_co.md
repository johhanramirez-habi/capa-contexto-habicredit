# RN-CO-038 — La legalización se ejecuta distinto en cada banco (CO)

```yaml
rule_id: "RN-CO-038"
name: "Variabilidad de la legalización por banco"
domain: "Liquidez (modelo de negocio)"
market: ["CO"]
description: >
  Las etapas de legalización son comunes, pero cada banco las ejecuta a su manera. Eso
  afecta directamente el tiempo de legalización, así que los tiempos por etapa deben
  leerse por banco.
applies_to: ["Funnel de HabiCredit CO", "Entidad financiera aliada CO", "Rotación Legalización non ibuyer CO"]
logic_summary: "diferencias posibles: legalización tercerizada, abogados internos o externos, notarías convenio (usada), desembolso contra boleta de registro o primera copia / aval constructor (nueva), avance de obra de inicio, avalúo tipo, carta de aprobación en firme desde el inicio o durante el proceso, firma de pagarés y pago del avalúo al inicio o durante el proceso"
sql_reference: |
  -- sin evidencia en el material fuente
exceptions: "sin evidencia en el material fuente"
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "Habicredit_2024.docx (fuentes/documentos)"
status: "desactualizado - por validar"
```

## Notas
- **Omitido a propósito.** El documento traía tiempos promedio, ANS y el mejor y peor banco por etapa; se omiten por instrucción del usuario.
- **Pasos por banco no incluidos.** Las particularidades del contacto inicial de cada banco que menciona el documento no se copian, porque son las que más probablemente cambiaron.

## Historial
- 2026-09-30: creación inicial desde Habicredit_2024.docx. Documento antiguo: definiciones, flujo y relaciones sin validar. Se omitieron a propósito todas sus cifras, montos, porcentajes, metas, tiempos/ANS y fechas.
