-- Procedimiento de rotación general Radicación -> Aprobación.
-- Mismo patrón que habicredit.rotacion_general_pre_legalizacion:
--   col1       -> campo de entrada a la fase (created_at)
--   col2       -> campo de salida real (aprobación)
--   fase_label -> etiqueta que se guarda en la columna 'fase'
--
-- Llamada esperada:
--   CALL `papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion`(
--     'mart.fecha_radicacion', 'mart.fecha_aprobacion', 'Rot. Radicacion Aprobacion');

CREATE OR REPLACE PROCEDURE `papyrus-delivery-data`.habicredit.rotacion_general_radicacion_aprobacion(
  col1 STRING, col2 STRING, fase_label STRING
)
BEGIN
  DECLARE query STRING;
  DECLARE full_query STRING;

  SET query = FORMAT("""
-- Rotación (histórico hasta la fecha objetivo). Sale con la aprobación si existe; si no,
-- con el primer evento entre descarte y negado/entrada a salvamento. Un negocio rescatado
-- cuenta como salida real aquí, aunque sus días también se cuenten en salvamento.
-- Se excluye fuente='historico' (carga legacy sin seguimiento de fases).

  WITH diario AS (
    WITH final AS (
      WITH base AS (
        SELECT

          mart.report_id,
          DATE(%s) AS created_at,

          DATE(%s) AS f_aprobacion,

          -- Respaldo: 325 negocios quedaron en fase "Descartados en radicación" sin que el
          -- pipeline llenara inicio_subproceso_descartados_radicacion. Como esa ES su fase
          -- actual, started_current_phase_at es la fecha en que los descartaron.
          COALESCE(
            DATE(fr.inicio_subproceso_descartados_radicacion),
            IF(mart.fase_radicacion = 'Descartados en radicación',
               DATE(fr.started_current_phase_at), NULL)
          ) AS f_descarte,

          -- Entrar a mesa de salvamento equivale a salir de radicación. A veces el negado
          -- no quedó registrado y sin esto el negocio queda abierto en las dos rotaciones.
          (SELECT MIN(x) FROM UNNEST([
            DATE(fr.inicio_subproceso_negado),
            DATE(fr.inicio_subproceso_mesa_salvamento)
          ]) x) AS f_negado,

          '%s' AS fase

        FROM `papyrus-master.liquidez_gold_co.mart_habicredit` mart
        LEFT JOIN `papyrus-master.liquidez_platinum_co.fct_radicacion` fr
          ON fr.radicacion_id = mart.report_id
        WHERE mart.fuente != 'historico'
      ),
      con_salida AS (
        SELECT
          *,
          -- La aprobación manda sobre los demás eventos: un negocio negado y luego
          -- rescatado sale aquí en la aprobación, no en el negado, para que esa gestión
          -- cuente como salida real. Si nunca se aprobó, sale con el evento más temprano.
          COALESCE(
            f_aprobacion,
            (SELECT MIN(x) FROM UNNEST([f_descarte, f_negado]) x)
          ) AS entrada_finalizadas
        FROM base
      ),
      a AS (
        -- Motivo único de salida; la prioridad solo desempata eventos del mismo día.
        SELECT
          report_id,
          created_at,
          entrada_finalizadas,
          fase,
          CASE
            WHEN entrada_finalizadas IS NULL        THEN NULL
            WHEN entrada_finalizadas = f_aprobacion THEN 'aprobado'
            WHEN entrada_finalizadas = f_descarte   THEN 'descartado'
            WHEN entrada_finalizadas = f_negado     THEN 'negado'
          END AS motivo_salida
        FROM con_salida
      ),
      -- Histórico desde el inicio hasta la fecha objetivo (incluida)
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
        COUNT(IF(f.fecha = entrada_finalizadas AND motivo_salida = 'negado',     report_id, NULL)) AS negado,

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
    d.negado,

  FROM diario d
  LEFT JOIN semanal s ON DATE_TRUNC(d.fecha, WEEK(MONDAY)) = s.semana
  LEFT JOIN mes m ON DATE_TRUNC(d.fecha, MONTH) = m.mes

  ORDER BY d.fecha DESC
""", col1, col2, fase_label);

  SET full_query = FORMAT("""
    INSERT INTO `papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion`
    %s
  """, query);

  EXECUTE IMMEDIATE full_query;
END;
