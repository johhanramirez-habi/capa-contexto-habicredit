# CLAUDE.md — Análisis de devoluciones de radicaciones (Habicredit)

## Objetivo del proyecto

Entender por qué se devuelven las radicaciones de crédito hipotecario y construir
evidencia suficiente para diseñar un plan que reduzca la tasa de devolución.

**Entregable final:** un conjunto de hallazgos priorizados por
`volumen × prevenibilidad × costo de intervención`, cada uno trazable a una query
versionada de este repo.

---

## Reglas de operación (leer antes de cada sesión)

### 1. No explorar libremente

Toda query debe responder una pregunta que ya esté escrita en `PREGUNTAS.md`.

Este dataset tiene ≥4 dimensiones cruzables (broker, director comercial, KAM,
motivo) más tiempo. Con esa cantidad de cortes, siempre va a aparecer algo que
se ve significativo por azar. Los números serán correctos y la conclusión será
falsa — que es el modo de falla más difícil de detectar después.

Si aparece un patrón no anticipado: **no es un hallazgo**. Se registra en
`HIPOTESIS.md` como candidato a validar contra datos nuevos o una ventana
temporal distinta.

### 2. Nunca inventar semántica de negocio

Si no está documentado en este archivo o en `DICCIONARIO.md`, **preguntar a Ivan**.
No asumir qué significa un estado, un flag, un valor nulo o una categoría.
No decidir criterios de exclusión por cuenta propia (cuentas de prueba, brokers
internos, radicaciones de migración) — preguntar.

Producir números correctos sobre definiciones equivocadas se ve idéntico a
producir el resultado bueno.

### 3. No traer filas crudas al contexto

Trabajar sobre agregados y muestras ≤50 filas. Son datos de clientes
hipotecarios: nombres, documentos, ingresos. Si hace falta ver texto libre,
muestrear y truncar.

### 4. Control de costo en BigQuery

- La tabla base debe estar **particionada por `fecha_radicacion`** y las queries
  exploratorias deben filtrar por partición.
- `LIMIT` **no** reduce bytes escaneados. No usarlo como control de costo.
- Configurar `maximum_bytes_billed` en toda sesión exploratoria.
- Antes de correr una query nueva sobre tablas grandes, reportar el estimado de
  bytes con `--dry_run`.

### 5. Verificación manual obligatoria

Después de materializar la tabla base, Ivan recalcula a mano la tasa global y
la tasa de un broker. Hasta que eso cuadre, ningún resultado aguas abajo cuenta.

---

## Configuración del entorno

> **TODO Ivan — completar antes de la primera sesión.**

```yaml
proyecto_bq:        # papyrus-... ?
dataset_origen:     #
tabla_origen:       #
dataset_trabajo:    # dónde se materializan las tablas de este análisis
```

**Esquema de la tabla origen:** pegar el DDL en `DICCIONARIO.md`.

**Dos preguntas que bloquean todo lo demás:**

1. ¿Existe `fecha_radicacion` en la tabla? Sin ella no hay tasa, solo conteo de
   devoluciones — y un conteo no se puede convertir en meta.
2. ¿El grano es una fila por radicación o una por evento de devolución?
   Determina si la métrica es `% radicaciones devueltas al menos una vez` o
   `devoluciones promedio por radicación`. Suelen ser ambas, pero hay que
   calcularlas por separado.

---

## Pipeline

Cada paso produce un artefacto revisable. **No avanzar al siguiente sin que Ivan
apruebe el anterior.**

```
00_perfilado.sql        Nulos, duplicados, cardinalidades, rangos de fecha,
                        distribución de longitud del texto libre, huérfanos.

01_tabla_base.sql       Materializa tabla FÍSICA: 1 fila = 1 radicación.
                        Cohorte, flag devuelta, censura aplicada.

02_clasificacion.py     LLM sobre motivo → categoría + origen.

03_validacion.sql       Accuracy por categoría vs. set etiquetado a mano.

1x_pregunta_NN.sql      Una query por pregunta de PREGUNTAS.md.
```

### Paso 00 — Perfilado

Mecánico y sin interpretación. Entregar tabla de resultados, no narrativa.

Incluir obligatoriamente:
- % de nulos por columna y su evolución mensual (un salto suele marcar un cambio
  de proceso que rompe comparabilidad).
- Duplicados por identificador de radicación.
- Rango de fechas y densidad por mes: identificar dónde empieza a ser confiable.
- Distribución de `LENGTH(motivo)`: los motivos de 1–3 palabras son ruido y hay
  que decidir cómo tratarlos.

### Paso 01 — Tabla base (el paso crítico)

Materializar como **tabla física**, no vista ni CTE. Si cada análisis re-deriva
el denominador, dos scripts van a definir la censura distinto y van a existir dos
tasas incompatibles sin forma de saber cuál es la buena.

Reglas:

- **Cohorte por `fecha_radicacion`**, nunca por fecha de devolución. Agrupar por
  fecha de devolución mezcla radicaciones de semanas distintas.
- **Censura:** calcular el p90 del lag radicación→devolución y excluir cohortes
  más recientes que ese umbral. Las radicaciones recientes aún no tuvieron tiempo
  de devolverse; su tasa se ve artificialmente baja y genera una falsa tendencia
  a la mejora.
- Dejar el umbral de censura como **parámetro nombrado** en un solo lugar.
- Columnas mínimas: `radicacion_id`, `fecha_radicacion`, `cohorte_semana`,
  `broker_id`, `director_comercial`, `kam`, `devuelta` (bool),
  `n_devoluciones`, `dias_a_primera_devolucion`, `motivo_texto`.
