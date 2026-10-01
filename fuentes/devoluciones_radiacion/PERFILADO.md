# PERFILADO.md — Paso 00

Fuente: `data.xlsx` (corte 2026-08-12). Script: `00_perfilado.py`. Salida cruda:
`PERFILADO_salida.txt`. Mecánico, sin interpretación — la lectura de negocio va en
`BITACORA.md` y lo no confirmado en `HIPOTESIS.md`.

## 1. Forma y grano

| Métrica | Valor |
|---|---|
| Filas | 21.221 |
| Columnas | 5 |
| `radicacion_id` únicos | 21.221 |
| `radicacion_id` duplicados | 0 |
| Filas sin `fecha_devolucion` | 0 |

## 2. Nulos por columna

| Columna | Nulos | % |
|---|---|---|
| `radicacion_id` | 0 | 0,0% |
| `fecha_de_radicado` | 3 | 0,0% |
| `fecha_devolucion` | 0 | 0,0% |
| `comentario_devoluci_n` | 13.765 | 64,9% |
| `tipificacion_devolucion` | 10.695 | 50,4% |

## 3. Densidad mensual y evolución de nulos (por mes de radicado)

`tipificacion_devolucion` pasa de ~100% nula a ~3% nula entre 2024-11 y 2025-09.
Es un salto de proceso: **los meses anteriores a 2025-09 no son comparables** con los
posteriores en nada que dependa de la tipificación.

| Mes | n | % nulo tipificación | % nulo comentario |
|---|---|---|---|
| 2023-06 … 2024-10 | 6.226 | 99,2 – 100 | 19 – 68 |
| 2024-11 | 584 | 96,9 | 62,5 |
| 2024-12 | 419 | 87,8 | 62,8 |
| 2025-01 | 335 | 70,4 | 71,3 |
| 2025-02 | 528 | 70,5 | 71,0 |
| 2025-03 | 618 | 67,3 | 67,3 |
| 2025-04 | 599 | 65,6 | 65,9 |
| 2025-05 | 617 | 66,3 | 68,7 |
| 2025-06 | 590 | 43,2 | 65,6 |
| 2025-07 | 722 | 13,9 | 69,3 |
| 2025-08 | 655 | 15,6 | 69,5 |
| 2025-09 | 783 | 3,1 | 66,7 |
| 2025-10 | 881 | 3,0 | 67,4 |
| 2025-11 | 718 | 6,8 | 68,1 |
| 2025-12 | 678 | 7,1 | 62,7 |
| 2026-01 | 622 | 9,0 | 57,7 |
| 2026-02 | 1.053 | 9,7 | 58,1 |
| 2026-03 | 997 | 8,4 | 62,2 |
| 2026-04 | 816 | 13,1 | 68,8 |
| 2026-05 | 785 | 9,8 | 75,4 |
| 2026-06 | 609 | 20,5 | 70,4 |
| 2026-07 | 805 | 17,9 | 59,6 |
| 2026-08 (parcial, al día 12) | 164 | 1,2 | 17,1 |
| (sin fecha de radicado) | 3 | 100 | 100 |

El % de nulos del comentario libre se mantiene entre 58% y 75% en todo el período:
estable, no hay cambio de proceso ahí.

**Ventana confiable para análisis de tipificación: 2025-09 a 2026-07** (2026-08 es
mes parcial).

## 4. Cobertura cruzada de los dos campos de motivo

| | sin comentario | con comentario |
|---|---|---|
| **sin tipificación** | 7.977 | 2.718 |
| **con tipificación** | 5.788 | 4.738 |

**7.977 filas (37,6%) no tienen ni tipificación ni comentario.** Para esas
devoluciones no hay ninguna información de causa en este export.

## 5. Rangos e integridad temporal

| Métrica | Valor |
|---|---|
| `fecha_de_radicado` | 2023-06-14 19:59 → 2026-08-12 11:52 |
| `fecha_devolucion` | 2023-10-25 06:36 → 2026-08-12 11:55 |
| `fecha_de_radicado` nula | 3 |
| Lag negativo (devolución antes del radicado) | 9 |
| Lag > 180 días | 1 (máximo: 917,5 días) |

## 6. Lag radicación → devolución (días)

