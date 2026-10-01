-- Procedimiento de rotación Mesa de Salvamento.
--   col1       -> campo de entrada a la fase (created_at)
--   col2       -> campo de salida real (aprobación / rescate)
--   fase_label -> etiqueta que se guarda en la columna 'fase'
--
-- Llamada esperada:
--   CALL `papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento`(
--     'fr.inicio_subproceso_mesa_salvamento', 'mart.fecha_aprobacion', 'Rot. Mesa Salvamento');

CREATE OR REPLACE PROCEDURE `papyrus-delivery-data`.habicredit.rotacion_general_mesa_salvamento(
  col1 STRING, col2 STRING, fase_label STRING
)
BEGIN
  DECLARE query STRING;
  DECLARE full_query STRING;

  SET query = FORMAT("""
-- Rotación Mesa de Salvamento. Entra el negocio negado que pasa a rescate y sale con el
-- PRIMER evento entre aprobación (rescatado) y descarte (apagado).
-- Se excluye fuente='historico' (carga legacy sin seguimiento de fases).

  WITH diario AS (
    WITH final AS (
      WITH base AS (
        SELECT

          mart.report_id,
          DATE(%s) AS created_at,

          DATE(%s) AS f_aprobacion,

          -- Mismo respaldo que en radicación: hay negocios en fase "Descartados en
          -- radicación" sin inicio_subproceso_descartados_radicacion.
          COALESCE(
            DATE(fr.inicio_subproceso_descartados_radicacion),
            IF(mart.fase_radicacion = 'Descartados en radicación',
               DATE(fr.started_current_phase_at), NULL)
          ) AS f_descarte,

          '%s' AS fase

        FROM `papyrus-master.liquidez_gold_co.mart_habicredit` mart
        LEFT JOIN `papyrus-master.liquidez_platinum_co.fct_radicacion` fr
          ON fr.radicacion_id = mart.report_id
        WHERE mart.fuente != 'historico'
          AND fr.inicio_subproceso_mesa_salvamento IS NOT NULL
      ),
      con_salida AS (
        SELECT
          *,
          (SELECT MIN(x) FROM UNNEST([f_aprobacion, f_descarte]) x) AS entrada_finalizadas
        FROM base
      ),
      a AS (
        SELECT
          report_id,
          created_at,
          entrada_finalizadas,
          fase,
          CASE
            WHEN entrada_finalizadas IS NULL        THEN NULL
            WHEN entrada_finalizadas = f_aprobacion THEN 'aprobado'
            WHEN entrada_finalizadas = f_descarte   THEN 'descartado'
          END AS motivo_salida
        FROM con_salida
      ),
      fechas AS (
        SELECT DATE(fecha) AS fecha
        FROM papyrus-data.habi_wh.fechas
        WHERE DATE(fecha) <= CURRENT_DATE('-5')
      )
      SELECT
        f.fecha,
        COUNT(
          IF(
            f.fecha > created_at AND (f.fecha <= entrada_finalizadas OR entrada_finalizadas IS NULL),
            report_id,
            NULL
          )
        ) AS inicial,
        COUNT(IF(f.fecha = DATE_TRUNC(created_at, DAY), report_id, NULL)) AS nuevas,
        COUNT(IF(f.fecha = entrada_finalizadas, report_id, NULL)) AS salidas,

        COUNT(IF(f.fecha = entrada_finalizadas AND motivo_salida = 'aprobado',   report_id, NULL)) AS salida_real,
        COUNT(IF(f.fecha = entrada_finalizadas AND motivo_salida = 'descartado', report_id, NULL)) AS apagado,

        CASE
          WHEN EXTRACT(DAY FROM f.fecha) = 1 THEN COUNT(
            IF(
              f.fecha > created_at AND (f.fecha <= entrada_finalizadas OR entrada_finalizadas IS NULL),
              report_id,
              NULL
            )
          )
        END AS inciales_primer_dia_mes,
        CASE
          WHEN f.fecha = CASE
            WHEN EXTRACT(DAYOFWEEK FROM f.fecha) = 1 THEN DATE_SUB(f.fecha, INTERVAL 6 DAY)
            ELSE DATE_SUB(f.fecha, INTERVAL (EXTRACT(DAYOFWEEK FROM f.fecha) - 2) DAY)
          END
          THEN COUNT(
            IF(
              f.fecha > created_at AND (f.fecha <= entrada_finalizadas OR entrada_finalizadas IS NULL),
              report_id,
              NULL
            )
          )
        END AS inicial_semana,

        ANY_VALUE(fase) AS fase
      FROM a
      LEFT JOIN fechas f
        ON (fecha > created_at OR fecha = DATE_TRUNC(created_at, DAY))
      AND (fecha <= entrada_finalizadas OR entrada_finalizadas IS NULL)
      GROUP BY 1
    )
    SELECT *
    FROM final
    ORDER BY 1 DESC
  ),
  semanal AS (
    SELECT
      DATE_TRUNC(fecha, WEEK(MONDAY)) AS semana,
      SUM(inicial) AS inicial_semana,
      SUM(nuevas)  AS nuevas_semana,
      SUM(salidas) AS salidas_semana
    FROM diario
    GROUP BY 1
  )
  ,
  mes AS (
    SELECT
      DATE_TRUNC(fecha, MONTH) AS mes,
      SUM(inicial) AS inicial_mes,
      SUM(nuevas)  AS nuevas_mes,
      SUM(salidas) AS salidas_mes
    FROM diario
    GROUP BY 1
  )
  SELECT
    CURRENT_DATE('America/Bogota') AS fecha_sync,
    d.fase,
    d.fecha,
    d.inicial,
    d.nuevas,
    d.salidas,
    d.inciales_primer_dia_mes,
    d.inicial_semana,
    ---- // Semana // ----
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM d.fecha) = 2 THEN s.salidas_semana
      ELSE NULL
    END AS salidas_semana,
    SAFE_DIVIDE(
      inicial * 7,
      CASE
        WHEN EXTRACT(DAYOFWEEK FROM d.fecha) = 2 THEN s.salidas_semana
        ELSE NULL
      END
    ) AS rotacion_semana,
    ---- // Semana // ----
    ---- // Mes // ----
    CASE
      WHEN d.fecha = DATE_TRUNC(d.fecha, MONTH) THEN m.salidas_mes
      ELSE NULL
    END AS salidas_mes,
    SAFE_DIVIDE(
      inciales_primer_dia_mes * 30,
      CASE
        WHEN d.fecha = DATE_TRUNC(d.fecha, MONTH) THEN m.salidas_mes
        ELSE NULL
      END
    ) AS rotacion_mes,
    ---- // Mes // ----
    d.salida_real,
    d.apagado,

  FROM diario d
  LEFT JOIN semanal s ON DATE_TRUNC(d.fecha, WEEK(MONDAY)) = s.semana
  LEFT JOIN mes m ON DATE_TRUNC(d.fecha, MONTH) = m.mes

  ORDER BY d.fecha DESC
""", col1, col2, fase_label);

  SET full_query = FORMAT("""
    INSERT INTO `papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento`
    %s
  """, query);

  EXECUTE IMMEDIATE full_query;
END;
