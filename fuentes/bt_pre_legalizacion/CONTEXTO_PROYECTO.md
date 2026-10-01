# Contexto: BT Pre-Legalización BI (backlog, salidas, apagados, devoluciones)

## Qué es esto

Tablero/indicador de negocio crítico para la compañía: backlog de pre-legalización, salidas exitosas, apagados y devoluciones. **No es un archivo de este repo** — vive completamente en BigQuery como una scheduled query (transfer config).

- Proyecto GCP: `papyrus-delivery-data`, dataset `habicredit`.
- Transfer config: `projects/890705713225/locations/us/transferConfigs/6a44c3af-0000-26e8-9f09-5c337bc427d7` (display name `bt_pre_legalizacion_bi_new`), corre cada 2 horas.
- Es un **script de 3 sentencias** (no un `SELECT` plano): `CREATE TEMP TABLE _resultado AS <query grande>` → `MERGE` a tabla de control → `CREATE OR REPLACE TABLE` final.
- Tabla de control (congela cierres para que no se reescriban): `papyrus-delivery-data.habicredit.bt_pre_legalizacion_cierres_congelados`.
- Tabla final consumida por reportes: `papyrus-delivery-data.habicredit.bt_pre_legalizacion_bi_new`.
- Fuentes principales: `papyrus-master.liquidez_platinum_co.bt_prelegalizacion` / `.fct_radicacion` / `.bt_legalizacion`; `liquidez-main-prod.habi_credit.user` / `report` / `report_status`; `papyrus-delivery-data.habicredit.main_board`, `.pipe_radicacion_co`, `.apagados_pre_legalizacion_tech`.
- Reportes que consumen esta tabla: dos stored procedures, `papyrus-delivery-data.habicredit.rotacion_general_pre_legalizacion` y `rotacion_general_pre_legalizacion_tipo_producto` (calculan backlog/salidas/apagados/devoluciones día a día).

## Herramientas y comandos útiles

- `bq` y `gcloud` ya autenticados como `johhanramirez@habi.co`, proyecto default `papyrus-delivery-data`. No hay conector MCP de BigQuery — todo vía `bq query --use_legacy_sql=false` por Bash.
- Editar la scheduled query: `bq update --transfer_config --params='{"query":"..."}' <transferConfig>`.
- Disparar una corrida manual (equivalente a un "reabastecimiento" completo, porque este script reconstruye toda la tabla desde cero, no hay backfill incremental por partición): `bq mk --transfer_run --run_time="$(date -u +%Y-%m-%dT%H:%M:%SZ)" <transferConfig>`, luego poll con `bq show --transfer_run <run_name>` hasta `SUCCEEDED`/`FAILED`.
- **Siempre validar con una corrida real, no solo `dry_run`** — el dry-run no detecta errores que solo aparecen en ejecución (ej. columnas ambiguas).
- Dataset `habicredit` tiene `maxTimeTravelHours: 168` (7 días) — usar `FOR SYSTEM_TIME AS OF TIMESTAMP(...)` para diffs históricos. No se puede mezclar una referencia con y sin time-travel a la misma tabla en una sola query — hay que correrlas por separado y comparar en Python.
- `bq query` trunca a 100 filas por default — usar `--max_rows=<N>`.

---

## Historial de causas raíz y fixes (cronológico)

### Root cause #1 — filtro de broker activo borraba histórico completo (fix: 2026-09-16)
`WHERE u.is_active IS TRUE` convertía un `LEFT JOIN` en `INNER JOIN`. Al desactivar un broker, se borraba TODO su portafolio histórico, incluyendo negocios cerrados hace meses (911 de 63,546 negocios afectados). **Fix:** se quitó el filtro temprano; ahora solo se excluye un negocio si está inactivo el broker **Y** sigue sin `fecha_fin_pre_legalizacion` (backlog abierto) **Y** han pasado más de 60 días desde la última actividad del broker. Negocios ya cerrados (cualquier desenlace) nunca se excluyen por esto.

### Root cause #2 — fechas de cierre se recalculaban en vivo y se sobrescribían (fix: 2026-09-16)
`fecha_fin_pre_legalizacion` era un `COALESCE` recalculado en cada corrida — una devolución posterior o un `fecha_desembolso` que pasaba a NULL podían reescribir silenciosamente un cierre ya reportado (53 de 978 negocios de agosto afectados). **Fix:** arquitectura cambiada a script de 3 pasos con tabla de control `bt_pre_legalizacion_cierres_congelados` que congela cada (report_id, ciclo) la PRIMERA vez que obtiene un cierre no nulo (`MERGE ... WHEN NOT MATCHED THEN INSERT`, nunca se actualiza después).

### Root cause #3 — filtro `duplicado_en_radicaci_n` excluye registros completos (parcialmente mitigado)
Este join (marcado por el autor original como "conexión temporal") excluye el registro de `_resultado` por completo. **No arreglado de raíz**, pero mitigado como efecto secundario del fix v2 (abajo): si el ciclo ya estaba congelado, sigue apareciendo desde la tabla de control aunque `_resultado` ya no lo produzca.

