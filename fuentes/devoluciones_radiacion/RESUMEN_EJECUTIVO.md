# Devoluciones de radicaciones — Resumen ejecutivo

**Fecha:** 2026-08-13 · **Fuente:** export `data.xlsx`, corte 2026-08-12 ·
**Ventana analizada:** radicaciones de 2025-09 a 2026-07

---

## 1. Qué se hizo

Se perfiló el universo disponible de devoluciones, se construyó la tabla base anclada
en la fecha de radicación y se desglosó la principal causa de devolución —
`Política documental`, que concentra el 83,5% del volumen tipificado — en categorías
accionables leídas del comentario del analista.

| Paso | Artefacto | Qué produce |
|---|---|---|
| 00 | `00_perfilado.py` → `PERFILADO.md` | Calidad, cobertura y comparabilidad de los datos |
| 01 | `01_tabla_base.py` → `tabla_base.xlsx` | Cohortes semanales, lag y censura a 14 días |
| 02 | `02_clasificacion.py` → `documental_categorizado.xlsx` | Columna `categorias_documentales` (multi-etiqueta) sobre 8.275 devoluciones |
| 03 | `03_validacion.py` → `VALIDACION.md` | Exactitud por categoría contra 600 casos etiquetados |
| — | `RECOMENDACIONES.md` | Siete acciones priorizadas por volumen |

El clasificador es un modelo de reglas sobre el texto del comentario, calibrado contra
600 comentarios etiquetados de forma independiente. Etiqueta todas las causas que
aparecen en cada comentario, porque un comentario típico enumera entre dos y cuatro.

---

## 2. Los cuatro hallazgos

### Un tercio de "Política documental" no es documental

De las 2.540 devoluciones documentales con comentario en la ventana, **830 (32,7%) no
describen ninguna falla de documentos**. Son problemas de trámite del caso (16,0%) o de
política y condiciones del crédito (18,8%). La proporción se sostiene entre 24% y 36%
todos los meses.

Es el hallazgo con más consecuencias: como esta tipificación es el 83,5% del volumen,
cualquier meta que se fije sobre ella hoy está midiendo un problema cuyo tamaño real se
desconoce. **Corregir el catálogo de tipificación es la primera acción, porque define
la línea base de todas las demás.**

### Dentro de lo documental, los faltantes dominan

| Categoría | % de las devoluciones documentales con comentario | Confiabilidad (F1) |
|---|---|---|
| Faltantes documentales del cliente | 56,9% | 0,87 |
| Errores en el diligenciamiento de formularios | 25,8% | 0,83 |
| Inconsistencia en la información | 11,5% | 0,67 |
| Documento vencido o desactualizado | 9,4% | 0,68 |
| Documentos ilegibles | 6,6% | 0,92 |

Los faltantes son más del doble que la siguiente categoría y se mantienen entre 52,6% y
67,5% mes a mes. Los ilegibles, que suelen sobre-estimarse por lo visibles que son,
pesan 6,6%.

Las cuatro primeras acciones apuntan al mismo punto de intervención —validación dura al
momento de radicar, en vez de revisión posterior— y juntas cubren el 67,3% de las
devoluciones documentales con comentario.

### Hay 207 casos que tardan seis veces más que el resto

Dos frases enlatadas se repiten en el texto: *"no hay solicitud abierta o vigente en
Mantiz"* (115 casos) y *"no está en buzón"* (92 casos). Son el 5,6% de los casos con
comentario, pero tienen **21 días de mediana contra 3,5 del resto** y acumulan 4.924
días de ciclo. Aparecen de forma sostenida entre 9 y 18 veces por mes desde octubre de
2025.

No es una falla documental: es una radicación que el banco nunca recibió y que nadie
está esperando, por lo que se descubre tarde. Una alerta por radicación sin acuse a los
10 días —momento en el que ya ocurrió el 81% de las devoluciones— reemplazaría tres
semanas de espera por una revisión el mismo día.

### El costo hoy se mide en tiempo, no en conversión

Las devoluciones tipificadas como documentales consumieron **37.836 días de ciclo** en
los once meses de la ventana, unos 3.440 por mes. No se puede afirmar cuántas de esas
radicaciones terminan aprobándose, porque el dato de resultado final no existe en la
fuente. Mientras eso no se sepa, el costo demostrable es tiempo de ciclo, no pérdida de
negocio.

---

## 3. Alcance

Lo que este análisis **sí** sostiene:

- La composición de las devoluciones documentales: qué falla y en qué proporción.
- El tiempo entre radicación y devolución, global y por categoría.
- La identificación de dos problemas operativos concretos y repetidos.

Lo que **no** sostiene, y conviene no citar aunque suene natural:

- Ninguna **tasa** de devolución, ni su tendencia. El archivo contiene únicamente
  radicaciones devueltas: hay numerador y no hay denominador.
- Ninguna comparación entre **brokers, directores comerciales, KAM o analistas**. Esas
  columnas no existen en el export, y son justamente las que deciden entre coaching
  individual y rediseño de proceso.
- Nada anterior a **septiembre de 2025**: el campo de tipificación estuvo prácticamente
  vacío hasta finales de 2024 y se estabilizó recién en 2025-09.

