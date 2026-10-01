-- Reemplazo validado de la consulta programada "reporte_bi_legalizacion"
-- (projects/890705713225/locations/us/transferConfigs/66ce1107-0000-2881-9e8c-883d24fa7920)
-- Base: papyrus-delivery-data.habicredit.main_board en vez de mart_habicredit directo.
-- Mismo destino/config: destination_table_name_template = reporte_bi_legalizacion, write_disposition = WRITE_TRUNCATE.
-- Validado el 2026-09-18 contra las filas vivas de reporte_bi_legalizacion: mismas 40 columnas,
-- mismos valores salvo diferencias explicadas por que la tabla actual es una foto de horas atrás
-- mientras esta consulta lee las fuentes en vivo (ver conversación para el detalle de la validación).
--
-- Joins que SÍ se pudieron resolver con columnas de main_board (probado 0 diferencias):
--   correo_broker, broker_id, banco (+ CASE), fecha_aprobacion, fecha_desembolso,
--   monto_desembolso, monto_aprobado (+ COALESCE con fl), analista_legalizacion -> asignacion_analista.
-- Por decisión explícita del owner (johhanramirez@habi.co, 2026-09-18) se usan también, aceptando
-- que su lógica en main_board es distinta a la de reporte_bi_legalizacion y por tanto cambia el dato
-- en algunas filas (no es solo frescura):
--   nombre_cliente -> nombre_solicitante (difiere en ~5% de filas: main_board usa fct_radicacion.cliente_id, no fl.cliente_id)
--   correo_director_comercial (difiere en filas puntuales: main_board usa broker_id_inmobiliario como
--     fallback y no dedupea dim_brokers por fecha_inicio_contrato)
-- No existen en main_board y por eso siguen con join directo:
--   fct_legalizacion, bt_legalizacion, tiempo_en_pre_legalizacion_devueltos_y_estado_legalizacion,
--   dias_en_cola_legalizacion_flow_manager_actual_y_corregido, homologacion_fases_v2.

