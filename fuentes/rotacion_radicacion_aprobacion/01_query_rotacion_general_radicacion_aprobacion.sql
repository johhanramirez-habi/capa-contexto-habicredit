-- Rotación Radicación -> Aprobación (histórico hasta la fecha objetivo)
-- Equivalente ejecutable del procedimiento habicredit.rotacion_general_radicacion_aprobacion
--
-- Entrada: fecha_radicacion
-- Salida : la aprobación si existe; si no, el primer evento entre descarte y
--          negado/entrada a salvamento.
--          Un negocio negado y luego rescatado sale aquí en la APROBACIÓN, para que esa
--          gestión cuente como salida real y no se pierda de vista del equipo.
--          Contrapartida asumida: sus días de rescate quedan contados también en la
--          rotación de mesa de salvamento.
-- Universo: se excluye fuente='historico' (9.135 filas de carga legacy sin seguimiento
--          de fases: 100% de 2020, 99,6% de 2021, 91,3% de 2022, ~0% desde 2023).
--
-- Los ~6.500 negocios con fecha_aprobacion anterior a fecha_radicacion no cruzan con
-- ninguna fecha y caen en la fila de fecha NULL, en ceros. Es una decisión consciente:
-- no se cuentan ni como nuevas ni como salidas.

WITH diario AS (
  WITH final AS (
    WITH base AS (
      SELECT

        mart.report_id,
        DATE(mart.fecha_radicacion) AS created_at,

        DATE(mart.fecha_aprobacion) AS f_aprobacion,

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

        'Rot. Radicacion Aprobacion' AS fase

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
      -- Motivo único de salida. La prioridad solo desempata cuando dos eventos caen el
      -- mismo día; así salida_real + apagado + negado = salidas, sin doble conteo.
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
      FROM `papyrus-data.habi_wh.fechas`
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
),
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
  d.negado

FROM diario d
LEFT JOIN semanal s ON DATE_TRUNC(d.fecha, WEEK(MONDAY)) = s.semana
LEFT JOIN mes m ON DATE_TRUNC(d.fecha, MONTH) = m.mes

ORDER BY d.fecha DESC