---

## 4. Limitaciones

1. **Falta el denominador.** Es el bloqueo principal. Se resuelve con un agregado de dos
   columnas —semana y total de radicaciones, devueltas y no devueltas—, sin ningún dato
   de cliente. `01_tabla_base.py` ya lo espera y calcula la tasa apenas exista.
2. **Falta la dimensión de responsable.** Sin `broker_id` no se puede saber si el
   problema está concentrado o es transversal, ni montar el piloto con grupo de control.
3. **Dos categorías no son confiables todavía.** `Inconsistencia` (recall 0,57) está
   subestimada y `Documento vencido` (F1 0,68) posiblemente inflada. No deberían usarse
   para fijar metas sin una revisión manual previa.
4. **La validación la hicieron modelos, no el negocio.** Los 600 casos de referencia los
   etiquetaron anotadores automáticos. Mide consistencia, no criterio de negocio.
5. **El 55,4% de las devoluciones documentales no tiene comentario.** Es la limitación
   que se trata aparte, abajo.

---

## 5. Los negocios sin comentario: escalarlo, y mientras tanto trabajar en porcentajes

**4.583 de 8.275 devoluciones de `Política documental` (55,4%) no tienen comentario.**
Dentro de la ventana, la cobertura oscila entre 26,8% y 50,6% según el mes, sin patrón.

Esto es un problema de captura, no de análisis: la herramienta permite cerrar una
devolución sin registrar el motivo. **Debe escalarse a desarrollo como un cambio de
producto —campo obligatorio al devolver—**, porque es información que se está perdiendo
de forma irrecuperable todos los días y ninguna corrección posterior la reconstruye.

Ahora bien, eso no bloquea la acción. Se puede excluir del cálculo lo que no tiene
comentario y trabajar sobre la **distribución porcentual de los que sí lo tienen**. La
pregunta accionable no es cuántas devoluciones hubo por cada causa, sino qué peso
relativo tiene cada una, y eso se responde con la mitad observada siempre que esa mitad
no esté sesgada hacia unas causas.

**Se verificó que no lo parece.** La cobertura del comentario varía casi al doble entre
meses (26,8% a 50,6%), lo que permite usar esa variación como prueba: si los meses con
más comentarios mostraran una mezcla distinta, la muestra estaría sesgada.

Script: `04_sesgo_cobertura.py`.

| Categoría | Rango del share entre meses | Correlación con la cobertura |
|---|---|---|
| Faltantes documentales del cliente | 52,6% – 67,5% | **−0,04** |
| Documentos ilegibles | 3,1% – 8,5% | **+0,03** |
| Inconsistencia en la información | 9,1% – 17,2% | **+0,02** |
| Sin causa documental | 23,9% – 36,4% | +0,30 |
| Errores en el diligenciamiento | 20,3% – 39,0% | +0,33 |
| Documento vencido o desactualizado | 6,1% – 13,5% | −0,54 |

Las tres primeras no muestran ninguna relación con la cobertura: su peso es el mismo
tanto en los meses en que se comentó una de cada cuatro devoluciones como en los que se
comentó una de cada dos. Entre ellas está la categoría que concentra el volumen. **Para
faltantes, ilegibles e inconsistencia, priorizar por porcentaje sobre los comentados es
defendible.**

Tres matices honestos. Diligenciamiento y el bloque no documental muestran una relación
positiva leve (+0,33 y +0,30): en los meses de baja cobertura su peso podría estar algo
subestimado. `Documento vencido` es el caso que peor se comporta (−0,54) y además es una
de las dos categorías con F1 bajo, así que su volumen no es utilizable por dos razones
distintas. Y con once meses, correlaciones de esta magnitud no se distinguen bien del
ruido: el argumento fuerte no es el coeficiente sino que el rango del share se mantiene
estrecho mientras la cobertura se duplica.

**En la práctica:** priorizar por peso relativo —faltantes primero, diligenciamiento
después— es una decisión que los datos actuales sostienen. Lo que no se puede hacer con
esta mitad es afirmar volúmenes absolutos ("hubo N devoluciones por faltantes") ni
proyectarlos al total sin decir que se está extrapolando.

---

## 6. Qué se necesita para cerrar

| Prioridad | Qué | Quién | Desbloquea |
|---|---|---|---|
| 1 | Agregado semanal de radicaciones totales | Datos | La tasa y toda medición de tendencia |
| 2 | Tabla con `broker_id`, `director_comercial`, `kam`, `resultado_final` | Datos | Concentración, onboarding, costo de conversión, piloto con control |
| 3 | Campo de motivo obligatorio al devolver | Desarrollo | Elimina el 55,4% de ceguera hacia adelante |
| 4 | Abrir el catálogo de tipificación (trámite y política como opciones propias) | Operación | Corrige el 32,7% mal clasificado |
| 5 | Validar la taxonomía y etiquetar 150 casos a mano | Negocio (Ivan) | Convierte el desglose en criterio de negocio |

Las tres primeras no requieren análisis adicional, solo acceso o desarrollo. El detalle
técnico está en `RECOMENDACIONES.md`, `VALIDACION.md` y `BITACORA.md`.