### Root cause #4 — `ciclo` es una etiqueta derivada e inestable (encontrado 2026-09-16)
`es_reinicio`/`ciclo` se recalculan en vivo a partir de filas de `bt_prelegalizacion` que pueden ser borradas o reclasificadas retroactivamente en la fuente, hacienda que `MAX(ciclo)` de un report_id *disminuya* con el tiempo. Es un problema de calidad de datos en la fuente (equipo de Data), no arreglable del todo desde el consumidor.

### Fix v2 (2026-09-16): congelar la fila completa del ciclo, no solo la fecha
- Tabla de control ampliada con TODAS las columnas agregadas a nivel (report_id, ciclo).
- Construcción de la tabla final cambiada de `LEFT JOIN` a `UNION ALL` de: (a) ciclos abiertos desde `_resultado` (detalle crudo), (b) TODOS los ciclos ya congelados desde la tabla de control. Así un ciclo cerrado nunca desaparece aunque la fuente pierda las filas que lo originaron.
- `etapa` de las filas congeladas se fija como `'Conexión a legalización'` (no un sentinel inventado) para compatibilidad con reportes downstream que dedupan filtrando por esa etapa.

### Root cause #5 — cobertura incompleta de motivos de descarte/apagado (fix: 2026-09-22)
`descartados_legalizacion` solo detectaba `bt_legalizacion.actividad = 'Descartados legalización'` exacto; `inicio_apagado` (apagado_1..8) tenía patrones de texto incompletos. Se agregaron: CTE `desistidos_legalizacion` (actividad = 'Desistidos'), y guard `apagado_2` (Créditos Suspendidos) para no marcar como apagado un negocio que luego se desembolsó (`AND fecha_desembolso IS NULL`).

---

## Sesión actual (2026-09-28/29): 3 fixes nuevos

### 1. `ciclo_vigente`, `negocio_descartado`, `fecha_descarte_negocio` (nuevas columnas)

**Problema detectado:** un negocio con varios ciclos (ej. `report_id 183004`) que terminó descartado en su ciclo más reciente, mostraba su(s) ciclo(s) anteriores como "no descartados" (porque cerraron por una devolución normal, no por descarte) — un consumidor que no supiera quedarse con `MAX(ciclo)` por `report_id` podía interpretar que el negocio seguía "por gestionar".

**Fix:** 3 columnas nuevas calculadas en la última etapa del script (aditivas, al final del schema, no tocan nada congelado):
- `ciclo_vigente` = `MAX(ciclo) OVER (PARTITION BY report_id)`.
- `negocio_descartado` (bool) — ver corrección de definición abajo.
- `fecha_descarte_negocio` — la fecha de descarte del ciclo vigente, propagada a TODAS las filas de ese `report_id` (así el ciclo 0 de 183004 muestra la misma fecha que su ciclo 1, sin tocar el `descartados_legalizacion` propio del ciclo 0, que sigue en NULL porque ahí no ocurrió el descarte).

**211 negocios** identificados con este mismo patrón (último ciclo descartado, ciclo(s) anterior(es) cerrados por devolución legítima) — todos verificados y corregidos.

**Corrección de la definición de `negocio_descartado` (importante, encontrada después):**
La primera versión definía `negocio_descartado` como "¿tiene `inicio_apagado` o `descartados_legalizacion` no nulo en el ciclo vigente?". Esto generaba **falsos positivos a escala de toda la tabla** (1,549 negocios): `inicio_apagado` es un `MAX()` histórico que no se limpia si el negocio pasó transitoriamente por un evento de apagado y luego **avanzó exitosamente** (se desembolsó, se aprobó, siguió en legalización). Se encontraron 830 "Desembolso", 156 "Aprobado", 122 "Legalización", 437 "Inmueble indefinido", 3 "Gestión comercial", 1 "En proceso de Radicación" marcados incorrectamente como descartados.

Decisión de negocio (confirmada con el usuario):
- **Inmueble indefinido** → NO es descarte, deben seguir contando como backlog activo por gestionar.
- **Desembolso, Aprobado, Legalización** → claramente no son descartes, se excluyen.

**Fix final:** `negocio_descartado` se basa ahora en el **estatus real vigente** (`homologated_status IN ('Descartado', 'Desistido')`), no en si alguna vez se disparó un `inicio_apagado`. Verificado tras el reabastecimiento: solo quedan `Descartado` (39,588) y `Desistido` (855) marcados — cero falsos positivos.

### 2. `fecha_fin_pre_legalizacion` contaba como "salida exitosa" negocios que en realidad se apagaron

**Problema:** el "null-guard" que anula `fecha_fin_pre_legalizacion` cuando coincide con la fecha de descarte solo comparaba contra 2 de las 8+ fuentes de descarte (`dl.inicio_actividad` de 'Descartados legalización' y `ds.inicio_actividad` de 'Desistidos'), nunca contra `apagado_1`...`apagado_8` (Créditos Apagados, Descartados en radicación, homologated_status='Descartado' genérico, etc.). Resultado: negocios apagados por esas otras vías se contaban simultáneamente como "salida exitosa" (porque `fecha_fin_pre_legalizacion` alimenta ese conteo).

