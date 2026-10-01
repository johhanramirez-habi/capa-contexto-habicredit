-- 02_clasificacion.sql — Extracción + Paso 02 del pipeline (CLAUDE.md), en un
-- solo query.
--
-- Pregunta que responde: #10 — dentro de `Política documental`, ¿qué falló
-- concretamente? Mismo resultado que `documental_categorizado_20260831.xlsx`.
--
-- Fecha:  2026-08-31
-- Autor:  Claude (sesión Johhan Ramirez)
--
-- Es el mismo query de `00_extraccion.sql` (ver ese archivo para las
-- limitaciones de la extracción: solo trae devueltas, `responsable_radicacion`
-- joineada sin usar, columnas de motivo inestables entre corridas), más un
-- port a SQL de la lógica de `02_clasificacion.py` (clasificador léxico sobre
-- `comentario_devolucion`, validado en `VALIDACION.md` — Iteración 5).
--
-- FIDELIDAD DEL PORT: se comparó fila por fila contra el resultado real de
-- `02_clasificacion.py` sobre las 8.481 filas de 'Política documental' del
-- 31-ago-2026. El conjunto de categorías (`categorias_documentales`) coincide
-- al 100%. La categoría PRIMARIA coincide en 99,41% (8.431/8.481); las 50
-- discrepancias son todas casos de empate numérico entre `Errores en el
-- diligenciamiento de formularios` y otra categoría, por un detalle que RE2
-- (el motor de regex de BigQuery) no soporta: el Python original usa un
-- *negative lookahead* para no contar "formato" cuando va seguido de
-- "pdf/digital/excel/word" (`formato(?!\s+(?:pdf|digital|excel|word))`). Acá
-- se aproxima como una condición aparte (ver bloque `golpes`) que decide bien
-- SI la categoría aplica, pero cuenta como máximo 1 coincidencia de "formato"
-- en vez del conteo exacto de apariciones — solo afecta a cuál categoría gana
-- un empate de conteo, nunca si `Errores en el diligenciamiento` aparece o no
-- en la lista de categorías.
--
-- Nota sobre `Otros`/`Código o jerga interna del banco`: ambas son tags de
-- respaldo (`FALLBACK` en el Python), no causas reales — si el comentario ya
-- tiene una causa real, no se reportan aunque su palabra gatillo aparezca
-- (ver `clasificar()` en 02_clasificacion.py y BITACORA.md Iteración 5, donde
-- se corrigió un bug de precisión por esto mismo). Por esa misma lógica, las
-- palabras gatillo propias de `Otros` (avaluo, garantia, embargo...) nunca
-- cambian el resultado final en el Python actual — solo importa si matchea
-- ALGO real o `Código interno`; por eso este query no las evalúa: omitirlas
-- es fiel al comportamiento real, no una simplificación.

WITH extraccion AS (
    SELECT
        fr.radicacion_id,
        fr.fecha_de_radicado,
        inicio_subproceso_devuelto_por_banco AS fecha_devolucion,
        COALESCE(
            pr.comentario_devoluci_n,
            r.hist_rico_motivo_y_comentario_devoluci_n
        ) AS comentario_devolucion,
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
),

documental AS (
    -- TIPIFICACION_OBJETIVO en 02_clasificacion.py.
    SELECT
        radicacion_id,
        fecha_de_radicado,
        fecha_devolucion,
        tipificacion_devolucion,
        comentario_devolucion,
        -- normalizar(): minúsculas, sin acentos (NFD + quitar marcas
        -- combinantes, equivalente a unicodedata.category(c) != 'Mn'),
        -- espacios colapsados.
        CASE
            WHEN comentario_devolucion IS NULL OR TRIM(comentario_devolucion) = '' THEN NULL
            ELSE TRIM(REGEXP_REPLACE(
                REGEXP_REPLACE(NORMALIZE(LOWER(comentario_devolucion), NFD), r'\p{Mn}', ''),
                r'\s+', ' '
            ))
        END AS t
    FROM extraccion
    WHERE tipificacion_devolucion = 'Política documental'
),

