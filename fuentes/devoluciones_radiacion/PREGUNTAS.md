# PREGUNTAS.md

Estado: `pendiente` / `respondida` / `descartada` / `bloqueada`.
`bloqueada` = la pregunta sigue siendo válida pero la fuente actual no permite
responderla; se indica qué dato falta.

Toda query nueva debe responder una pregunta de esta lista. Preguntas nuevas se
agregan **antes** de correr la query, con fecha.

## v1 — pre-registradas en CLAUDE.md

| # | Pregunta | Estado | Nota |
|---|---|---|---|
| 1 | ¿La tasa sube, baja o está estable por cohorte semanal? | **bloqueada** | Falta el denominador: el export solo trae radicaciones devueltas. Con lo que hay solo se puede contar devoluciones, y un conteo se mueve con el volumen de radicación. Actualización 2026-08-31: el SQL del export confirma `WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL` — el recorte es deliberado en el query, no un límite del export. Ver #16. |
| 2 | ¿Está concentrada en pocos brokers o es transversal? | **bloqueada** | No existe `broker_id` en el export. Actualización 2026-08-31: el query hace `LEFT JOIN responsable_radicacion rr` pero no selecciona ninguna columna de `rr`. Es la ruta más corta para desbloquear esta pregunta — ver #14. |
| 3 | ¿Qué categorías concentran el volumen? | **respondida (parcial)** | `00_perfilado.py` §9 / `PERFILADO.md` §8. Composición sobre 7.905 devoluciones tipificadas (2025-09..2026-07): Política documental 83,5%. Parcial porque (a) es composición, no tasa; (b) `tipificacion_devolucion` tiene 5 valores, no la taxonomía de dos ejes del Paso 02; (c) 37,6% del histórico no tiene ningún campo de motivo. |
| 4 | ¿Las devoluciones se concentran en brokers nuevos? | **bloqueada** | No existe `broker_id` ni fecha de alta del broker. Mismo unblock potencial que #2 — ver #14. |
| 5 | ¿Hay variación alta entre analistas para el mismo motivo? | **bloqueada** | No existe identificador de analista. Mismo unblock potencial que #2 — ver #14. |
| 6 | ¿La radicación devuelta termina aprobándose? | **bloqueada** | No existe `resultado_final` ni estado posterior a la devolución. |
| 7 | ¿El mix de motivos cambia en el tiempo? | **pendiente** | Hay un movimiento medido (documental 68% → 86% entre 2025-09 y 2026-03, `PERFILADO.md` §8) pero cae dentro del período de adopción del campo. No se puede separar cambio real de artefacto de captura. Ver `HIPOTESIS.md` H-02. Responder requiere que Ivan confirme cuándo se volvió obligatoria la tipificación. |

## v2 — agregadas 2026-08-12

Derivadas del perfilado. Ninguna corrida todavía.

| # | Pregunta | Por qué importa | Estado |
|---|---|---|---|
| 8 | ¿Qué explica que el 37,6% de las devoluciones no tenga ni tipificación ni comentario? ¿Se concentra en algún período, canal o tipo de caso? | Si el vacío es sistemático (p. ej. un flujo que no exige motivo), es una intervención de proceso barata e independiente del análisis de causas. Si es aleatorio, condiciona la representatividad de todo el Paso 02. | pendiente |
| 9 | ¿Cuánto tiempo de ciclo cuesta una devolución? (distribución del lag radicación→devolución por categoría) | El lag es el único costo medible con los datos actuales. p50 = 4,9 días, p90 = 14,1. Sin `resultado_final` no se puede medir costo de conversión, pero sí el de ciclo. | pendiente |
| 10 | Dentro de `Política documental` (83,5% del volumen), ¿qué documentos concretos fallan? | La tipificación actual es demasiado gruesa para accionar: "documental" no dice si falta el documento, es ilegible o está vencido — y esos tres tienen dueños distintos. | **respondida (parcial)** — ver abajo |

## Respuesta a #10 — 2026-08-13

Script: `02_clasificacion.py`. Validación: `03_validacion.py` / `VALIDACION.md`.
Salida: `documental_categorizado.xlsx`, columna `categorias_documentales`.

Sobre las 2.540 devoluciones de `Política documental` con comentario radicadas entre
2025-09 y 2026-07 (multi-etiqueta, denominador = esas 2.540):

| Categoría | Menciones | % | F1 holdout |
|---|---|---|---|
| Faltantes documentales del cliente | 1.444 | 56,9% | 0,87 |
| Errores en el diligenciamiento de formularios | 656 | 25,8% | 0,83 |
| Inconsistencia en la información | 293 | 11,5% | 0,67 |
| Documento vencido o desactualizado | 238 | 9,4% | 0,68 |
| Documentos ilegibles | 168 | 6,6% | 0,92 |
| Política o condiciones del crédito *(no documental)* | 478 | 18,8% | — |
| Trámite o gestión del caso *(no documental)* | 407 | 16,0% | — |
| Otros | 585 | 23,0% | 0,79 |