**Impacto medido:** 447 casos históricos con `fecha_fin_pre_legalizacion` = fecha exacta del apagado. Desglose por mes (los que tienen mayor impacto):
- 2026-09: 86, 2026-08: 26, **2026-07: 143** (el mes con más casos — verificado como legítimo, incluye un lote de descartes del 27-jul), 2026-02: 40, 2025-11: 31, etc.
- Esto explica la diferencia que el usuario observó en agosto: 1004 → 978 salidas exitosas (número que además coincide con el ground-truth de la hoja "PRE LEGALIZADOS EN AGOSTO" usado en el fix original de root cause #2).

**Fix:** se amplió el `IF` en `pre_main` para también anular `fecha_fin_pre_legalizacion` cuando coincide con cualquiera de `apagado_1`...`apagado_8`:
```sql
IF(
  ppm.fecha_fin_pre_legalizacion = dl.inicio_actividad
  OR ppm.fecha_fin_pre_legalizacion = ds.inicio_actividad
  OR ppm.fecha_fin_pre_legalizacion IN (apagado_1, apagado_2, apagado_3, apagado_4, apagado_5, apagado_6, apagado_7, apagado_8),
  NULL,
  fecha_fin_pre_legalizacion
) AS fecha_fin_pre_legalizacion,
```
**Corrección retroactiva:** `UPDATE` de un solo uso sobre `bt_pre_legalizacion_cierres_congelados` (447 filas, `fecha_fin_pre_legalizacion = NULL` donde coincidía con el apagado). Verificado: 0 casos restantes tras la corrección.

**Nota importante:** de esos 447, **4 report_ids** (140613, 108863, 105069, 96283) quedaron con `negocio_descartado = false` — no es un error: la coincidencia corregida ocurrió en un ciclo intermedio, y el negocio avanzó después (2 llegaron a Desembolso, 2 siguen activos en Legalización). El fix se comportó correctamente.

### 3. Validación de la rotación (`rotacion_general_pre_legalizacion` / `_tipo_producto`)

Se confirmó que **no requieren ningún cambio**. Su lógica de ventana por ciclo (`entrada_finalizadas = COALESCE(fecha_fin_pre_legalizacion, inicio_apagado)`) ya delimita correctamente el cierre de cada ciclo sin importar la causa (descarte o devolución) — cada ciclo cuenta como "abierto" solo dentro de su propia ventana `[created_at, entrada_finalizadas]`, no depende de "cuál es el ciclo vigente". Verificado empíricamente tanto para el caso puntual (183004) como para los 211 y los 447.

Como el `SELECT` de estos procedimientos es explícito por columna (no `SELECT *`), las columnas nuevas (`ciclo_vigente`, `negocio_descartado`, `fecha_descarte_negocio`) no afectan estos procedimientos — simplemente las ignoran.

---

## Pendientes / no resuelto (para retomar si vuelve a surgir)

- **Root cause #3** (`duplicado_en_radicaci_n`): el filtro en sí sigue sin arreglarse de raíz, solo mitigado como efecto secundario.
- **Root cause #4** (ciclos inestables en la fuente `bt_prelegalizacion`): es un problema de calidad de datos del equipo de Data, no del query consumidor. Hay una query de evidencia (antes entregada al usuario) para detectar `FILA_BORRADA`/`FILA_RECLASIFICADA` comparando snapshots de time-travel — depende de la ventana de 7 días, hay que regenerar la fecha de referencia si se reutiliza.
- **Alertas de regresión de ciclo:** propuesto pero **explícitamente rechazado** por el usuario (no implementar salvo que lo pida de nuevo).
- **"Inmueble indefinido"** se dejó deliberadamente FUERA de `negocio_descartado` — confirmar con el usuario si esto cambia en el futuro.
- Los 4 casos (140613, 108863, 105069, 96283) son un buen ejemplo de qué esperar cuando una corrección retroactiva toca un ciclo que no es el vigente — no son error, pero vale la pena recordarlo si se hace otra corrección similar.

## Cómo verificar el estado actual de todo esto en el futuro

```sql
-- ¿Cuántos negocios tiene la tabla y cómo se distribuye negocio_descartado?
SELECT homologated_status, COUNT(DISTINCT report_id)
FROM `papyrus-delivery-data.habicredit.bt_pre_legalizacion_bi_new`
WHERE ciclo = ciclo_vigente AND negocio_descartado
GROUP BY 1;

-- ¿Sigue habiendo salidas "exitosas" que coinciden con un apagado?
SELECT COUNT(*)
FROM `papyrus-delivery-data.habicredit.bt_pre_legalizacion_bi_new`
WHERE fecha_fin_pre_legalizacion IS NOT NULL
  AND fecha_fin_pre_legalizacion = COALESCE(inicio_apagado, descartados_legalizacion);
```

Antes de asumir que algo de esto se rompió, revisar primero `bt_pre_legalizacion_cierres_congelados` para el report_id/ciclo en cuestión — una fila congelada es autoritativa sobre lo que `_resultado` calcule ahora mismo.
