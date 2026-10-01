# HIPOTESIS.md

Patrones observados que **no son hallazgos** (CLAUDE.md, regla 1). Cada uno necesita
validarse contra datos nuevos, una ventana temporal distinta, o confirmación de Ivan.

---

## H-01 · `radicacion_id` podría ser un contador secuencial de todas las radicaciones

**Fecha:** 2026-08-12 · **Estado:** sin validar

`radicacion_id` es un entero que va de 21.753 a 187.361 sobre 21.221 filas, y su
correlación de rangos con `fecha_de_radicado` es 0,9986. Si fuera un contador
secuencial sobre el universo de radicaciones (no solo las devueltas), el rango de IDs
daría un denominador aproximado y desbloquearía la pregunta #1.

**Evidencia en contra, ya observada:** los rangos de ID por trimestre se solapan
fuertemente. En 2023Q4 el mínimo es 21.753 y el máximo 70.030; en 2026Q2, mínimo
113.702 y máximo 178.405. Si el ID fuera un contador limpio, cada trimestre ocuparía
una banda casi disjunta. El solapamiento significa que hay radicaciones con ID viejo y
fecha nueva — reprocesos, reservas de rango, o un ID que no es lo que parece.

**Por qué no se usa:** aun sin esa evidencia, es exactamente el tipo de supuesto que
prohíbe la regla 2. Bastaría con que los IDs se compartan con otra entidad o que haya
saltos por migraciones para que la tasa resultante sea creíble y falsa.

**Cómo se valida:** Ivan confirma la semántica del ID, o se trae la tabla completa de
radicaciones — que es la solución buena de todas formas.

---

## H-02 · El corrimiento del mix hacia "Política documental" podría ser artefacto de captura

**Fecha:** 2026-08-12 · **Estado:** sin validar

`Política documental` pasa de 68,0% de las devoluciones tipificadas en 2025-09 a
89,9% en 2026-03, y se estabiliza cerca de 86%. En paralelo, `Politica interna del
banco` cae de 18,6% a ~7-9% y `Criterios mínimos de aceptación` de 9,9% a ~4-5%.

**Por qué no es un hallazgo:** el corrimiento ocurre durante el período en que el
campo terminó de adoptarse (de 43% nulo en 2025-06 a 3% en 2025-09, con rebotes hasta
20,5% en 2026-06). Un cambio en *quién* llena el campo, o en el orden de las opciones
de un desplegable, produce la misma curva que un cambio real en las causas de
devolución. Con un solo campo y sin registro de cambios de la herramienta no hay forma
de separarlos.

**Cómo se valida:** (a) Ivan confirma la fecha en que la tipificación se volvió
obligatoria y si cambió el catálogo de opciones; (b) se contrasta contra el texto
libre clasificado del Paso 02, que no depende del desplegable; (c) se revisa si el mix
se mantiene estable en la ventana 2026-01..2026-07, ya sin adopción en curso — en esos
7 meses documental se mueve entre 85,4% y 89,9%, que es plano.

---

## H-03 · Las 9 devoluciones con lag negativo y la de 917 días serían reprocesos

**Fecha:** 2026-08-12 · **Estado:** sin validar

9 filas tienen `fecha_devolucion` anterior a `fecha_de_radicado` (mínimo −2,97 días) y
una tiene un lag de 917,5 días. Volumen despreciable (0,05%), pero si el mecanismo es
"la radicación se re-crea y conserva la devolución vieja", entonces hay más filas
afectadas de forma no visible y el lag medido está sesgado.

**Cómo se valida:** Ivan revisa esos 10 `radicacion_id` en el sistema origen.