Parcial por tres razones: cubre el 38% de las filas de `Política documental` (el resto
no tiene comentario); dos categorías tienen F1 bajo 0,70; y la referencia de validación
la etiquetaron modelos, no Ivan.

**Categorías nuevas agregadas al ejecutar.** La consigna pedía un mínimo de tres
(faltantes, ilegibles, diligenciamiento) y agregar las recurrentes que aparecieran. Se
agregaron cuatro: `Documento vencido o desactualizado` e `Inconsistencia en la
información`, que sí son documentales, y `Trámite o gestión del caso` y `Política o
condiciones del crédito`, que **no lo son** y que juntas explican el 32,7% del
contenido de la tipificación (ver `RECOMENDACIONES.md`, Hallazgo 1).

### Reprocesado 2026-08-31 (Iteración 4, sobre `data_20260831.xlsx`)

Salida: `documental_categorizado_20260831.xlsx`. Cobertura sube de 3.692 a 8.157
comentarios clasificables (44,6% → 96,2% de "Política documental") por el salto de
`comentario_devolucion` descrito en la Iteración 3. **`Otros` como única categoría:
13,9% (1.132/8.157) — cruza el umbral de 12% de CLAUDE.md.** La taxonomía/reglas se
calibraron contra el texto viejo; el texto nuevo trae vocabulario no cubierto.
Pendiente antes de dar esta respuesta por buena: recalibrar reglas y re-correr
`03_validacion.py` sobre una muestra que incluya el texto nuevo (no se ha hecho).

### Recalibrado y validado 2026-08-31 (Iteración 5) — respuesta final de esta ronda

Taxonomía ampliada a 9 categorías (se agregó `Código o jerga interna del banco`).
`Otros` bajó a 10,8%, bajo el umbral. Validado contra 600 comentarios nuevos
(6 anotadores independientes, ver `VALIDACION.md`):

| Categoría | F1 holdout | ¿Usable para priorizar? |
|---|---|---|
| Faltantes documentales del cliente | 0,87 | Sí |
| Documento vencido o desactualizado | 0,75 | Con reserva (soporte bajo) |
| Documentos ilegibles | 0,71 | Sí |
| Errores en el diligenciamiento de formularios | 0,65 | Sí |
| Inconsistencia en la información | 0,64 | Con reserva (recall histórico bajo) |
| Política o condiciones del crédito | 0,58 | Solo como magnitud aproximada |
| Código o jerga interna del banco | 0,40 | No — soporte muy chico (4) |
| Otros | 0,34 | No es un target, es el residual — su tamaño (10,8%) es el dato que importa |
| Trámite o gestión del caso | 0,30 | **No — recall 0,24, se pierde 3 de cada 4 casos reales** |

**Respuesta final a #10 (esta ronda):** sobre las 8.157 devoluciones documentales
con comentario (96,2% del universo), la categoría dominante sigue siendo
`Faltantes documentales del cliente` (68,0% de menciones), seguida de
`Errores en el diligenciamiento` (33,3%) y `Política o condiciones del crédito`
(21,6% — no documental). Los números de estas tres son razonablemente confiables;
los de `Trámite` (13,1%) y `Código o jerga interna del banco` (0,7%) son un piso,
no el volumen real.