- Si existe el dato: `resultado_final` (¿la devuelta termina aprobándose?).
  Cambia la lectura completa — si la mayoría se aprueba, el costo es tiempo de
  ciclo y no conversión.

### Paso 02 — Clasificación del texto libre

**Bootstrapping manual primero.** Ivan lee ~200 motivos (muestra estratificada
por mes y por volumen de broker) y de ahí sale la taxonomía. No al revés.

Taxonomía de dos ejes — uno solo se queda corto porque "documento ilegible" y
"el broker no subió el certificado" tienen dueños distintos:

- **Qué falló:** documento faltante · documento ilegible/vencido ·
  inconsistencia de ingresos · datos del cliente errados · garantía/avalúo ·
  política del banco · error interno de digitación · `otro`
- **Dónde se originó:** broker · cliente · analista de radicación · banco ·
  sistema

Reglas del job:

- Multi-etiqueta, pero con **una causa primaria obligatoria**. Los motivos reales
  suelen listar tres cosas en un párrafo.
- Categoría `otro` obligatoria y permitida. Si `otro` > 12%, la taxonomía está
  incompleta — se corrige la taxonomía, no se fuerza al modelo.
- Salida JSON estructurado. Batching con reintentos y manejo de fallos parciales.
- Guardar `motivo_texto` original junto a la etiqueta, siempre.

### Paso 03 — Validación

Accuracy **por categoría**, nunca global. Una categoría al 60% manda a arreglar
el problema equivocado y el promedio la esconde.

Ivan etiqueta 150 casos a mano (distintos de los 200 del bootstrapping).
Además: revisar una muestra de etiquetas aunque el accuracy salga bien. El sesgo
típico de un LLM sobre texto operativo es sobre-asignar a la categoría más
genérica, y eso no siempre aparece en el agregado si esa categoría es grande.

### Paso 1x — Preguntas

Siempre reportar **numerador, denominador y tasa**. Nunca la tasa sola.

Volumen mínimo por grupo: `HAVING radicaciones >= 15`.

Suavizado obligatorio en rankings de broker (empirical Bayes básico):

```sql
SAFE_DIVIDE(
  COUNTIF(devuelta) + 20 * @tasa_global,
  COUNT(*) + 20
) AS tasa_ajustada
```

Sin esto, un broker con 4 radicaciones y 2 devoluciones sale con 50% y encabeza
cualquier ranking sin significar nada.

---

## Preguntas pre-registradas (v1)

Mantener en `PREGUNTAS.md`. Estado: `pendiente` / `respondida` / `descartada`.

| # | Pregunta | Por qué importa |
|---|---|---|
| 1 | ¿La tasa sube, baja o está estable por cohorte semanal? | Define si es problema nuevo o crónico |
| 2 | ¿Está concentrada en pocos brokers o es transversal? | Coaching individual vs. rediseño de proceso |
| 3 | ¿Qué categorías concentran el volumen? | Priorización |
| 4 | ¿Las devoluciones se concentran en brokers nuevos? | Si sí, es onboarding, no disciplina |
| 5 | ¿Hay variación alta entre analistas para el mismo motivo? | Sugiere criterio inconsistente: parte de las devoluciones serían falsos positivos |
| 6 | ¿La radicación devuelta termina aprobándose? | Distingue costo de ciclo vs. costo de conversión |
| 7 | ¿El mix de motivos cambia en el tiempo? | Detecta cambios de proceso o de política del banco |

Agregar preguntas nuevas **antes** de correr la query que las responde, con fecha.

---

## Protocolo de iteración

Cada ciclo cierra con una entrada en `BITACORA.md`:

```markdown
## Iteración N — YYYY-MM-DD

**Preguntas atacadas:** #_, #_

**Resultado:** [numerador / denominador / tasa. Números, no adjetivos.]

**Qué cambia en el entendimiento:** [1–3 frases]

**Qué NO se puede concluir:** [limitación de datos, ventana insuficiente,
categoría con accuracy bajo, confundido con otra variable]

**Supuestos nuevos que hubo que hacer:** [cada uno necesita confirmación de Ivan]

**Siguiente iteración:** [preguntas nuevas derivadas → van a PREGUNTAS.md]
```

**Regla de parada:** el análisis termina cuando las 7 preguntas están respondidas
y las categorías del top 80% de volumen tienen accuracy validado. No cuando
aparece una narrativa satisfactoria.

---

## Priorización de hallazgos

Frecuencia sola no basta. Cada categoría se evalúa en tres ejes:

| Eje | Cómo estimarlo |
|---|---|
| Volumen | Del análisis, directo |
| Prevenibilidad | Juicio de negocio (Ivan + operación), 1–5 |
| Costo de intervención | Juicio, 1–5 |

Hipótesis a confirmar con los datos, **no conclusión de partida**: en procesos
de radicación lo típico es que el grueso del volumen sea completitud y calidad
documental — prevenible con validación dura en el punto de radicación — mientras
que política del banco es alto volumen y casi cero prevenible.

---

## Medición del plan (fase posterior)

Cuando haya intervención definida:

- Fijar la línea base **antes** de intervenir.
- No comparar contra el mes anterior a secas.
- Piloto con un grupo de brokers + grupo control comparable en volumen y perfil.
  Diff-in-diff simple. Sin control, la estacionalidad se lleva el crédito o la
  culpa del resultado.

---

## Convenciones técnicas

- SQL en mayúsculas para palabras clave, `snake_case` para identificadores.
- Toda query con comentario de encabezado: pregunta que responde + fecha + autor.
- Fechas siempre en zona horaria explícita.
- Nada de `SELECT *` en scripts versionados.
- Rama por iteración, PR a `main`. Ivan aprueba.
- Ningún dato de cliente sale del entorno de BigQuery ni entra a este repo.
