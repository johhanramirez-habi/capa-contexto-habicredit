# VALIDACION.md — Paso 03

Script: `03_validacion.py`. Clasificador evaluado: `02_clasificacion.py`.

## Cómo se construyó la referencia

600 comentarios de `tipificacion_devolucion = 'Política documental'`, muestreados al
azar (semilla 11) sobre las 3.693 filas que tienen texto. Se repartieron en 6 lotes de
100 y cada lote lo etiquetó un anotador LLM independiente, con la misma definición de
taxonomía y sin ver los demás lotes.

Los lotes 1 a 4 (400 comentarios) se usaron para ajustar el léxico. Los lotes 5 y 6
(200 comentarios) no se tocaron durante el ajuste y son el holdout. **Los números que
valen son los del holdout**; los de calibración están arriba del desempeño real
porque el léxico se afinó mirándolos.

## Resultados — holdout (200 comentarios, no usados para ajustar)

| Categoría | Soporte | Precisión | Recall | F1 |
|---|---|---|---|---|
| Faltantes documentales del cliente | 109 | 0,83 | 0,91 | **0,87** |
| Documentos ilegibles | 19 | 0,94 | 0,89 | **0,92** |
| Errores en el diligenciamiento de formularios | 39 | 0,79 | 0,87 | **0,83** |
| Otros (incluye trámite y política) | 94 | 0,71 | 0,89 | **0,79** |
| Documento vencido o desactualizado | 20 | 0,72 | 0,65 | **0,68** |
| Inconsistencia en la información | 23 | 0,81 | 0,57 | **0,67** |

Coincidencia exacta de la categoría primaria: 68,5%.
Comentarios con al menos una categoría en común con la referencia: 92,0%.

## Resultados — calibración (400 comentarios, usados para ajustar)

| Categoría | Soporte | Precisión | Recall | F1 |
|---|---|---|---|---|
| Faltantes documentales del cliente | 219 | 0,80 | 0,87 | 0,84 |
| Documentos ilegibles | 28 | 0,91 | 0,75 | 0,82 |
| Errores en el diligenciamiento de formularios | 96 | 0,73 | 0,86 | 0,79 |
| Inconsistencia en la información | 66 | 0,80 | 0,74 | 0,77 |
| Otros | 197 | 0,73 | 0,77 | 0,75 |
| Documento vencido o desactualizado | 63 | 0,77 | 0,70 | 0,73 |

## Lectura

Las tres categorías que concentran el volumen — faltantes, diligenciamiento e
ilegibles — están entre 0,83 y 0,92 de F1 en holdout. Son utilizables para
dimensionar y priorizar.

**Dos categorías no lo son todavía:**

- `Inconsistencia en la información`, recall 0,57: el clasificador se pierde una de
  cada tres. Su volumen real es mayor que el 11,3% que reporta `02_clasificacion.py`.
- `Documento vencido o desactualizado`, F1 0,68 y precisión que oscila entre 0,72 y
  0,77 según el corte. El volumen que reporta puede estar inflado.

Ninguna de las dos debería usarse para fijar una meta sin revisarse antes a mano.

## Recalibración 2026-08-31 (Iteración 5, BITACORA.md)

Motivo: el export nuevo (`data_20260831.xlsx`) trajo comentario en 4.056 filas de
`Política documental` que antes no lo tenían (ver `DICCIONARIO.md`). Al clasificarlas
con las reglas viejas, "Otros" como única categoría subió a 13,9% — por encima del
12% que fija CLAUDE.md como señal de taxonomía incompleta. A pedido explícito de
Johhan se recalibró la taxonomía (más categorías si hacía falta) y se corrió de
nuevo la validación.

**Qué cambió en la taxonomía:**

- Se agregó `Código o jerga interna del banco (sin narrativa)`: comentarios que son
  código/nota interna pegada tal cual (SOI, BPP, SARLAFT, CIFIN, códigos "NNN.N",
  iniciales de analista) sin una frase que explique la causa. Salió de leer una
  muestra de 45+40 comentarios "solo Otros" (truncados, sin exponer más de 50 filas
  crudas a la vez, regla 3 de CLAUDE.md) — apareció en ~15% de la primera lectura.
