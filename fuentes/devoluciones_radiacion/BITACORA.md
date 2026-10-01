# BITACORA.md

## Iteración 5 — 2026-08-31 (misma sesión que las Iteraciones 3 y 4)

**Preguntas atacadas:** #10, cerrando el pendiente que dejó la Iteración 4 (Otros
por encima del umbral de 12%). A pedido explícito de Johhan: "recalibra la
taxonomía... si es necesario redefinir las categorías... y corre la validación".

**Resultado:**

- Taxonomía: se agregó `Código o jerga interna del banco (sin narrativa)` y se
  ampliaron las reglas de `Trámite`, `Política` y `Faltantes` (detalle completo y
  justificación en `VALIDACION.md`). Fuente de la recalibración: lectura truncada
  de 85 comentarios "solo Otros" (dos muestras de 45 y 40, ≤50 filas crudas cada
  vez, regla 3 de CLAUDE.md) más frecuencia de palabras agregada sobre las 1.132
  filas del bucket.
- `Otros` como única categoría: 13,9% → 10,8% (8.157 comentarios), bajo el umbral
  de 12%.
- Se encontró y corrigió un bug de diseño: `Otros` y el nuevo `Código o jerga
  interna del banco` se aplicaban como co-etiqueta con solo que su palabra gatillo
  apareciera, sin importar si el comentario ya tenía una causa real. Eso les daba
  6-15% de precisión en la primera validación. Corregido para que solo se reporten
  cuando ninguna causa real coincidió; con eso, `Código o jerga interna del banco`
  subió a 100% de precisión (recall bajo, 0,25) y `Otros` a 21% de precisión en
  holdout.
- Segunda referencia construida: 600 comentarios nuevos, 6 anotadores LLM
  independientes (agentes separados en paralelo), taxonomía ampliada. F1 en
  holdout: Faltantes 0,87, Vencido 0,75, Ilegible 0,71, Diligenciamiento 0,65,
  Inconsistencia 0,64, Política 0,58, Código interno 0,40, Otros 0,34, **Trámite
  0,30 (recall 0,24 — no confiable)**.
- Chequeo de regresión contra el set de referencia viejo (Iteración 2): los F1 se
  mantienen dentro de ±0,03 de los originales. La recalibración no rompió lo que
  ya funcionaba sobre texto viejo.
- 5 de 6 anotadores, sin coordinarse, sugirieron por su cuenta una categoría no
  pedida: "Cliente no contactable" (el banco no logra comunicarse con el cliente
  para firma/referencia laboral/confirmación de datos). No se incorporó a esta
  ronda — ver "Qué NO se puede concluir".

**Qué cambia en el entendimiento:**

Con la taxonomía ampliada y el bug de co-etiquetado corregido, el desglose de
`Política documental` es utilizable en 5 de 8 categorías (Faltantes, Vencido,
Ilegible, Diligenciamiento, Inconsistencia — F1 0,64-0,87) sobre una cobertura de
96,2% del universo, no ya el 44,6% parcial de la Iteración 2. `Política o
condiciones del crédito` es utilizable como magnitud aproximada (F1 0,58). Dos
categorías nuevas (`Trámite`, `Código o jerga interna del banco`) están medidas
pero no son todavía confiables para priorizar — igual que ya pasaba con Vencido e
Inconsistencia desde la Iteración 2.

**Qué NO se puede concluir:**

- Que `Trámite o gestión del caso` mida bien su volumen real: con recall 0,24 el
  clasificador se pierde 3 de cada 4 casos reales según la referencia. El 13,1% de
  cobertura que reporta `02_clasificacion.py` es un piso, no el número real.
- Que "Cliente no contactable" no sea una categoría necesaria: la evidencia de que
  sí lo es (5/6 anotadores independientes) es fuerte, pero no se puede medir su F1
  en esta ronda porque la referencia se etiquetó sin esa opción disponible.
  Mezclarla ahora hubiera invalidado la comparación de regresión contra el set
  viejo.
- Que la referencia represente la verdad de negocio: sigue siendo acuerdo entre
  modelos, no las 150 etiquetas de Ivan que pide CLAUDE.md — ahora con el problema
  agravado porque son 9 categorías, no 6, y más superficie para que los anotadores
  discrepen entre sí sin que se note en el agregado.
- Nada nuevo sobre tasa, broker, ni las preguntas bloqueadas de la Iteración 3.

**Supuestos nuevos que hubo que hacer** (necesitan confirmación de Ivan):