Pendiente para la próxima ronda: validar "Cliente no contactable" (#18, ver v5 abajo)
y mejorar el recall de `Trámite`.

## v5 — agregadas 2026-08-31 (Iteración 5)

| # | Pregunta | Por qué importa | Estado |
|---|---|---|---|
| 18 | ¿"Cliente no contactable" (el banco no logra comunicarse con el cliente para firma, referencia laboral o confirmación de datos) merece ser una categoría propia en vez de caer en `Trámite`? | 5 de 6 anotadores LLM independientes la sugirieron sin coordinarse, sin que se les pidiera. Señal fuerte de bootstrapping. Hoy estos casos inflan (o se pierden de) `Trámite`, que ya tiene el recall más bajo de la taxonomía (0,24). | pendiente — requiere re-etiquetar un lote con esta opción explícita antes de medir su F1 |
| 19 | ¿Por qué `Trámite o gestión del caso` tiene recall de solo 0,24 en la validación de la Iteración 5? ¿Las reglas léxicas actuales cubren mal el vocabulario, o es una categoría inherentemente más ambigua para un clasificador por reglas? | Es la categoría con peor desempeño de las 9. Su volumen reportado (13,1%) es casi con certeza un piso, no el real. | pendiente |

## v3 — agregadas 2026-08-13

| # | Pregunta | Por qué importa | Estado |
|---|---|---|---|
| 11 | ¿Por qué un tercio de lo tipificado como `Política documental` no describe una falla documental? ¿Es criterio del analista, falta de opción en el catálogo, o una definición de negocio que no conocemos? | Condiciona el tamaño real del problema documental y por lo tanto cualquier meta. Requiere confirmación de Ivan antes de actuar. | pendiente |
| 12 | Los 207 casos de "no hay solicitud en Mantiz" / "no está en buzón", ¿son fallas de integración con el banco o errores de radicación? | Tienen 21 días de mediana contra 3,5 del resto. La acción es distinta según la causa. | pendiente |
| 13 | ¿La cobertura del comentario (27%–51% según el mes) depende del tipo de caso? | Si el analista comenta más unos casos que otros, todo el desglose de #10 está sesgado. | **respondida (parcial)** — `04_sesgo_cobertura.py`. Faltantes (−0,04), ilegibles (+0,03) e inconsistencia (+0,02) no correlacionan con la cobertura mensual: su share es utilizable. Diligenciamiento (+0,33), no documental (+0,30) y vencido (−0,54) sí muestran relación. Parcial: n=11 meses. |

**Nota de proceso:** el bootstrapping manual de Ivan (Paso 02 de CLAUDE.md) sigue
pendiente. La taxonomía usada salió de minar el vocabulario real de los comentarios y
de seis anotadores LLM, no de su lectura. La muestra está lista en
`muestra_bootstrapping_200.csv`.

## v4 — agregadas 2026-08-31

Derivadas de reperfilar con el export nuevo (`data_20260831.xlsx`, hoja "Nuevos
datos" en Sheets). Ese export trajo, en una hoja adicional del archivo, el SQL real
que lo genera — ver `DICCIONARIO.md`. Ninguna corrida todavía.

| # | Pregunta | Por qué importa | Estado |
|---|---|---|---|
| 14 | ¿Se puede ampliar el query para seleccionar campos de `responsable_radicacion` (broker/analista responsable)? La tabla ya está joineada (`rr`) pero ningún campo suyo se selecciona. | Es el desbloqueo más directo de #2, #4 y #5 — tres de las siete preguntas pre-registradas. No requiere una tabla nueva, solo ampliar un SELECT existente. | pendiente — para Ivan / equipo de datos, no ejecutable desde este entorno (sin acceso a BigQuery aquí) |
| 15 | ¿Por qué 290 de 655 radicaciones (44,3%) de agosto de 2025 —mismos `radicacion_id`, verificado— tenían `tipificacion_devolucion` con valor en el pull del 12-ago-2026 y quedaron en NULL en el pull del 31-ago-2026? En los 290 casos el cambio va siempre de un valor a NULL, nunca al revés. | Si el campo puede vaciarse retroactivamente para un lote ya radicado, ningún perfilado de nulos es estable en el tiempo y compromete la comparabilidad mes a mes que pide el Paso 00 de CLAUDE.md. También pone en duda si las 8.275 filas usadas en `02_clasificacion.py` (Aug-12) siguen siendo las mismas filas que calificarían hoy como `Política documental`. | pendiente — bloquea confiar en cualquier corte de `tipificacion_devolucion` sin más contexto de Ivan |
| 16 | ¿`papyrus-master.liquidez_platinum_co.fct_radicacion` es la tabla que hay que poner en el bloque "Configuración del entorno" de CLAUDE.md? ¿Existe una vista o tabla hermana sin el filtro `WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL` que traiga el universo completo (devueltas y no devueltas) para poder calcular el denominador? | Sin esto, CLAUDE.md sigue con el bloque de configuración en TODO y la pregunta #1 (tasa) sigue bloqueada aunque ya se conozca el nombre de la tabla origen. | pendiente |
| 17 | De las 4.851 radicaciones que no tenían `comentario_devolucion` en el pull del 12-ago y sí lo tienen en el del 31-ago (22,9% del solapamiento, repartido en casi todos los meses — no es un evento de un solo mes como #15), ¿el dato se agregó al sistema origen después del 12-ago, o ya existía y el query viejo no lo traía? | Si es lo segundo, `02_clasificacion.py` y `03_validacion.py`, corridos sobre el pull de 12-ago, subestimaron la cobertura real desde el inicio (44,6% de comentario dentro de "documental" hubiera sido ~93%) y valdría la pena rerodar el Paso 02 sobre `data_20260831.xlsx` antes de fijar ninguna meta. Si es lo primero, el Paso 02 rerodado sería estrictamente mejor pero no invalida lo ya corrido. | pendiente — bloquea la decisión de rerodar Paso 02 |
