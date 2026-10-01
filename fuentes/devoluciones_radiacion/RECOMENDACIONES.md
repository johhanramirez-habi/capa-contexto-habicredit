# RECOMENDACIONES.md

Fecha: 2026-08-13. Fuentes: `02_clasificacion.py`, `03_validacion.py`, `00_perfilado.py`.
Ventana de análisis: radicaciones de 2025-09 a 2026-07 (la comparable, ver `PERFILADO.md` §3).

## Antes de leer: el alcance real de esto

Todo lo que sigue describe **la composición de las devoluciones**, no la tasa de
devolución. El archivo disponible solo contiene radicaciones devueltas, así que no hay
denominador. Se puede decir "de cada 100 devoluciones documentales, 57 mencionan un
documento faltante"; no se puede decir "el X% de las radicaciones se devuelve por
documento faltante", ni si eso está mejorando.

Además, el desglose se calcula sobre las 2.540 devoluciones documentales de la ventana
que tienen comentario, de un total de 6.597. **Describe el 38% del universo.**
Extrapolar al 62% restante es un supuesto, no un dato.

Las recomendaciones están priorizadas por volumen, que es el único de los tres ejes de
CLAUDE.md que sale de los datos. Prevenibilidad y costo de intervención son juicio de
negocio y quedan en blanco para que los llene Ivan con operación.

---

## Hallazgo 1 — Una de cada tres devoluciones tipificadas como "Política documental" no es documental

De las 2.540 devoluciones documentales con comentario en la ventana, **830 (32,7%) no
mencionan ninguna causa documental**. Son otra cosa: trámite o gestión del caso (16,0%
— casos digitales creados y no avanzados, solicitudes duplicadas o ya abiertas, casos
que no aparecen en el buzón del banco) y política o condiciones del crédito (18,8% —
buró, capacidad de pago, antigüedad laboral, condiciones de tasa o plazo no aceptadas).

Esto no es un mes raro: la proporción se mueve entre 23,9% y 36,4% en los once meses de
la ventana, sin tendencia. Y no es un artefacto del clasificador: los seis anotadores
independientes que construyeron el set de referencia lo reportaron por separado, cada
uno con sus propias palabras.

**Por qué importa más que el resto.** `Política documental` es el 83,5% de las
devoluciones tipificadas. Si un tercio de esa categoría no es documental, entonces
cualquier meta, tablero o plan de acción construido sobre ese número está apuntando a
un problema cuyo tamaño real no se conoce. Es el modo de falla que describe CLAUDE.md:
números correctos sobre una definición equivocada.

**Qué hacer:** abrir el catálogo de `tipificacion_devolucion` para que "trámite o
gestión del caso" y "política o condiciones del crédito" sean opciones propias, y
volver a medir. Es la intervención de menor costo y la que condiciona todas las demás,
porque sin ella no se sabe cuál es la línea base.

---

## Hallazgo 2 — Dentro de lo que sí es documental, los faltantes dominan

Sobre las mismas 2.540 devoluciones con comentario (multi-etiqueta, un comentario
suele listar 2 a 4 causas):

| Categoría | Menciones | % | F1 en holdout | Días de ciclo acumulados |
|---|---|---|---|---|
| Faltantes documentales del cliente | 1.444 | 56,9% | 0,87 | 8.250 |
| Errores en el diligenciamiento de formularios | 656 | 25,8% | 0,83 | 3.212 |
| Inconsistencia en la información | 293 | 11,5% | 0,67 | 1.819 |
| Documento vencido o desactualizado | 238 | 9,4% | 0,68 | 1.281 |
| Documentos ilegibles | 168 | 6,6% | 0,92 | 806 |

Los faltantes son más del doble que la siguiente categoría y se mantienen entre 52,6% y
67,5% todos los meses. Es la categoría más estable del análisis y la de mejor
clasificación.

Los ilegibles pesan poco: 6,6%. Vale la pena decirlo porque es la clase de categoría
que suele sobre-estimarse por lo visible que resulta.

**Cuidado con dos filas de esa tabla.** `Inconsistencia` tiene recall 0,57 — el
clasificador se pierde una de cada tres, así que su volumen real es mayor que 11,5%.
`Documento vencido` tiene F1 0,68 y su volumen puede estar inflado. Ninguna de las dos
debería usarse para fijar una meta sin una revisión manual previa (ver `VALIDACION.md`).

---

## Hallazgo 3 — Lo que más tarda no es lo que más pesa

Mediana de días entre radicación y devolución, por categoría:

| Categoría | Mediana (días) |
|---|---|
| Trámite o gestión del caso | **9,2** |
| Otros | 4,2 |
| Inconsistencia en la información | 4,1 |
| Política o condiciones del crédito | 3,7 |
| Faltantes documentales del cliente | 3,5 |
| Documentos ilegibles | 3,3 |
| Errores en el diligenciamiento / Documento vencido | 3,0 |

Las devoluciones por trámite tardan casi el triple que las documentales. Tiene una
lectura mecánica: un documento faltante se detecta al revisar el paquete, mientras que
un caso que no avanzó en el sistema solo se descubre cuando alguien lo busca. Con
16,0% de volumen y 9,2 días de mediana, acumula 6.017 días de ciclo en once meses —
más que diligenciamiento, ilegibles y vencidos juntos.

En total, las devoluciones tipificadas como documentales consumieron **37.836 días de
ciclo** en la ventana, unos 3.440 días por mes.

### Dentro de trámite hay dos casos concretos y repetidos

El texto libre no es todo distinto: 3.414 comentarios únicos sobre 3.693. Dos frases
enlatadas se repiten y describen el mismo par de problemas operativos:

| Comentario | Casos | Mediana de días | Días de ciclo acumulados |
|---|---|---|---|
| "no hay solicitud abierta o vigente en Mantiz" | 115 | 22,0 | 2.667 |
| "no está en buzón" (BBVA, Occidente, Bogotá) | 92 | 20,9 | 2.257 |
| **Total** | **207** (5,6% de los comentados) | | **4.924** |

Son el 5,6% de los casos con comentario y consumen seis veces más tiempo que la
mediana general de 3,5 días. Aparecen de forma sostenida entre 9 y 18 veces por mes
desde 2025-10, así que no es un incidente puntual.

No es una falla documental: es una radicación que se creó sin que existiera la
solicitud del lado del banco, o que el banco nunca recibió. Se detecta tarde porque
nadie la está esperando. Es el caso más claro de todo el análisis en el que una
alerta automática — radicación sin acuse del banco a los N días — reemplazaría tres
semanas de espera por una revisión el mismo día.

---

## Hallazgo 4 — La mitad de las devoluciones documentales no dice por qué

4.583 de 8.275 filas de `Política documental` (55,4%) no tienen comentario. Dentro de
la ventana la cobertura oscila entre 26,8% y 50,6% según el mes, sin patrón claro.

Esto tiene dos consecuencias. La primera es que el desglose de arriba describe una
mitad del problema. La segunda, más incómoda: **si el analista llena el comentario con
más frecuencia en unos tipos de caso que en otros, el desglose está sesgado y no hay
manera de detectarlo con este archivo.** No es un dato que se pueda recuperar hacia
atrás; solo se puede dejar de perder hacia adelante.

---

## Recomendaciones, en orden

Las dos primeras son de instrumentación: sin ellas no se puede medir si las demás
funcionan.

| # | Acción | Ataca | Volumen (dato) | Prevenibilidad (1-5, Ivan) | Costo (1-5, Ivan) |
|---|---|---|---|---|---|
| 1 | Abrir el catálogo de tipificación: separar "trámite/gestión" y "política del crédito" de "documental" | Hallazgo 1 | 32,7% de lo documental | | |
| 2 | Hacer obligatorio el campo de comentario al devolver | Hallazgo 4 | 55,4% sin diagnóstico | | |
| 3 | Checklist bloqueante de completitud en el punto de radicación | Faltantes | 56,9% | | |
| 4 | Formularios con campos obligatorios y validación de firma/huella antes de enviar | Diligenciamiento | 25,8% | | |
| 5 | Regla automática de vigencia al cargar (ej. certificado laboral ≤ 45 días) | Vencidos | 9,4% | | |
| 6 | Validación de calidad de imagen en el cargue (resolución mínima, ambas caras) | Ilegibles | 6,6% | | |
| 7 | Alerta por radicación sin acuse del banco a los N días (casos "no hay solicitud en Mantiz" / "no está en buzón") | Trámite | 207 casos, 21 días de mediana, 4.924 días de ciclo | | |

Las acciones 3 a 6 son todas del mismo tipo: **validación dura en el punto de
radicación en vez de revisión posterior**. Juntas cubren el 67,3% de las devoluciones
documentales con comentario. Conviene decidirlas como un solo bloque y no una por una,
porque comparten el mismo punto de intervención.

La hipótesis de CLAUDE.md — que el grueso del volumen sería completitud y calidad
documental, prevenible con validación dura en el punto de radicación — es consistente
con lo que muestran los datos. Pero conviene registrar que se cumplió, no tratarla como
confirmada: se midió sobre el 38% del universo y sobre una tipificación que sabemos
contaminada en un tercio.

---

## Lo único que sí sale de las dos fechas: cuándo llega la devolución

Con `fecha_de_radicado` y `fecha_devolucion` no se obtiene una tasa, pero sí la curva
acumulada de cuándo ocurren las devoluciones. Sobre las 21.207 devoluciones vigentes:

| Ocurren dentro de | % acumulado |
|---|---|
| 1 día | 15,4% |
| 3 días | 35,5% |
| 5 días | 52,2% |
| 7 días | 69,5% |
| 10 días | 80,7% |
| **14 días** | **89,7%** |
| 21 días | 95,5% |
| 30 días | 98,0% |

Esta curva sirve para dos cosas concretas. Fija el umbral de censura en 14 días, que
es el que usa `01_tabla_base.py`: por debajo de eso una cohorte todavía no terminó de
devolverse y se ve mejor de lo que es. Y da el umbral de la alerta de la acción 7: a
los 10 días ya ocurrió el 81% de las devoluciones, así que una radicación sin acuse a
esa altura es anómala y vale la pena revisarla en vez de esperar las tres semanas que
hoy tardan los casos de Mantiz y buzón.

## Cómo medir si funciona

Nada de lo anterior es medible hoy. El orden tiene que ser este:

1. **Conseguir el denominador.** Basta un agregado sin datos de cliente: radicaciones
   totales por semana. `01_tabla_base.py` ya lo espera en `radicaciones_totales.csv` y
   calcula la tasa en cuanto exista.
2. **Fijar la línea base antes de intervenir**, con la censura de 14 días aplicada
   (p90 del lag). Sin eso, las cohortes recientes se ven artificialmente buenas.
3. **Piloto con grupo de control.** Un grupo de brokers con la intervención y otro
   comparable en volumen y perfil sin ella, diff-in-diff simple. Requiere `broker_id`,
   que hoy no existe en el export.
4. No comparar contra el mes anterior a secas: el mix de motivos ya se movió una vez
   por razones de captura, no de proceso (`HIPOTESIS.md` H-02).