1. Que las definiciones de categoría que se les dieron a los 6 anotadores (texto
   plano, sin ver las reglas de regex) son una interpretación razonable de lo que
   el negocio querría ver separado. Son mi redacción, no la de Ivan.
2. Que remover `Otros`/`Código interno` como co-etiqueta (en vez de solo como
   categoría primaria) es la lectura correcta de "sin narrativa" — implica que un
   comentario con causa real ya no se marca como tocando también temas de banco
   interno, aunque los mencione.
3. Que 600 comentarios (100 por anotador) es suficiente para medir 9 categorías;
   con esa base, las tres categorías nuevas tienen soporte de apenas 4-36 casos en
   el holdout — estimaciones ruidosas.

**Siguiente iteración:**

1. Re-etiquetar un lote nuevo con "Cliente no contactable" como opción explícita
   para medir su F1 antes de agregarla al clasificador en serio.
2. Extender las reglas de `Trámite o gestión del caso` — es la prioridad, dado el
   recall de 0,24 — y volver a validar solo esa categoría contra el holdout
   existente antes de tocar nada más.
3. Sigue en pie todo lo de la Iteración 3 (preguntas #14 a #17) y el pendiente de
   siempre: que Ivan etiquete a mano los 150 casos de validación que pide
   CLAUDE.md, ahora sobre la taxonomía de 9 categorías.

**Verificación manual pendiente:** sin cambios, no ejecutable todavía (no hay tasa
ni broker).

---

## Iteración 4 — 2026-08-31 (misma sesión que la Iteración 3)

**Preguntas atacadas:** #10 (reprocesada), a pedido explícito de Johhan de ver un
Excel con la nueva tipificación por radicación, como en la Iteración 2.

**Resultado:**

- Script: `02_clasificacion.py`, adaptado a `data_20260831.xlsx`. Salida:
  `documental_categorizado_20260831.xlsx` (misma estructura que el de la
  Iteración 2: `categorias_documentales`, `categoria_primaria`, `n_categorias`).
- 8.481 filas `Política documental` (vs. 8.275 en el pull viejo). 8.157 con
  comentario clasificable (96,2%) vs. 3.692 (44,6%) en la Iteración 2 — confirma en
  este paso el salto de cobertura que se vio en el perfilado (Iteración 3).
- Cobertura por categoría (sobre 8.157): Faltantes 64,3%, Diligenciamiento 33,3%,
  Política/condiciones 20,5%, Otros 20,7%, Inconsistencia 15,3%, Trámite 12,0%,
  Vencido 11,3%, Ilegible 7,6%. Promedio 1,85 categorías por comentario.
- **`Otros` como única categoría: 13,9% (1.132/8.157) — por encima del umbral de
  12% que fija CLAUDE.md.** La regla es explícita: si pasa de 12%, la taxonomía
  está incompleta y se corrige la taxonomía, no se fuerza el modelo.

**Qué cambia en el entendimiento:**

Con 4,4 veces más comentarios clasificables, el desglose de "Política documental"
deja de ser una muestra parcial (38% del universo en la Iteración 2) y pasa a
cubrir casi todo (96%). Pero el vocabulario nuevo que trajo el export de 31-ago no
está bien cubierto por las reglas léxicas calibradas en la Iteración 2: por eso
"Otros" sube y cruza el umbral. Esto no es evidencia de que el problema documental
cambió — es evidencia de que las reglas necesitan recalibrarse contra el texto
nuevo.

**Qué NO se puede concluir:**

- Que las proporciones por categoría de esta corrida sean tan confiables como las
  de la Iteración 2: la accuracy por categoría en `VALIDACION.md` se midió sobre
  los 3.692 comentarios viejos, no sobre los 4.056 nuevos que ahora entran a la
  base. `03_validacion.py` no se ha vuelto a correr.
- Que 13,9% de "Otros" sea el techo real: podría bajar si se amplían las reglas
  con el vocabulario nuevo, o podría confirmar que sí hace falta una categoría que
  no existe todavía.
- Nada sobre por qué el vocabulario cambió (ver Iteración 3, preguntas #15/#17):
  si el comentario nuevo viene de una fuente distinta del sistema origen, es
  esperable que tenga un estilo de redacción distinto al que calibró las reglas.

**Supuestos nuevos que hubo que hacer** (necesitan confirmación de Ivan):

1. Que reprocesar con reglas sin recalibrar, solo para tener cobertura, es
   preferible a esperar la recalibración. Se hizo porque Johhan lo pidió
   explícitamente, no por criterio propio.
2. Que comparar `documental_categorizado_20260831.xlsx` contra el de la
   Iteración 2 fila por fila (mismos `radicacion_id`) sería el primer chequeo de
   cuánto cambia la categoría primaria de una misma radicación al aparecer su
   comentario — no se hizo en esta iteración, queda para la siguiente.

**Siguiente iteración:**

1. Leer una muestra de los 1.132 casos "solo Otros" (nunca filas crudas completas,
   máximo 50 truncadas) para decidir si falta una categoría o si son casos
   genuinamente atípicos.
2. Recalibrar o extender `REGLAS` en `02_clasificacion.py` contra el vocabulario
   de los 4.056 comentarios nuevos, y solo entonces volver a correr
   `03_validacion.py` sobre una muestra que incluya ese texto nuevo.
3. Sigue en pie todo lo de la Iteración 3 (preguntas #14 a #17).

---

## Iteración 3 — 2026-08-31

**Preguntas atacadas:** ninguna de `PREGUNTAS.md` se responde en esta iteración.
Se rehace el Paso 00 (perfilado) del pipeline con un dataset nuevo que Johhan
compartió (Google Sheet "Nuevos datos"), a pedido explícito de repetir el proceso
de extracción con esa fuente.

**Resultado:**

- Fuente nueva: `data_20260831.xlsx` (hoja `Extracto 1` del Sheet), mismo query que
  generó `data.xlsx` pero con corte 2026-08-31 en vez de 2026-08-12. 21.732 filas
  (+512 respecto al corte anterior, 1 `radicacion_id` desapareció). `data.xlsx`
  queda archivado, no se borra.
- **Se descubrió el SQL real del export** en una segunda hoja del Sheet
  ("Hoja vinculada 1"), algo que no existía documentado antes. Fuente:
  `papyrus-master.liquidez_platinum_co.fct_radicacion`, con joins a
  `ans_radicacion_co`, `responsable_radicacion` y `pipe_radicacion_co` (las tres en
  `papyrus-delivery-data.habicredit`). Detalle completo en `DICCIONARIO.md`.
- El query trae `LEFT JOIN responsable_radicacion` pero no selecciona ninguna
  columna de esa tabla — por nombre, es la candidata a tener broker/analista
  responsable. No se puede ampliar el SELECT desde este entorno (sin acceso a
  BigQuery aquí); queda como pedido para Ivan / equipo de datos.
- El query trae `WHERE inicio_subproceso_devuelto_por_banco IS NOT NULL`: confirma
  que el recorte a "solo devueltas" es una decisión explícita del query, no un
  límite del origen. El bloqueo de la tasa (pregunta #1) sigue en pie.
- **Perfilado mecánico encontró dos saltos de comparabilidad entre los dos pulls,
  verificados a nivel de fila (mismo `radicacion_id` en ambos):**
  1. `tipificacion_devolucion`: 362 filas cambiaron de valor; 344 pasaron a NULL y
     solo 2 ganaron un valor. Concentrado en un mes: 290 de 655 radicaciones de
     2025-08 (44,3%) perdieron su tipificación entre el 12-ago y el 31-ago.
  2. `comentario_devolucion`: 4.851 de 21.220 filas (22,9%) no tenían comentario el
     12-ago y sí lo tienen el 31-ago; solo 32 perdieron el que tenían. A diferencia
     del anterior, está repartido en casi todos los meses, no concentrado en uno.
     Dentro de lo tipificado como `Política documental` en el pull viejo, la
     cobertura de comentario pasaría de 44,6% a ~93% si se reprocesa con la fuente
     nueva.
- La composición ya cerrada (ventana 2025-09..2026-07, pregunta #3/#7) no se mueve
  de forma material entre pulls (Política documental 83,5% → 83,6%), pese a lo
  anterior. El lag radicación→devolución tampoco (p90 14,09 → 14,06 días).

**Qué cambia en el entendimiento:**

Conocer el SQL de origen es un avance real: da nombre a la tabla que hay que poner
en el bloque de configuración de CLAUDE.md y muestra que el desbloqueo de
broker/analista (preguntas #2, #4, #5) puede ser tan simple como ampliar un SELECT,
no conseguir una tabla nueva. Pero el hallazgo más importante de esta iteración es
que **los pulls de esta fuente no son estables en el tiempo para las mismas filas
históricas** — ni `tipificacion_devolucion` ni `comentario_devolucion` son
apend-only. Eso significa que cualquier número de un perfilado anterior (incluida
la Iteración 1) es una fotografía de ese momento, no un hecho fijo, y que el
trabajo de clasificación ya hecho (Iteración 2) probablemente subestima la
cobertura real de comentario dentro de "Política documental".

**Qué NO se puede concluir:**

- Nada nuevo sobre tasa: sigue sin denominador, ahora confirmado que es una
  decisión del query (`WHERE ... IS NOT NULL`) y no una limitación de origen.
- Que el salto de `comentario_devolucion` sea una mejora real de captura y no un
  cambio de query que ya existía pero no se había documentado: no hay forma de
  saberlo sin el SQL del export de 12-ago, que no quedó registrado.
- Que las 8.275 filas de `Política documental` clasificadas en la Iteración 2 sigan
  siendo exactamente las mismas hoy: 238 de ellas ya no tienen esa tipificación en
  el pull nuevo.
- Nada sobre si `responsable_radicacion` efectivamente contiene broker/KAM/director
  comercial — es una inferencia por nombre de tabla, no confirmada.

**Supuestos nuevos que hubo que hacer** (cada uno necesita confirmación de Ivan):

1. Que `data_20260831.xlsx` (hoja `Extracto 1`) es comparable en grano y semántica a
   `data.xlsx`, más allá de la limpieza del nombre de columna
   (`comentario_devoluci_n` → `comentario_devolucion`).
2. Que el 1 `radicacion_id` que estaba en el pull de 12-ago y no aparece en el de
   31-ago no es una radicación real que se haya borrado o reasignado.
3. Que `papyrus-master.liquidez_platinum_co.fct_radicacion` es efectivamente "la
   tabla origen" de CLAUDE.md y no una vista intermedia ya filtrada.

**Siguiente iteración:**

1. Bloqueante nuevo, más urgente que conseguir la tabla completa: preguntas #15 y
   #17 de `PREGUNTAS.md` — entender por qué `tipificacion_devolucion` y
   `comentario_devolucion` cambian retroactivamente para radicaciones ya
   registradas. Sin esa respuesta, no está claro si vale la pena rerodar el
   Paso 02 sobre `data_20260831.xlsx` o si hay que esperar a que la fuente se
   estabilice.
2. Pedir a Ivan / equipo de datos que evalúen ampliar el SELECT del query para
   traer columnas de `responsable_radicacion` (#14) — es el camino más corto a
   desbloquear 3 de las 7 preguntas pre-registradas.
3. Sigue pendiente, sin cambios: la tabla completa de radicaciones (devueltas y no
   devueltas) para el denominador (#1, #16), y que Ivan confirme la taxonomía y
   etiquete los 150 casos de validación del Paso 03.
4. Si Ivan confirma que #17 va en la dirección de "el dato ya existía", replantear
   si rerodar `01_tabla_base.py` → `02_clasificacion.py` → `03_validacion.py`
   completos sobre `data_20260831.xlsx` antes de seguir agregando preguntas nuevas.

**Verificación manual pendiente:** sigue sin ser ejecutable (no hay tasa ni
broker). Lo verificable en esta iteración: 21.732 devoluciones totales en el pull
de 31-ago, 512 más que el de 12-ago; 7.879 tipificadas en la ventana
2025-09..2026-07 (vs. 7.905 antes — la diferencia cae dentro del ruido de §
`tipificacion_devolucion` de esta misma iteración, no es un cambio de fondo).

---

## Iteración 2 — 2026-08-13

**Preguntas atacadas:** #10 (desglose de `Política documental`). Pasos 01, 02 y 03 del
pipeline. Pedido adicional: análisis y recomendaciones.

**Resultado:**

- `01_tabla_base.py`: tabla base anclada en `fecha_de_radicado`, cohorte semanal,
  censura a 14 días (p90 del lag). 21.218 filas, 263 censuradas, 20.955 vigentes,
  cohortes válidas hasta 2026-07-29. **Sin tasa**: falta el denominador. El script la
  calcula solo si aparece `radicaciones_totales.csv` (cohorte_semana, radicaciones).
- `02_clasificacion.py`: clasificador multi-etiqueta sobre `comentario_devoluci_n` para
  las 8.275 filas de `Política documental`. 3.692 tienen comentario clasificable,
  4.583 no. Columna nueva `categorias_documentales` (lista JSON) y `categoria_primaria`.
  Promedio de 1,69 categorías por comentario.
- Taxonomía final: 5 categorías documentales (faltantes, diligenciamiento,
  inconsistencia, vencido, ilegible) + 2 no documentales que emergieron del texto
  (trámite/gestión, política/condiciones) + `Otros`.
- `03_validacion.py`: 600 comentarios etiquetados por 6 anotadores LLM independientes,
  400 para calibrar y 200 de holdout. F1 en holdout: faltantes 0,87, ilegibles 0,92,
  diligenciamiento 0,83, Otros 0,79, vencido 0,68, inconsistencia 0,67. Coincidencia de
  categoría primaria 68,5%.
- Composición en ventana 2025-09..2026-07, sobre 2.540 devoluciones documentales con
  comentario: faltantes 1.444 (56,9%), diligenciamiento 656 (25,8%), política 478
  (18,8%), trámite 407 (16,0%), inconsistencia 293 (11,5%), vencido 238 (9,4%),
  ilegible 168 (6,6%), Otros 585 (23,0%).
- 830 de 2.540 (32,7%) no mencionan ninguna causa documental.
- Mediana de días a la devolución por categoría: trámite 9,2; el resto entre 3,0 y 4,2.
- 207 casos ("no hay solicitud en Mantiz" 115, "no está en buzón" 92) tienen mediana de
  21 días y acumulan 4.924 días de ciclo.
- Total de días de ciclo consumidos por devoluciones documentales en la ventana: 37.836.

**Qué cambia en el entendimiento:**

La tipificación `Política documental` no significa lo que su nombre dice: casi un
tercio de su contenido son problemas de trámite del caso o de política de crédito. Eso
mueve el problema de sitio — parte de lo que se venía leyendo como disciplina
documental de los brokers es en realidad integración con el banco y criterio de
crédito. Dentro de lo que sí es documental, la concentración en faltantes (56,9%) es
lo bastante fuerte y estable como para tratarla como un solo frente de trabajo.

**Qué NO se puede concluir:**

- Nada sobre tasa ni sobre si esto mejora o empeora. Sigue faltando el denominador.
- Que el desglose represente al universo: describe el 38% de `Política documental`, la
  parte que tiene comentario, y la cobertura del comentario varía entre 27% y 51% según
  el mes sin patrón conocido.
- Que los volúmenes de `Inconsistencia` (recall 0,57) y `Documento vencido` (F1 0,68)
  sean correctos. El primero está subestimado y el segundo posiblemente inflado.
- Que la taxonomía sea la correcta desde el negocio: la validó otro modelo, no Ivan.
- Nada sobre a quién atribuir las causas. Sin `broker_id` no se sabe si los faltantes
  se concentran en pocos brokers o son transversales, que es lo que decide entre
  coaching y rediseño de proceso.

**Supuestos nuevos que hubo que hacer** (cada uno necesita confirmación de Ivan):

1. Que "faltantes documentales del cliente" incluye lo que no adjuntó el broker. El
   texto rara vez distingue quién debía aportar el documento; el eje "dónde se originó"
   de CLAUDE.md no es reconstruible desde este texto.
2. Que `Trámite o gestión del caso` y `Política o condiciones del crédito` merecen ser
   categorías y no pertenecen a lo documental. Es una lectura del texto, no una regla
   de negocio conocida.
3. Que un comentario que pide adjuntar un documento implica que faltaba. Es la lectura
   natural, pero podría ser un documento que sí estaba y fue rechazado.
4. Que la ventana 2025-09..2026-07 sigue siendo la comparable.
5. Que los comentarios enlatados repetidos (55 idénticos en un caso) son eventos
   distintos y no duplicados de registro.

**Siguiente iteración:**

1. Sigue bloqueando todo lo mismo: la tabla completa de radicaciones con `broker_id`,
   `director_comercial`, `kam` y `resultado_final`. Para la tasa basta un agregado
   semanal, sin datos de cliente.
2. Que Ivan lea `muestra_bootstrapping_200.csv` y confirme o corrija la taxonomía, y
   etiquete los 150 casos de validación que pide CLAUDE.md.
3. Preguntas nuevas #11, #12, #13 en `PREGUNTAS.md`.
4. Llenar las columnas de prevenibilidad y costo en la tabla de `RECOMENDACIONES.md`,
   que son juicio de negocio y no salen de los datos.

---

## Iteración 1 — 2026-08-12

**Preguntas atacadas:** #3, #7 (parcialmente). Paso 00 del pipeline completo.

**Resultado:**

- Fuente perfilada: `data.xlsx`, hoja `results-20260812-131749`. 21.221 filas,
  5 columnas, `radicacion_id` único sin duplicados.
- 21.221 / 21.221 filas tienen `fecha_devolucion` poblada. El export contiene solo
  radicaciones devueltas.
- Columnas presentes: `radicacion_id`, `fecha_de_radicado`, `fecha_devolucion`,
  `comentario_devoluci_n`, `tipificacion_devolucion`. No hay broker, director
  comercial, KAM, analista ni resultado final.
- Cobertura de motivo: 7.977 / 21.221 filas (37,6%) sin tipificación ni comentario.
  4.738 (22,3%) tienen ambos.
- `tipificacion_devolucion`: ~100% nula hasta 2024-10, 3,1% nula en 2025-09.
- Lag radicación→devolución: p50 = 4,86 días, p90 = 14,09, p99 = 39,81.
- P3 (composición, 7.905 devoluciones tipificadas radicadas 2025-09..2026-07):
  Política documental 6.598 / 7.905 = 83,5%; Politica interna del banco 775 = 9,8%;
  Criterios mínimos de aceptación 426 = 5,4%; Política score o mora 56 = 0,7%;
  Política de edad más plazo 50 = 0,6%.

**Qué cambia en el entendimiento:**

La fuente disponible no permite calcular ninguna tasa de devolución, porque no
contiene radicaciones no devueltas — solo permite describir la composición de las
devoluciones. Cuatro de las siete preguntas pre-registradas (#2, #4, #5, #6) no
dependen de análisis sino de conseguir columnas que el export no tiene. Sobre lo que
sí se puede medir, el volumen está fuertemente concentrado en una sola tipificación
(documental, 83,5%), pero esa categoría es demasiado gruesa para accionar sobre ella.

**Qué NO se puede concluir:**

- Nada sobre tasa, tendencia de tasa, ni comparación entre brokers/analistas: falta
  el denominador y faltan las dimensiones. El conteo mensual de devoluciones se mueve
  con el volumen de radicación, que no se observa.
- Que las devoluciones documentales estén creciendo: el corrimiento del mix cae dentro
  del período de adopción del campo (`HIPOTESIS.md` H-02).
- Nada sobre el 37,6% de devoluciones sin campo de motivo, ni si ese vacío es
  aleatorio. Si es sistemático, todo el Paso 02 se calcula sobre una submuestra sesgada.
- Nada anterior a 2025-09 en términos de tipificación.
- Que "documental" signifique documento faltante: el catálogo no lo distingue de
  ilegible, vencido o inconsistente.

**Supuestos nuevos que hubo que hacer** (cada uno necesita confirmación de Ivan):

1. Que `fecha_de_radicado` es el equivalente de `fecha_radicacion` de CLAUDE.md y sirve
   para cohortar.
2. Que la ventana 2025-09..2026-07 es la comparable para tipificación. Es una decisión
   derivada del corte de nulos, no un criterio de negocio.
3. Que 2026-08 se excluye por mes parcial (corte 2026-08-12).
4. Que los comentarios de 1–3 palabras (115 filas, 1,5%) no se descartan todavía.
5. Que este export es la fuente correcta. Es posible que sea un recorte de una tabla
   más completa; la configuración de BigQuery de CLAUDE.md sigue en TODO.

**Siguiente iteración:**

Bloqueada hasta que Ivan responda. En orden de impacto:

1. **Conseguir la tabla de radicaciones completa** (devueltas y no devueltas), con
   `broker_id`, `director_comercial`, `kam` y, si existe, `resultado_final`. Sin esto
   el Paso 01 no se puede construir y el análisis no pasa de descriptivo. Es el
   bloqueo número uno.
2. Completar el bloque `Configuración del entorno` de CLAUDE.md (proyecto, dataset,
   tabla) para trabajar contra BigQuery y no contra un export.
3. Responder las 8 preguntas de semántica de `DICCIONARIO.md`, en particular el grano
   (¿una fila por radicación o por devolución?) y qué significa la tipificación nula.
4. Leer la muestra de bootstrapping (`muestra_bootstrapping_200.csv`, 201 motivos
   estratificados por mes) y de ahí derivar la taxonomía del Paso 02.
5. Preguntas nuevas #8, #9, #10 registradas en `PREGUNTAS.md`.

**Verificación manual pendiente:** el chequeo que exige CLAUDE.md (Ivan recalcula a
mano la tasa global y la de un broker) no es ejecutable todavía — no hay tasa ni
broker. Lo verificable hoy es el conteo: 21.221 devoluciones totales, 7.905
tipificadas en la ventana 2025-09..2026-07.