WITH main AS (
  SELECT
    SAFE_CAST(mb.report_id AS INT64) AS report_id,

    IF(fl.fuente = 'flow_manager', fl.fase_flow_manager, fl.fase_pipefy) AS fase_actual,
    IF(fl.fuente = 'flow_manager', fl.fase_flow_manager, NULL) AS phase_name,

    fl.cliente_id AS identificacion_cliente,
    mb.nombre_cliente AS nombre_solicitante,

    mb.analista_legalizacion AS asignacion_analista,
    mb.correo_director_comercial,

    mb.correo_broker,
    mb.broker_id,

  CASE
    WHEN mb.banco = 'AV VILLAS' THEN 'Av. Villas'
    WHEN mb.banco = 'Bbva' THEN 'BBVA'
    WHEN mb.banco = 'COLPATRIA' THEN 'Scotiabank Colpatria'
    WHEN mb.banco = 'BANCODEBOGOTA' THEN 'Banco de Bogotá'
    WHEN mb.banco = 'ITAU' THEN 'Itaú'
  ELSE INITCAP(mb.banco) END AS banco,

  fl.tipo_productos,
  COALESCE(mb.monto_aprobado, fl.monto_aprobado) AS monto_aprobado,
  mb.monto_desembolso,

  mb.fecha_desembolso,
  mb.monto_desembolso AS monto_desembolso_raw,
  COALESCE(comentarios_fm, comentarios_pipefy) AS business_comments,

  fl.notaria,
  fl.nombre_abogado,
  fl.perito,
  fl.fecha_tentativa_escrituracion,
  fl.banco_cedente,

  CASE
      WHEN `papyrus-delivery-data.operaciones_global.workdays_hc_co`(DATE(
        IF(fl.fuente = 'flow_manager', DATE(fl.fecha_inicio_fase_fm ),DATE(fl.fecha_inicio_fase_pipefy))
      ), CURRENT_DATE('America/Bogota')) - 1 - IFNULL(dias_en_pre_legalizacion_devuelto_habiles,0) < 0
        THEN `papyrus-delivery-data.operaciones_global.workdays_hc_co`(DATE(
          IF(fl.fuente = 'flow_manager', DATE(fl.fecha_inicio_fase_fm ),DATE(fl.fecha_inicio_fase_pipefy))
        ), CURRENT_DATE('America/Bogota')) - IFNULL(dias_en_pre_legalizacion_devuelto_habiles, 0)
      ELSE `papyrus-delivery-data.operaciones_global.workdays_hc_co`(DATE(
        IF(fl.fuente = 'flow_manager', DATE(fl.fecha_inicio_fase_fm ),DATE(fl.fecha_inicio_fase_pipefy))
      ), CURRENT_DATE('America/Bogota')) - 1 - IFNULL(dias_en_pre_legalizacion_devuelto_habiles, 0)
  END AS dias_habiles_en_fase,

  `papyrus-delivery-data.operaciones_global.workdays_hc_co`(DATE(fecha_inicio_legalizacion), COALESCE(DATE(mb.fecha_desembolso), CURRENT_DATE('America/Bogota'))) - ta.dias_en_pre_legalizacion_devuelto_habiles_acumulado AS dias_habiles_en_legalizacion,

  GREATEST (
    IF(DATETIME(fl.date_updated) IS NULL,DATETIME('2000-01-01'), DATETIME(fl.date_updated)),
    IF(DATETIME(fecha_comentario_fm) IS NULL,DATETIME('2000-01-01'), DATETIME(fecha_comentario_fm)),
    IF(DATETIME(fecha_comentario_pipefy) IS NULL,DATETIME('2000-01-01'), DATETIME(fecha_comentario_pipefy) )
    ) AS date_updated,

  GREATEST (
  IF(DATETIME(fecha_inicio_fase_pipefy) IS NULL,DATETIME('2000-01-01'), DATETIME(fecha_inicio_fase_pipefy)),
  IF(DATETIME(fl.fecha_inicio_fase_fm) IS NULL,DATETIME('2000-01-01'), DATETIME(fl.fecha_inicio_fase_fm)),
  IF(DATETIME(fl.date_updated) IS NULL,DATETIME('2000-01-01'), DATETIME(fl.date_updated)),
  IF(DATETIME(fecha_comentario_pipefy) IS NULL,DATETIME('2000-01-01'), DATETIME(fecha_comentario_pipefy)),
  IF(DATETIME(fecha_comentario_fm) IS NULL, DATETIME('2000-01-01'), DATETIME(fecha_comentario_fm))) AS fecha_ultima_gestion,

  fl.fecha_inicio_fase_fm,

  fl.bloqueo_fm,
  fl.fuente,

  mb.fecha_aprobacion,

  fl.numero_credito,
  fl.fecha_orden_escrituracion,
  fl.fecha_firma_escritura,
  fl.nid,
  fl.enviado_a_banco,
  fl.fecha_radicacion_oferta_vinculante,
  fl.nombre_constructora,

  fl.cliente_acepto_seguro,
  fl.aceptacion_seguro_enviado_banco,
  fl.numero_escritura,

  fl.linea_credito,

  FROM `papyrus-delivery-data.habicredit.main_board` mb
  LEFT JOIN `papyrus-master.liquidez_platinum_co.fct_legalizacion` fl ON fl.legalizacion_id = CAST(mb.report_id AS INT64)
  LEFT JOIN `papyrus-delivery-data.habicredit.dias_en_cola_legalizacion_flow_manager_actual_y_corregido` dcl ON dcl.report_id = CAST(mb.report_id AS INT64)
  LEFT JOIN (select report_id, inicio_actividad AS fecha_inicio_legalizacion,
            from  `papyrus-master.liquidez_platinum_co.bt_legalizacion`
            where actividad = 'Nuevo negocio') inn ON inn.report_id = CAST(mb.report_id AS INT64)
LEFT JOIN (select report_id, SUM(dias_en_pre_legalizacion_devuelto_habiles) AS dias_en_pre_legalizacion_devuelto_habiles_acumulado, COUNT(distinct dias_en_pre_legalizacion_devuelto_habiles) AS conteo_devoluciones
          from `papyrus-delivery-data.habicredit.tiempo_en_pre_legalizacion_devueltos_y_estado_legalizacion`
          WHERE dias_en_pre_legalizacion_devuelto_habiles IS NOT NULL
          GROUP BY 1
)  ta ON CAST(ta.report_id AS INT64) = CAST(mb.report_id AS INT64)
  WHERE fase_flow_manager IS NOT NULL OR fase_pipefy NOT IN ('Migración 2.0', 'Corrección de Card (Radicación)')
)

, legalizacion_hc AS (
  SELECT
    report_id,
    COALESCE(fase_02, main.fase_actual) AS fase_actual,
    main.*
    EXCEPT(report_id, fase_actual),

    `papyrus-delivery-data.operaciones_global.workdays_hc_co`(DATE(fecha_ultima_gestion), CURRENT_DATE('-5'))-1 AS dias_habiles_ultima_gestion,

  FROM main
  LEFT JOIN `papyrus-delivery-data.habicredit.homologacion_fases_v2` fh ON TRIM(fase_actual) = TRIM(fh.fase_01)

  WHERE main.fase_actual NOT IN ('Bolsa', 'Descartados legalización', 'Desistidos', 'Desistidos legalización')
  ORDER BY report_id ASC
)

SELECT
  legalizacion_hc.*EXCEPT(asignacion_analista, correo_director_comercial),

  asignacion_analista,
  correo_director_comercial,

FROM legalizacion_hc
QUALIFY ROW_NUMBER() OVER (PARTITION BY report_id) = 1