| Percentil | Días |
|---|---|
| min | −2,97 |
| p05 | 0,01 |
| p25 | 1,89 |
| p50 | 4,86 |
| p75 | 8,02 |
| **p90** | **14,09** |
| p95 | 20,18 |
| p99 | 39,81 |
| max | 917,53 |

**p90 = 14,09 días** es el umbral de censura que pide CLAUDE.md para el Paso 01.
Con corte de datos 2026-08-12, las cohortes desde **2026-07-29** en adelante están
censuradas y no deben usarse para comparar.

## 7. `LENGTH(comentario_devoluci_n)` (sobre 7.456 no nulos)

| Percentil | Caracteres |
|---|---|
| p05 | 36 |
| p25 | 89 |
| p50 | 160 |
| p75 | 259 |
| p90 | 383 |
| p99 | 902 |
| max | 2.155 |

Vacíos tras `strip`: 2. ≤20 caracteres: 93. De 1 a 3 palabras: 115 (1,5% de los no
nulos). **El ruido de texto ultracorto es marginal**; el problema del texto libre no
es la longitud sino la cobertura (§4). La inspección de muestra confirma lo que
anticipa CLAUDE.md: un comentario suele enumerar 2–4 causas en un párrafo, lo que
obliga al esquema multi-etiqueta con causa primaria del Paso 02.

## 8. Preguntas #3 y #7, acotadas — composición, NO tasa

Denominador: 7.905 devoluciones tipificadas radicadas entre 2025-09 y 2026-07.
**No es tasa de devolución**: el export no trae radicaciones no devueltas.

| Tipificación | n | Share |
|---|---|---|
| Política documental | 6.598 | 83,5% |
| Politica interna del banco | 775 | 9,8% |
| Criterios mínimos de aceptación | 426 | 5,4% |
| Política score o mora | 56 | 0,7% |
| Política de edad más plazo | 50 | 0,6% |

Mix mensual (% de las devoluciones tipificadas de cada mes):

| Mes | Documental | Interna banco | Criterios mín. | Score/mora | Edad+plazo | n |
|---|---|---|---|---|---|---|
| 2025-09 | 68,0 | 18,6 | 9,9 | 1,8 | 1,7 | 759 |
| 2025-10 | 76,7 | 12,4 | 8,7 | 1,2 | 1,1 | 855 |
| 2025-11 | 83,1 | 10,2 | 5,5 | 0,4 | 0,7 | 669 |
| 2025-12 | 85,4 | 8,9 | 4,8 | 0,6 | 0,3 | 630 |
| 2026-01 | 86,0 | 8,7 | 3,9 | 0,7 | 0,7 | 566 |
| 2026-02 | 85,4 | 9,3 | 3,9 | 0,9 | 0,5 | 951 |
| 2026-03 | 89,9 | 6,7 | 2,2 | 0,5 | 0,7 | 913 |
| 2026-04 | 86,6 | 7,2 | 5,5 | 0,4 | 0,3 | 709 |
| 2026-05 | 86,9 | 7,3 | 5,5 | 0,1 | 0,1 | 708 |
| 2026-06 | 86,0 | 8,3 | 5,4 | 0,2 | 0,2 | 484 |
| 2026-07 | 85,8 | 9,5 | 4,1 | 0,3 | 0,3 | 661 |

El corrimiento de 68% → 86% en documental durante 2025-09/2026-03 coincide con el
período de adopción del campo (§3). Registrado como hipótesis, no como hallazgo:
ver `HIPOTESIS.md` H-02.

---

## Actualización — corte 2026-08-31 (`data_20260831.xlsx`)

Fuente: Google Sheet "Nuevos datos" (hoja `Extracto 1`), mismo query, corte más
reciente. Detalle del query y de lo que cambió respecto al corte anterior en
`DICCIONARIO.md`. Salida cruda: `PERFILADO_salida_20260831.txt`.

### 1. Forma y grano

| Métrica | 2026-08-12 | 2026-08-31 |
|---|---|---|
| Filas | 21.221 | 21.732 |
| `radicacion_id` únicos | 21.221 | 21.732 |
| `radicacion_id` duplicados | 0 | 0 |

### 2. Nulos por columna

