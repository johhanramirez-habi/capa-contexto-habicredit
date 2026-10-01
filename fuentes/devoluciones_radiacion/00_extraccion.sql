-- 00_extraccion.sql — Extracción de origen (previa al Paso 00 de CLAUDE.md)
--
-- Pregunta que responde: ninguna de PREGUNTAS.md. Es el query que arma el
-- insumo crudo sobre el que corren 00_perfilado.py / 02_clasificacion.py.
--
-- Fecha:   2026-08-31
-- Autor:   Claude (sesión Johhan Ramirez), a partir del query real encontrado en
--          la hoja "Hoja vinculada 1" del Google Sheet "Nuevos datos"
--          (id 1O8UeB8zBfwmQzviIfvWJJ2HtRTo9Lv1BbpdaFFsxeks). No se modificó la
--          lógica ni las referencias a columnas/tablas: es el mismo query,
--          solo reformateado a la convención de CLAUDE.md (mayúsculas en
--          palabras clave, snake_case, alias explícitos con AS, sin SELECT *).
--          `inicio_subproceso_devuelto_por_banco` se dejó sin prefijo de tabla
--          a propósito, igual que en el original: el query fuente no lo
--          calificaba y no hay forma de confirmar aquí a cuál de las 4 tablas
--          pertenece sin acceso a BigQuery (por contexto casi seguro es de
--          `fr`, pero se prefirió no adivinar sobre el query verbatim).
--
-- Ejecutado tal cual, hoy, produce el mismo resultado que
-- data_20260831.xlsx — más las radicaciones devueltas que hayan entrado al
-- origen desde ese corte (2026-08-31) hasta el momento en que se corra. Eso es
-- lo esperado para un proceso recurrente: no lleva filtro de fecha de corte a
-- propósito, para que cada corrida traiga todo lo disponible hasta ese momento.
-- Si se necesita reproducir exactamente el corte del 31-ago para una auditoría,
-- agregar:
--   AND inicio_subproceso_devuelto_por_banco <= TIMESTAMP('2026-08-31 23:59:59', 'America/Bogota')
--
-- Limitaciones conocidas, sin resolver (ver DICCIONARIO.md y PREGUNTAS.md #14-#17):
--   1. Solo trae radicaciones DEVUELTAS (ver WHERE). No hay universo completo,
--      así que de esta tabla no sale ninguna tasa de devolución — solo conteo
--      y composición de devoluciones. Pendiente confirmar con Ivan si existe una
--      vista/tabla hermana sin este filtro (pregunta #16).
--   2. `responsable_radicacion` (alias rr) está JOINEADA pero no se selecciona
--      ninguna columna suya. Por nombre, es la candidata más probable a tener
--      broker_id / analista responsable — desbloquearía las preguntas #2, #4 y
--      #5 de PREGUNTAS.md. Pendiente que Ivan / el equipo de datos confirme qué
--      columnas trae y las agregue al SELECT (pregunta #14).
--   3. `comentario_devolucion` y `tipificacion_devolucion` no son columnas
--      estables: se observó que pueden cambiar retroactivamente para una misma
--      `radicacion_id` entre dos corridas del mismo query en fechas distintas
--      (ver DICCIONARIO.md, Iteración 3 de BITACORA.md, preguntas #15 y #17).
--      Un proceso automatizado que corra este query periódicamente debe asumir
--      que el historial se puede reescribir, no solo crecer.
--   4. Zona horaria de `fecha_de_radicado` / `fecha_devolucion`: el origen no la
--      trae explícita. No se fuerza ninguna aquí para no inventar un supuesto de
--      negocio (regla 2 de CLAUDE.md) — confirmar con Ivan antes de asumir
--      America/Bogota en pasos posteriores.
--
-- Para automatizar: guardar este query como BigQuery Scheduled Query con
-- destino a una tabla física en el dataset de trabajo (bloque "Configuración
-- del entorno" de CLAUDE.md, todavía en TODO) — por ejemplo con
-- `CREATE OR REPLACE TABLE `<dataset_trabajo>.radicaciones_devueltas` AS`
-- antepuesto al SELECT, o usando el destino nativo del programador de queries.

SELECT
    fr.radicacion_id,
    fr.fecha_de_radicado,
    inicio_subproceso_devuelto_por_banco AS fecha_devolucion,

    -- comentario_devolucion: primero el campo estructurado del pipe de
    -- radicación; si no existe, cae al texto histórico de motivo+comentario.
    COALESCE(
        pr.comentario_devoluci_n,
        r.hist_rico_motivo_y_comentario_devoluci_n
    ) AS comentario_devolucion,

    -- tipificacion_devolucion: prioriza el campo estructurado de fct_radicacion;
    -- si no existe, cae a la tipificación histórica; si tampoco existe, intenta
    -- extraer la primera etiqueta (antes de ":") del texto histórico de motivo;
    -- si nada de eso existe, devuelve el literal 'null'.
    COALESCE(
        fr.tipificacion_devolucion,
        r.tipificaci_n_devoluci_n,
        REGEXP_EXTRACT(LTRIM(r.hist_rico_motivo_y_comentario_devoluci_n), r'^([^:]+)'),
        'null'
    ) AS tipificacion_devolucion

FROM `papyrus-master.liquidez_platinum_co.fct_radicacion` AS fr
LEFT JOIN `papyrus-delivery-data.habicredit.ans_radicacion_co` AS r
    ON fr.card_id = CAST(r.card_id AS INT64)
LEFT JOIN `papyrus-delivery-data.habicredit.responsable_radicacion` AS rr
    ON rr.radicacion_id = fr.radicacion_id
LEFT JOIN `papyrus-delivery-data.habicredit.pipe_radicacion_co` AS pr
    ON CAST(pr.card_id AS INT64) = fr.card_id
WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL
