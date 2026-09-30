# Plantillas — Capa de Contexto y Semántica HabiCredit

Estas tres plantillas cubren los tres tipos de conocimiento que normalmente están dispersos en los proyectos (comisiones, devoluciones, backlog, main_board): **entidades**, **métricas** y **reglas de negocio**. Usa YAML porque es liviano, legible y fácil de "chunkear" si más adelante alimenta un pipeline de RAG.

Convención de nombres de archivo sugerida:
- `entidades/broker.md`
- `metricas/pct_devoluciones.md`
- `reglas/RN-CO-001_anti_join_desistidos_co.md` (el nombre empieza con el `rule_id`)

IDs de reglas por país: `RN-CO-###` para Colombia y `RN-MX-###` para México. La numeración de cada país es independiente y consecutiva: una regla nueva toma el siguiente número libre de su país. Todos los proyectos son de Colombia excepto las comisiones de México (`comisiones_HC-MX`).

---

## 1. Plantilla de Entidad

```yaml
entity: ""                 # nombre canónico, ej. "Broker"
aliases: []                # otros nombres usados en distintos proyectos
domain: ""                 # ej. Comisiones, Devoluciones, Backlog, Main Board
market: []                 # países/mercados donde aplica, ej. ["CO"], ["MX"], ["CO", "MX"]
description: >
  # definición de negocio en 2-4 líneas, sin jerga de código
grain: ""                  # qué representa una fila / nivel de granularidad
source_tables:
  - project.dataset.table
key_attributes:
  - name: ""
    description: ""
relationships:
  - related_entity: ""
    relationship: ""       # ej. "un broker tiene muchos analistas"
business_rules_ref: []     # ids de reglas de negocio relacionadas (ver plantilla 3)
owner: ""
last_reviewed: ""          # YYYY-MM-DD
source_project: ""         # de qué proyecto/chat salió esta definición
```

---

## 2. Plantilla de Métrica

```yaml
metric: ""                 # nombre canónico, ej. "% Devoluciones"
aliases: []
domain: ""
market: []                 # países/mercados donde aplica, ej. ["CO"], ["MX"], ["CO", "MX"]
regional_variant_of: ""    # si esta métrica es una variante de otra ya definida
                            # para otro mercado, referencia su archivo aquí
description: >
  # qué mide y por qué le importa al negocio (1-3 líneas)
formula_business: ""       # definición en lenguaje de negocio,
                            # ej. "% de créditos desembolsados que luego se devuelven"
formula_sql: |
  -- fragmento de referencia, no el query completo del proyecto
grain: ""                  # a qué nivel se calcula: por día, por analista, por cohorte...
filters_exclusions: ""     # ej. "excluye semanas inmaduras (<15 días desde desembolso)"
source_tables:
  - project.dataset.table
owner: ""
last_reviewed: ""
source_project: ""
known_caveats: ""          # ej. "volatilidad por pipeline lag, discutido con CEO"
```

---

## 3. Plantilla de Regla de Negocio / Lógica

```yaml
rule_id: ""                # identificador único con país, ej. "RN-CO-001" o "RN-MX-001"
name: ""                   # nombre corto, ej. "Anti-join de desistidos"
domain: ""
market: []                 # países/mercados donde aplica, ej. ["CO"], ["MX"], ["CO", "MX"]
description: >
  # en qué consiste la regla, en lenguaje de negocio
applies_to: []              # entidades o métricas afectadas
logic_summary: ""          # resumen de la lógica sin código
sql_reference: |
  -- fragmento de referencia
exceptions: ""              # casos que NO aplican esta regla
owner: ""
last_reviewed: ""
source_project: ""
```

---

## Manejo de variantes por país/mercado (ej. comisiones_HC-app vs comisiones_HC-MX)

Cuando el mismo concepto de negocio existe en más de un país, la regla de decisión es:

- **¿Solo cambian valores o parámetros** (moneda, montos de meta, umbrales), pero la lógica y el nombre significan lo mismo en ambos países? → **Un solo archivo**, con `market: ["CO", "MX"]`, y las diferencias de parámetro anotadas en `known_caveats` (métricas) o `exceptions` (reglas). Ej.: "Broker" probablemente es el mismo concepto en ambos mercados.

- **¿La lógica de cálculo, el grano o la estructura regulatoria son distintos** (no solo el número, sino el cómo)? → **Dos archivos separados**, cada uno con su `market` correspondiente, y uno referencia al otro con `regional_variant_of` para que quede explícito que son primos, no gemelos. Ej.: si el esquema de tiers de comisión en México sigue reglas fiscales distintas a Colombia, son métricas separadas aunque compartan nombre de negocio.

Ante la duda, separa primero y fusiona después — es más fácil unir dos definiciones que resultaron idénticas que separar una que asumiste compartida y no lo era. Siempre deja explícita la moneda (COP/MXN) en cualquier métrica que involucre montos, aunque el resto de la lógica sea idéntica.

---

## Notas de uso

- **Una definición no se borra al actualizarse**: si cambia, agrega una línea de historial abajo del bloque YAML en vez de sobreescribir en silencio. Esto importa porque un agente de IA puede necesitar saber "esto cambió el DD/MM, antes era X".
- **`source_project` es clave**: te permite rastrear de qué proyecto/chat salió cada definición, útil cuando encuentres conflictos entre proyectos y necesites decidir cuál prevalece.
- **No copies el chat completo**: extrae solo la definición ya limpia. El chat original queda como referencia, no como contenido de la capa.
- **Para BigQuery**: una vez estas definiciones estén estables, refleja `description` (de entidad y métrica) también como `description` de tabla/columna en BigQuery — así la semántica queda embebida en el metadata, no solo en un archivo aparte.
