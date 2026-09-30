# Negocio (card) — HabiCredit MX

```yaml
entity: "Negocio HabiCredit MX"
aliases: ["negocio", "card", "card_id", "negocio_id", "llave_negocio", "operación", "aprobación con inmueble"]
domain: "Comisiones"
market: ["MX"]
description: >
  Operación de crédito hipotecario de HabiCredit México sobre la que se calculan las
  comisiones internas. Atraviesa dos hitos que disparan pago: la aceptación (anticipo)
  y la escrituración/desembolso (liquidación). Se identifica siempre por card_id.
grain: "una fila por card_id (llave primaria universal y estable)"
source_tables:
  - papyrus-master.liquidity_habi_credit_mx_dwh.int_cierres_bancarios_hc
  - papyrus-delivery-data.habicredit_mx.stg_pfy_habicredit_mx_bancario_comisiones
key_attributes:
  - name: "card_id"
    description: "llave universal de todo join, groupby y neteo"
  - name: "nid_de_propiedad_elegida"
    description: "NID del inmueble elegido; señal de 'inmueble definido'. No es único: nunca usarlo como llave"
  - name: "Fecha_de_aceptacion"
    description: "desde 2024-07-01 = DATE(fecha_salida_eleccion_propiedad); antes, Fecha_de_aceptacion_Forma_Anterior"
  - name: "Fecha_de_escrituracion"
    description: "fecha de escritura = desembolso del banco; nula => no se liquida"
  - name: "tipo_de_negocio"
    description: "valores observados: ibuyer, brokerage, inmobiliaria, externo"
  - name: "banco_seleccionado"
    description: "Banorte, HSBC, Santander, Scotiabank, Citibanamex, BBVA (columna monto_yave); cada uno con su columna monto_<banco>"
  - name: "monto_<banco>"
    description: "monto aprobado del banco seleccionado; base del anticipo (MXN)"
  - name: "monto_solicitado_de_cr_dito"
    description: "monto solicitado en BBDD; no es la base del anticipo (difiere del monto del banco en ~52% de filas)"
  - name: "Monto_final_credito"
    description: "monto final del crédito; base de la liquidación (MXN)"
  - name: "Experto_financiero / Analista_operaciones"
    description: "colaboradores EF y AO asignados; existe además un bloque manual (Experto_financiero.1, Analista_operaciones.1)"
  - name: "c_correo_broker / c_correo_comercial / c_canal_venta"
    description: "datos de broker y buyer (solo para reporte y comisión de brokers)"
relationships:
  - related_entity: "Colaborador comisionable MX"
    relationship: "un negocio tiene 1 EF, 1 AO y 1 Manager"
  - related_entity: "Aceptación MX"
    relationship: "un negocio tiene como máximo una aceptación que define su mes de cohorte"
  - related_entity: "Escrituración MX"
    relationship: "un negocio se liquida cuando escritura"
  - related_entity: "Anticipo de comisión MX"
    relationship: "un negocio tiene 0..n anticipos registrados (uno por colaborador y rol)"
  - related_entity: "Referido interno MX"
    relationship: "un negocio tiene 0..1 referido interno"
business_rules_ref: ["RN-MX-001", "RN-MX-002", "RN-MX-005", "RN-MX-006", "RN-MX-014"]
owner: "sin evidencia en el material fuente"
last_reviewed: "2026-09-30"
source_project: "comisiones (fuentes/comisiones_HC-MX, commit bda83ce)"
# evidencia: docs/fuentes.md:34-61,125-149; sql/anticipos_mes.plain.sql; sql/escrituracion_mes.plain.sql; src/comisiones/normalizar.py:20-27,69
```

## Notas
- El prefijo `stg_pfy_` y la etiqueta "ID Pipefy" en el reporte sugieren que el origen es Pipefy, pero ningún archivo lo declara explícitamente.
- Significado de `Fase` y de `c_canal_venta`: sin evidencia en el material fuente.

## Historial
- 2026-09-30: creación inicial (extracción piloto del proyecto comisiones).