- Se ampliaron las reglas de `Trámite o gestión del caso` (doble radicado, canal de
  referidos, zona/ciudad incorrecta, cliente ya gestionado por otro asesor/entidad),
  `Política o condiciones del crédito` (PEP, "incumple políticas", "condiciones de
  producto", "no procede", reporte en bases internas) y `Faltantes documentales del
  cliente` (formas conjugadas de "adjuntar/anexar/aportar" que las reglas viejas no
  cubrían — solo tenían el infinitivo — y "completitud"/"documentación incompleta").
- Se corrigió un bug de diseño: `Otros` y `Código o jerga interna del banco` se
  aplicaban como co-etiqueta cada vez que su palabra gatillo aparecía, **incluso en
  comentarios que ya tenían una causa real y clara**. La primera corrida de
  validación contra el set nuevo mostró 6-15% de precisión para ambas por esto
  exacto. Se cambió para que solo se reporten cuando NINGUNA causa real coincidió
  (ver `02_clasificacion.py`, función `clasificar`).

**Cómo se construyó la segunda referencia:** 600 comentarios nuevos (semilla
2026-08-31, estratificados por mes, sobre el pool de 8.158 comentarios clasificables
en `data_20260831.xlsx`), 6 lotes de 100 etiquetados por 6 anotadores LLM
independientes (agentes separados, sin ver los lotes de los demás), con la
taxonomía ampliada. Archivos `_labels_new_1.json` … `_labels_new_6.json`. Lotes 1-4
= calibración, 5-6 = holdout. Misma limitación de siempre: no los etiquetó Ivan.

**Chequeo de regresión (set viejo, `_labels_1..6.json`, sin recalibrar el texto):**
los F1 de holdout se mantienen prácticamente iguales (Faltantes 0,87, Ilegibles
0,89 vs. 0,92, Diligenciamiento 0,80 vs. 0,83, Vencido 0,68, Inconsistencia 0,65
vs. 0,67, Otros 0,82 vs. 0,79). La recalibración no rompió lo que ya funcionaba.

**Resultados — holdout nuevo (200 comentarios, taxonomía completa):**

| Categoría | Soporte | Precisión | Recall | F1 |
|---|---|---|---|---|
| Faltantes documentales del cliente | 115 | 0,81 | 0,93 | **0,87** |
| Documento vencido o desactualizado | 12 | 0,60 | 1,00 | **0,75** |
| Documentos ilegibles | 14 | 0,71 | 0,71 | **0,71** |
| Errores en el diligenciamiento de formularios | 39 | 0,52 | 0,87 | **0,65** |
| Inconsistencia en la información | 29 | 0,63 | 0,66 | **0,64** |
| Política o condiciones del crédito | 36 | 0,51 | 0,67 | **0,58** |
| Código o jerga interna del banco | 4 | 1,00 | 0,25 | **0,40** |
| Otros | 6 | 0,21 | 1,00 | **0,34** |
| Trámite o gestión del caso | 34 | 0,40 | 0,24 | **0,30** |

Coincidencia exacta de categoría primaria: 58,5% (vs. 66-68% del set viejo — la
comparación no es directa: el set nuevo tiene 9 categorías contra 6, así que un
exact-match más bajo es mecánico, no necesariamente peor clasificación).

**Lectura:**

- `Faltantes`, `Vencido`, `Ilegible`, `Diligenciamiento` e `Inconsistencia` quedan
  en el mismo rango que antes (0,64-0,87): utilizables para dimensionar, con las
  mismas reservas de siempre en Vencido/Inconsistencia.
- `Política o condiciones del crédito` (F1 0,58) es utilizable para tener una
  primera magnitud pero no para fijar una meta fina.
- **`Trámite o gestión del caso` (F1 0,30) y `Código o jerga interna del banco`
  (F1 0,40, soporte de solo 4) no son confiables todavía.** Trámite en particular
  tiene recall de 0,24: el clasificador se pierde tres de cada cuatro casos reales.
  `Otros` (F1 0,34, soporte 6) tiene una base tan chica que el número no es
  informativo por sí solo, más allá de confirmar que ya no es 13,9% del volumen.
- Ninguna de las tres categorías nuevas debería usarse para priorizar sin revisión
  manual — exactamente la misma regla que ya aplicaba a Vencido/Inconsistencia en
  la Iteración 2.

**Candidata de taxonomía NO incorporada:** "Cliente no contactable" (banco no logra
comunicarse con el cliente para firma, referencia laboral o confirmación de datos).
La sugirieron, sin coordinarse entre sí, 5 de los 6 anotadores. No se agregó a esta
ronda porque los anotadores etiquetaron con la taxonomía vieja (sin esa opción) y
metricarla ahora ensuciaría esta validación; queda para la Iteración 6, con un
re-etiquetado que sí la incluya como opción.

## Limitaciones que hay que resolver antes de dar esto por bueno

1. **La referencia no la etiquetó Ivan.** CLAUDE.md pide 150 casos etiquetados a mano
   por él, distintos de los 200 del bootstrapping. Lo que mide esta tabla es acuerdo
   entre un léxico y otro modelo, no acuerdo con la verdad de negocio. Si el criterio
   de los anotadores está sesgado, el léxico heredó el sesgo y la tabla no lo muestra.
2. **El sesgo típico que advierte CLAUDE.md sí aparece.** Los seis anotadores
   sobre-asignaron a la categoría más genérica: `Otros` quedó como única etiqueta en
   el 26,5% de la calibración y el 35,5% del holdout, muy por encima del umbral del
   12%. Eso no se debe a una taxonomía documental incompleta sino a que una parte
   grande de lo tipificado como documental no es documental (ver `RECOMENDACIONES.md`).
3. **La cobertura no es el universo.** Solo 3.692 de 8.275 filas de `Política
   documental` tienen comentario (44,6%). Todo lo de arriba describe esa mitad. Si el
   comentario se llena más en unos casos que en otros, el desglose está sesgado y no
   hay forma de detectarlo con este archivo.
4. Método léxico, no LLM en línea: el entorno no tiene credenciales de API. Un
   clasificador LLM sobre las 3.692 filas probablemente suba el recall de
   `Inconsistencia`, que es la categoría que más depende de entender la frase.