| Columna | 2026-08-12 | 2026-08-31 |
|---|---|---|
| `fecha_de_radicado` | 3 (0,0%) | 3 (0,0%) |
| `fecha_devolucion` | 0 (0,0%) | 0 (0,0%) |
| `comentario_devolucion` | 13.765 (64,9%) | 8.978 (41,3%) |
| `tipificacion_devolucion` | 10.695 (50,4%) | 11.061 (50,9%) |

El salto en `comentario_devolucion` (64,9% → 41,3% nulo) es la columna que más se
mueve, y **es más grande y más extendido que el de `tipificacion_devolucion`**.
Verificado a nivel de fila (mismos `radicacion_id` en ambos pulls, `n`=21.220):

| | 31-ago sin comentario | 31-ago con comentario |
|---|---|---|
| **12-ago sin comentario** | 8.913 | **4.851** |
| **12-ago con comentario** | 32 | 7.424 |

4.851 radicaciones (22,9% del solapamiento) pasaron de no tener comentario a
tenerlo, repartidas en casi todos los meses de 2025-09 a 2026-07 (300-570 por mes,
`DICCIONARIO.md` tiene el detalle) — a diferencia del salto de tipificación de
agosto 2025, que fue puntual, **este no está concentrado en un mes: es transversal
a toda la ventana**. Dentro de las 8.274 filas que el pull de 12-ago tipificaba como
`Política documental`, 4.056 de las 4.583 que no tenían comentario (88,5%) ahora sí
lo tienen. Eso sube la cobertura potencial de comentario dentro de "documental" de
44,6% a ~93%. No se interpreta la causa aquí (ver `DICCIONARIO.md` — hipótesis
mecánica: el query nuevo trae `comentario_devolucion` como
`COALESCE(pr.comentario_devoluci_n, r.hist_rico_motivo_y_comentario_devoluci_n)`,
dos fuentes; no hay forma de confirmar si el export de 12-ago usaba la misma lógica
porque su SQL no quedó documentado). Tiene implicación directa sobre si vale la pena
rerodar el Paso 02 — ver `PREGUNTAS.md` #17.

### 3. Densidad mensual — solo los meses con cambio relevante en `tipificacion_devolucion`

| Mes | n | % nulo (12-ago) | % nulo (31-ago) |
|---|---|---|---|
| 2025-08 | 655 | 15,6 | **59,8** |
| 2025-09 | 783 → 739* | 3,1 | 5,6 |
| 2026-08 | 164 (parcial) | 1,2 | 4,9 (ya con más días del mes) |

\*El `n` de 2025-09 baja de 783 a 739 en la tabla de nulos porque unas filas
migraron de mes según `fecha_de_radicado` recalculada — no investigado, volumen
menor.

El resto de meses (2025-09 a 2026-07, salvo la nota anterior) no cambia de forma
relevante. **El salto de 2025-08 (15,6% → 59,8% nulo) es un evento aislado,
verificado a nivel de fila en `DICCIONARIO.md`: 290 de los mismos 655
`radicacion_id` perdieron su tipificación entre un pull y otro.** No se interpreta
la causa aquí — ver pregunta #15 en `PREGUNTAS.md`.

### 6. Lag radicación → devolución (días)

| Percentil | 2026-08-12 | 2026-08-31 |
|---|---|---|
| p50 | 4,86 | 4,81 |
| p90 | 14,09 | 14,06 |
| p99 | 39,81 | 39,96 |
| max | 917,53 | 917,53 |

Estable. El umbral de censura del Paso 01 (p90 ≈ 14 días) no cambia de forma
material con el corte nuevo.

### 8-9. Composición (ventana 2025-09..2026-07)

| Tipificación | 12-ago (n=7.905) | 31-ago (n=7.879) |
|---|---|---|
| Política documental | 83,5% | 83,6% |
| Politica interna del banco | 9,8% | 9,8% |
| Criterios mínimos de aceptación | 5,4% | 5,4% |
| Política score o mora | 0,7% | 0,7% |
| Política de edad más plazo | 0,6% | 0,6% |

La composición en la ventana ya cerrada (2025-09..2026-07) es prácticamente
idéntica pese al ruido de nulos de agosto 2025 y a los 512 registros nuevos —
consistente con que el ruido nuevo cae sobre todo fuera de esta ventana o se
compensa dentro de ella. **No se interpreta como validación de estabilidad
general**: el hallazgo de agosto 2025 (§3) muestra que un mes puntual sí puede
moverse fuerte entre pulls.
