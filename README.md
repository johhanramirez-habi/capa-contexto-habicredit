# capa-contexto-habicredit

> Guardar como `README.md` en la raíz de la carpeta/repositorio.

## Qué es esto

Repositorio de contexto de negocio y capa semántica de HabiCredit. Consolida entidades, métricas y reglas de negocio extraídas de los proyectos existentes (comisiones, devoluciones, backlog, main_board, etc.) en un formato único, versionado y legible tanto por humanos como por agentes de IA.

**No es** un repositorio de código productivo. No contiene lógica que se ejecute en un pipeline — es documentación estructurada que sirve de referencia para trabajar los proyectos reales y, eventualmente, para alimentar agentes de IA.

## Estructura

```
capa-contexto-habicredit/
├── README.md               ← este archivo
├── plantillas_capa_semantica_habicredit.md
├── fuentes/                 ← material fuente, uno por proyecto
│   ├── comisiones_HC-MX/              ← submódulo (comisiones-mx)
│   ├── comisiones_HC-app/             ← submódulo (comisiones_HC-app)
│   ├── bt_prelegelizacion_gold/       ← submódulo (HabiGlobal/dbt-cloud-habi-dlh)
│   ├── docs-wbr-reportes/             ← submódulo (HabiGlobal/docs-wbr-reportes)
│   ├── bt_pre_legalizacion/           ← carpeta sin repositorio propio
│   ├── devoluciones_radiacion/        ← carpeta sin repositorio propio
│   ├── migracion_reporte_bi/          ← carpeta sin repositorio propio
│   ├── rotacion_radicacion_aprobacion/← carpeta sin repositorio propio
│   └── documentos/                    ← documentos sueltos (ej. Habicredit_2024.docx)
├── entidades/               ← definiciones canónicas de entidades
├── metricas/                ← definiciones canónicas de métricas
├── reglas/                  ← reglas de negocio y lógica de excepciones
└── _index.md                ← catálogo: qué entidad/métrica/regla usa cada proyecto
```

## Principios de gobierno

1. **Una sola fuente de verdad por entidad/métrica/regla.** Si dos proyectos usan "broker" o "% devoluciones", existe una sola definición canónica en `entidades/` o `metricas/`. Los proyectos referencian, no duplican.

2. **`fuentes/` contiene los proyectos vivos como submódulos de git.** Cada proyecto con repositorio propio (comisiones, WBR, dbt, etc.) se enlaza como submódulo: la carpeta sigue siendo el proyecto de trabajo, desde donde se hace commit y push a su propio repo, y la capa solo registra el commit que usó. Toda definición indica en `source_project` el commit de la fuente de la que salió. Para volver a extraer tras cambios en un proyecto, se actualiza su puntero (`git add fuentes/<proyecto>`) en el mismo commit que las definiciones. El material sin repositorio (documentos, carpetas sueltas) se copia; nunca se mueve.

3. **Permisos de escritura acotados.** Cualquier agente (Claude Code u otro) que trabaje en tareas de extracción sobre esta carpeta:
   - Puede **leer** `fuentes/`. Durante una extracción, `fuentes/` es de solo lectura.
   - Solo puede **escribir** dentro de `entidades/`, `metricas/`, `reglas/`, `_index.md`.
   - Nunca modifica, commitea ni hace push en los proyectos de `fuentes/` como parte de una extracción. Solo lo hace si el usuario se lo pide explícitamente.

4. **La capa es referencia, no ley.** Si al trabajar en un proyecto existe una discrepancia entre su lógica y una definición global, el comportamiento por defecto es **reportar la discrepancia y preguntar**, no corregir el proyecto automáticamente para que "coincida" con la capa.

5. **Las excepciones se documentan, no se silencian.** Si un proyecto se desvía intencionalmente de una regla o métrica estándar, esa desviación se registra en el campo `exceptions`/`known_caveats` de la definición correspondiente, o en el `CLAUDE.md` del proyecto.

6. **Checkpoint antes de ejecutar.** Antes de correr cualquier prompt de extracción o modificación masiva sobre esta carpeta, hacer `git commit` del estado actual. Cualquier resultado no deseado se revierte, no se reconstruye a mano.

7. **Piloto antes de escalar.** La primera ejecución de extracción se hace sobre un solo proyecto (comisiones, el más maduro) antes de correr sobre los demás.

8. **Trazabilidad inversa obligatoria.** Toda entidad, métrica o regla debe registrar en `_index.md` qué proyecto(s) la usan, para saber qué se afecta si cambia.

9. **No inventar contenido.** Si el material fuente no da suficiente evidencia para llenar un campo de la plantilla, se deja explícito ("sin evidencia en el material fuente") en vez de inferir o completar con supuestos.

## Formato de las definiciones

Cada entidad, métrica y regla sigue la plantilla YAML fija en `plantillas_capa_semantica_habicredit.md`: nombre canónico, alias, dominio, descripción de negocio, fórmula/lógica, tablas fuente, dueño, fecha de última revisión, proyecto de origen, y excepciones/caveats conocidos.

## Para agentes de IA que trabajen en esta carpeta

Si estás leyendo esto como parte de una tarea de extracción o mantenimiento:
- Respeta los principios de gobierno de arriba, en especial los puntos 2, 3, 4 y 9.
- Si encuentras una definición existente y el nuevo material fuente la contradice, no la sobreescribas en silencio: agrega una nota de conflicto al final del archivo afectado y detente a preguntar antes de continuar.
- No generes definiciones especulativas para entidades, métricas o reglas que no tengan evidencia clara en el material fuente revisado.
