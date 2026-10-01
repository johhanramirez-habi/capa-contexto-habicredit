# DICCIONARIO.md

Fuente perfilada: `data.xlsx`, hoja `results-20260812-131749` (export, presumiblemente
de BigQuery, con corte 2026-08-12 11:55). **No es la tabla origen documentada en
CLAUDE.md** — el bloque `Configuración del entorno` sigue en TODO.

## Esquema observado

| Columna | Tipo | Nulos | Distintos | Qué se sabe |
|---|---|---|---|---|
| `radicacion_id` | int64 | 0 | 21.221 (= filas) | Entero, rango 21.753–187.361. Único por fila. |
| `fecha_de_radicado` | datetime | 3 | 21.210 | Con hora, sin zona horaria explícita. Rango 2023-06-14 → 2026-08-12. |
| `fecha_devolucion` | datetime | 0 | 20.533 | Con hora, sin zona. Rango 2023-10-25 → 2026-08-12. **Poblada en el 100% de las filas.** |
| `comentario_devoluci_n` | texto | 13.765 (64,9%) | 7.101 | Texto libre del analista. Mediana 160 caracteres. |
| `tipificacion_devolucion` | texto | 10.695 (50,4%) | 5 | Categoría cerrada. Ver abajo. |

## Valores de `tipificacion_devolucion`

| Valor | Filas (total histórico) |
|---|---|
| `Política documental` | 8.275 |
| `Politica interna del banco` | 1.322 |
| `Criterios mínimos de aceptación` | 757 |
| `Política score o mora` | 107 |
| `Política de edad más plazo` | 65 |
| (nulo) | 10.695 |

## Columnas derivadas — `documental_categorizado.xlsx`

Generadas por `02_clasificacion.py` sobre las 8.275 filas con
`tipificacion_devolucion = 'Política documental'`. No vienen del origen.

| Columna | Tipo | Descripción |
|---|---|---|
| `categorias_documentales` | texto (lista JSON) | Todas las causas detectadas en `comentario_devoluci_n`. Ej.: `["Documentos ilegibles", "Otros"]`. Vale `["Sin comentario"]` en las 4.583 filas sin texto. |
| `categoria_primaria` | texto | Causa dominante, una sola. Siempre contenida en `categorias_documentales`. |
| `n_categorias` | entero | Longitud de la lista. Media 1,69. |

Valores posibles: `Faltantes documentales del cliente`, `Documentos ilegibles`,
`Errores en el diligenciamiento de formularios`, `Documento vencido o desactualizado`,
`Inconsistencia en la información`, `Trámite o gestión del caso`,
`Política o condiciones del crédito`, `Otros`, `Sin comentario`.

Confiabilidad por categoría en `VALIDACION.md`. Dos categorías están por debajo de 0,70
de F1 y no deberían usarse para fijar metas sin revisión manual.

## Actualización 2026-08-31 — nuevo export y SQL de origen descubierto

Google Sheet "Nuevos datos" (id `1O8UeB8zBfwmQzviIfvWJJ2HtRTo9Lv1BbpdaFFsxeks`),
compartido por Johhan. Trae tres hojas:

- **`Extracto 1`** — 21.732 filas, mismas 5 columnas que `data.xlsx` (columna de
  comentario ahora limpia: `comentario_devolucion`, sin el mangling de acento del
  export anterior). Guardado localmente como `data_20260831.xlsx`, fuente actual de
  `00_perfilado.py`.
- **`Hoja vinculada 1`** — metadata de la query vinculada de Sheets. Contiene el
  **SQL real que genera el export**, algo que no se conocía antes (el bloque
  "Configuración del entorno" de CLAUDE.md seguía en TODO):

  ```sql
  select
    fr.radicacion_id,
    fr.fecha_de_radicado,
    inicio_subproceso_devuelto_por_banco as fecha_devolucion,
    coalesce(pr.comentario_devoluci_n, r.hist_rico_motivo_y_comentario_devoluci_n) AS comentario_devolucion,
    COALESCE(fr.tipificacion_devolucion, r.tipificaci_n_devoluci_n,
             REGEXP_EXTRACT(LTRIM(r.hist_rico_motivo_y_comentario_devoluci_n), r'^([^:]+)'), 'null'
    ) AS tipificacion_devolucion
  from `papyrus-master.liquidez_platinum_co.fct_radicacion` fr
  left join `papyrus-delivery-data.habicredit.ans_radicacion_co` r
    on fr.card_id = cast(r.card_id as int64)
  left join `papyrus-delivery-data.habicredit.responsable_radicacion` rr
    on rr.radicacion_id = fr.radicacion_id
  left join `papyrus-delivery-data.habicredit.pipe_radicacion_co` pr
    on cast(pr.card_id as int64) = fr.card_id
  where inicio_subproceso_devuelto_por_banco is not null
  ```

- **`Hoja 1`** — vacía.

**Lo que esto resuelve:** nombre de la tabla origen (`fct_radicacion`, proyecto
`papyrus-master`) y de las tablas relacionadas. Candidato fuerte para llenar el
bloque "Configuración del entorno" de CLAUDE.md — pendiente de que Ivan lo confirme
(#16 en `PREGUNTAS.md`).

**Lo que esto NO resuelve:**

- El filtro `WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL` significa que
  el recorte a "solo devueltas" es una decisión del query, no una limitación del
  origen. Sigue sin denominador.
- `tipificacion_devolucion` no es una columna simple: es un `COALESCE` de tres
  fuentes distintas, la última de las cuales es una extracción por regex de un campo
  de texto histórico. Que cualquiera de esas tres fuentes cambie corrige o rompe el
  resultado sin que cambie el `radicacion_id`.
- El query hace `LEFT JOIN responsable_radicacion rr` pero **no selecciona ninguna
  columna de `rr`**. El nombre de la tabla sugiere que ahí vive el broker/analista
  responsable — la ruta más corta para desbloquear `broker_id`/`kam` es ampliar este
  SELECT, no traer una tabla nueva (#14 en `PREGUNTAS.md`).

**Hallazgo mecánico de comparabilidad (Paso 00, no interpretado):** comparando por
`radicacion_id` el pull del 12-ago-2026 (`data.xlsx`) contra el del 31-ago-2026
(`data_20260831.xlsx`) sobre las 21.220 filas presentes en ambos:

- 512 `radicacion_id` nuevos, 1 desapareció.
- 362 filas cambiaron de `tipificacion_devolucion` entre un pull y otro. De esas,
  344 perdieron el valor (pasaron a NULL) y solo 2 ganaron uno. El resto (16) se
  movió entre dos categorías no nulas.
- Concentrado en un mes: de las 655 radicaciones de **2025-08** presentes en ambos
  pulls, 290 (44,3%) tenían `tipificacion_devolucion` con valor el 12-ago y NULL el
  31-ago. Siempre en esa dirección — cero casos al revés en ese mes. El resto de
  meses no muestra este patrón (ver `PERFILADO.md`, actualización 2026-08-31, §3).

No se interpreta la causa — es exactamente el tipo de salto que la regla 2 de
CLAUDE.md pide preguntarle a Ivan, no asumir (#15 en `PREGUNTAS.md`).

**Segundo salto, más grande, en `comentario_devolucion`:** de las 21.220 filas
presentes en ambos pulls, 4.851 (22,9%) no tenían comentario el 12-ago y sí lo
tienen el 31-ago; solo 32 perdieron el que tenían. A diferencia del salto de
`tipificacion_devolucion`, **este no es puntual de un mes — está repartido en casi
todos los meses de la ventana 2025-09..2026-07** (300 a 570 filas ganadas por mes).
Dentro de las 8.274 filas que el pull de 12-ago tipificaba `Política documental`,
4.056 de las 4.583 sin comentario (88,5%) ahora tienen texto: la cobertura de
comentario dentro de documental pasaría de 44,6% a ~93% si se reprocesa con el
export nuevo.

Hipótesis mecánica, no confirmada: el query nuevo arma `comentario_devolucion`
como `COALESCE(pr.comentario_devoluci_n, r.hist_rico_motivo_y_comentario_devoluci_n)`
— dos tablas fuente. No se puede confirmar si el export de 12-ago ya traía esta
misma lógica (su SQL no quedó documentado en su momento), así que no se sabe si el
comentario nuevo es dato que se agregó al sistema origen después del 12-ago, o si
siempre existió en `r.hist_rico_motivo_y_comentario_devoluci_n` y el query viejo
simplemente no lo traía. La distinción importa: en el primer caso el Paso 02
rerodado sobre datos nuevos sería estrictamente mejor; en el segundo, el Paso 02 ya
corrido sobre el pull de 12-ago subestimó la cobertura real desde el principio.

## Pendientes de confirmación con Ivan — NO asumidos

Cada uno bloquea decisiones aguas abajo. CLAUDE.md, regla 2: no inventar semántica.

1. **¿Este export es el universo de radicaciones o solo las devueltas?**
   Las 21.221 filas tienen `fecha_devolucion`. La lectura literal es que son solo
   devoluciones, lo que significa que **no hay denominador y no se puede calcular
   ninguna tasa**. Si existe la tabla completa, es la que se necesita.
2. **¿El grano es una fila por radicación o por evento de devolución?**
   `radicacion_id` no tiene duplicados, así que como está no se puede distinguir
   entre (a) una radicación se devuelve a lo sumo una vez, (b) el export guarda
   solo la última/primera devolución de cada radicación. Determina si `n_devoluciones`
   es calculable.
3. **¿Qué significa `tipificacion_devolucion` nula?** ¿Campo que no existía antes,
   campo opcional, o devolución sin clasificar? El perfilado muestra que es un
   cambio de proceso (ver `PERFILADO.md` §3), pero la causa es un supuesto.
4. **¿`tipificacion_devolucion` es excluyente o hay una jerarquía?** Una devolución
   con varias causas, ¿cómo se tipifica hoy?
5. **Zona horaria de las fechas.** CLAUDE.md exige zona explícita.
6. **Criterios de exclusión:** ¿hay radicaciones de prueba, de migración o de
   brokers internos en este universo? ¿Cómo se identifican?
7. **¿Existen en origen `broker_id`, `director_comercial`, `kam`, `resultado_final`?**
   Ninguno está en el export. Sin ellos, 4 de las 7 preguntas pre-registradas no
   tienen forma de responderse.
8. **9 filas con `fecha_devolucion` anterior a `fecha_de_radicado`** y 1 con lag de
   917 días. ¿Corrección manual, reproceso, o error de captura?