golpes AS (
    SELECT
        *,
        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'\bfalta\b|\bfaltan\b|faltante|hace\s+falta|\bcarece|no\s+(?:\w+\s+){0,2}?(?:se\s+)?(?:adjunt|anex|aport|carg|remit|allega|suministr|relacion|especific)|sin\s+(?:adjuntar|anexar|el\s+soporte|soporte)|\badjunt(?:ar|e|en|ando)\b|\banex(?:ar|e|en|ando)\b|\baport(?:ar|e|en|ando)\b|\balleg(?:ar|ue|uen|ando)\b|\bsuministr(?:ar|e|en|ando)\b|\benv(?:iar|ie|ien|iando)\b|\bremit(?:ir|a|an|iendo)\b|\bcarg(?:ar|ue|uen|ando)\b|\bpendiente\b|se\s+(?:le\s+)?(?:solicita|solicitan|requiere|requieren|necesita|necesitan|pide|piden)|(?:solicita|solicitan|requiere|requieren)\s+(?:el|la|los|las|documento|carta|certificad|copia|soporte|antiguedad|extracto|declaracion)|(?:banco|area)\s+solicita|quedamos\s+a\s+la\s+espera|\bespera\s+de\b|completitud|documentacion\s+incompleta|errores?\s+en\s+la\s+document|no\s+se\s+logra\s+contact|ilocaliz'
        )) AS n_faltante,

        -- Errores en el diligenciamiento de formularios: base + "formato" (sin
        -- lookahead, ver nota de fidelidad arriba).
        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'diligenci|sin\s+llenar|formulario|\bsipla\b|conocimiento\s+del\s+cliente|autorizacion\s+de\s+consulta|carta\s+de\s+beneficios|\bplanilla\b|perfil\s+(?:diligenciad|sin|mal|a\s+mano)|casilla|\bfirma\b|\bfirmas\b|sin\s+firmar|firmad|\bhuella|tachon|enmendadura|pu[nñ]o\s+y\s+letra|(?:campo|espacio)s?\s+(?:en\s+blanco|vacio|sin|no\s+diligenciad)|marcar\s+(?:la|el|con)|mal\s+marcad|sin\s+marcar|sobrepuest'
        ))
        + IF(
            REGEXP_CONTAINS(t, r'formato')
            AND NOT REGEXP_CONTAINS(t, r'formato\s+(?:pdf|digital|excel|word)'),
            1, 0
        ) AS n_formulario,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'vencid|no\s+mayor\s+a\s+\d+|mayor\s+a\s+\d+\s+dias|superior\s+a\s+\d+\s+dias|no\s+superior\s+a|desactualiz|no\s+(?:se\s+encuentra\s+)?vigente|fuera\s+de\s+vigencia|\bvigencia\b|actualiz|renovar|expedid[oa]\s+(?:hace|con)|reciente\s+expedicion'
        )) AS n_vencido,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'inconsist|no\s+coincid|no\s+concuerd|no\s+corresponde|no\s+corresponden|no\s+cruza|no\s+cuadra|difiere|diferencia|diferente\s+a|distint[oa]\s+a|discrepanc|contradic|mal\s+digitad|error\s+de\s+digitacion|digitad[oa]\s+mal|errad[oa]|equivocad|incorrect|no\s+es\s+el\s+mismo|no\s+son\s+iguales|dato\s+err|datos\s+err|no\s+justifica|no\s+soporta|no\s+se\s+refleja|\bvariacion\b'
        )) AS n_inconsistencia,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'ilegib|legible|borros|mala\s+calidad|baja\s+calidad|mejor\s+calidad|no\s+se\s+(?:alcanza\s+a\s+)?(?:leer|lee)|no\s+se\s+logra\s+(?:leer|visualizar)|no\s+se\s+(?:visualiza|observa|distingue|aprecia)|ampliad?[ao]?\s+al\s+150|ampliar\s+al\s+150|150\s*%|(?:ambas|dos)\s+caras|una\s+sola\s+hoja|por\s+ambos\s+lados|escane|nitid|difus|pixel|calidad\s+de\s+(?:la\s+)?imagen|(?:mas|sea|ser|este|queden?)\s+clar|recortad|\bcortad|foto\s+(?:del|de\s+la)|se\s+encuentra\s+ilegible'
        )) AS n_ilegible,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'no\s+(?:se\s+)?(?:avanz|finaliz|registra|aparece|refleja)|caso\s+digital|reproceso|no\s+hay\s+solicitud|(?:solicitud|radicacion)\s+(?:abierta|vigente|activa)|caso\s+abierto|en\s+el\s+link|\bplataforma\b|\bmantiz\b|pantallazo|duplicad|\bbuzon\b|crear\s+el\s+caso|volver\s+a\s+radicar|desistimient|se\s+cierra|\bcerrado\b|\bsistema\b|error\s+en\s+el\s+(?:sistema|aplicativo)|\baplicativo\b|doble\s+radicad|radicad[oa]\s+(?:vigente|por\s+oficina)|oficina\s+desist|canal\s+de\s+referidos|por\s+este\s+canal|campa[nñ]a\s+(?:cerrada|con\s+el\s+banco)|asesor\s+de\s+la\s+fuerza|caso\s+aprobado\s+con|otra\s+entidad\s+financiera|caduc|derecho\s+ciudad|zona\s+correspondiente|encargad[oa]\s+de\s+la\s+zona'
        )) AS n_tramite,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'\bburo\b|centrales\s+de\s+riesgo|seguridad\s+social|capacidad\s+de\s+(?:pago|endeudamiento)|politica[s]?\s+(?:del|de\s+la)\s+(?:banco|entidad)|no\s+cumple\s+(?:con\s+)?(?:la\s+)?(?:politica|antiguedad|el\s+perfil|buro|los\s+criterios)|\bscore\b|\bmora\b|endeudamiento|antiguedad\s+laboral|no\s+(?:es\s+)?viable|viabilidad|\btasa\b|\bplazo\b|menor\s+monto|monto\s+aprobado|\bcupo\b|subsidio|\bpep\b|persona\s+expuesta|incumple\s+politicas|condiciones\s+de\s+producto|no\s+procede|bases\s+internas'
        )) AS n_politica,

        ARRAY_LENGTH(REGEXP_EXTRACT_ALL(t,
            r'\b\d{3}\.\d\b|\bsoi\b|\bbpp\b|\bsarlaft\b|\bcifin\b|\bbonita\b|analisis\s+soi|verificacion\s+soi|no\s+aplica\s+referenciacion|referenciacion\s+cliente|validacion\s+documental\s+satisfactoria|vta\s+cruzada|venta\s+cruzada'
        )) AS n_banco_interno

    FROM documental
    WHERE t IS NOT NULL
),

clasificado AS (
    SELECT
        radicacion_id,
        fecha_de_radicado,
        fecha_devolucion,
        tipificacion_devolucion,
        comentario_devolucion,
        GREATEST(n_faltante, n_formulario, n_vencido, n_inconsistencia, n_ilegible, n_tramite, n_politica) AS maximo,
        n_faltante, n_formulario, n_vencido, n_inconsistencia, n_ilegible, n_tramite, n_politica, n_banco_interno
    FROM golpes
),

resultado AS (
SELECT
    radicacion_id,
    fecha_de_radicado,
    fecha_devolucion,
    tipificacion_devolucion,
    comentario_devolucion,

    -- categorias_documentales: si hay al menos una causa real (documental,
    -- trámite o política), se listan todas las que coincidieron, en el orden
    -- de PRIORIDAD del Python. Si no, cae a Código interno del banco o a
    -- Otros — nunca ambos a la vez con una causa real (ver nota de arriba).
    CASE
        WHEN maximo > 0 THEN ARRAY(
            SELECT cat FROM UNNEST([
                IF(n_faltante > 0, 'Faltantes documentales del cliente', NULL),
                IF(n_formulario > 0, 'Errores en el diligenciamiento de formularios', NULL),
                IF(n_vencido > 0, 'Documento vencido o desactualizado', NULL),
                IF(n_inconsistencia > 0, 'Inconsistencia en la información', NULL),
                IF(n_ilegible > 0, 'Documentos ilegibles', NULL),
                IF(n_tramite > 0, 'Trámite o gestión del caso', NULL),
                IF(n_politica > 0, 'Política o condiciones del crédito', NULL)
            ]) AS cat
            WHERE cat IS NOT NULL
        )
        WHEN n_banco_interno > 0 THEN ['Código o jerga interna del banco (sin narrativa)']
        ELSE ['Otros']
    END AS categorias_documentales,

    -- categoria_primaria: primer nombre de PRIORIDAD cuyo conteo == máximo.
    CASE
        WHEN maximo = 0 AND n_banco_interno > 0 THEN 'Código o jerga interna del banco (sin narrativa)'
        WHEN maximo = 0 THEN 'Otros'
        WHEN n_faltante = maximo THEN 'Faltantes documentales del cliente'
        WHEN n_formulario = maximo THEN 'Errores en el diligenciamiento de formularios'
        WHEN n_vencido = maximo THEN 'Documento vencido o desactualizado'
        WHEN n_inconsistencia = maximo THEN 'Inconsistencia en la información'
        WHEN n_ilegible = maximo THEN 'Documentos ilegibles'
        WHEN n_tramite = maximo THEN 'Trámite o gestión del caso'
        ELSE 'Política o condiciones del crédito'
    END AS categoria_primaria

FROM clasificado

UNION ALL

-- Filas de 'Política documental' sin comentario (o vacío tras trim) ->
-- 'Sin comentario', igual que el Python.
SELECT
    radicacion_id,
    fecha_de_radicado,
    fecha_devolucion,
    tipificacion_devolucion,
    comentario_devolucion,
    ['Sin comentario'] AS categorias_documentales,
    'Sin comentario' AS categoria_primaria
FROM documental
WHERE t IS NULL
)

-- n_categorias = ARRAY_LENGTH(categorias_documentales) en el Python.
SELECT
    *,
    ARRAY_LENGTH(categorias_documentales) AS n_categorias
FROM resultado
