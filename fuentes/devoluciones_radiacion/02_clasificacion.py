#!/usr/bin/env python3
"""
02_clasificacion.py — Paso 02 del pipeline (CLAUDE.md)

Pregunta que responde: #10 — dentro de `Política documental` (83,5% del volumen de
devoluciones tipificadas), ¿qué falló concretamente?

Fecha:  2026-08-13
Autor:  Claude (sesión Johhan Ramirez)

Desglosa `tipificacion_devolucion = 'Política documental'` en categorías
multi-etiqueta a partir de `comentario_devolucion`.

Método: clasificador léxico (reglas sobre texto normalizado sin acentos). No se usó
un LLM en línea porque el entorno no tiene credenciales de API. Las reglas se
calibraron contra 600 comentarios etiquetados por LLM; la exactitud por categoría
está en `VALIDACION.md` y se reproduce con `03_validacion.py`.

Actualización 2026-08-31: fuente reemplazada por `data_20260831.xlsx` (ver
DICCIONARIO.md e Iteración 3 de BITACORA.md). Ese pull trae comentario en 4.056 de
las 4.583 filas de `Política documental` que antes no tenían texto, así que la
cobertura sube fuerte respecto a la corrida de la Iteración 2. Salida a archivo
dueño de fecha (`documental_categorizado_20260831.xlsx`) para no perder el
resultado de la Iteración 2, que sigue siendo válido como snapshot de su momento.

Salida: `documental_categorizado_20260831.xlsx` con la columna
`categorias_documentales` (lista) y `categoria_primaria`.
"""

import json
import re
import unicodedata

import pandas as pd

FUENTE = "data_20260831.xlsx"
SALIDA = "documental_categorizado_20260831.xlsx"
TIPIFICACION_OBJETIVO = "Política documental"

FALTANTE = "Faltantes documentales del cliente"
ILEGIBLE = "Documentos ilegibles"
FORMULARIO = "Errores en el diligenciamiento de formularios"
VENCIDO = "Documento vencido o desactualizado"
INCONSISTENCIA = "Inconsistencia en la información"
# Las tres siguientes NO son fallas documentales. Salieron del texto: una parte de lo
# tipificado como 'Política documental' no lo es. Se etiquetan aparte en vez de
# esconderlas en 'Otros' porque implican una acción distinta (ver RECOMENDACIONES.md).
TRAMITE = "Trámite o gestión del caso"
POLITICA = "Política o condiciones del crédito"
# Agregada en la recalibración 2026-08-31 (ver BITACORA.md Iteración 5): comentarios
# que son código/jerga interna del banco pegada tal cual (SOI, BPP, SARLAFT, códigos
# "NNN.N", iniciales de analista), sin una oración que explique la causa. Aparecía
# ~15% de una lectura de 45 casos de 'Otros' y ninguna regla existente la cubría.
BANCO_INTERNO = "Código o jerga interna del banco (sin narrativa)"
OTROS = "Otros"
SIN_COMENTARIO = "Sin comentario"

# Orden de desempate para `categoria_primaria` cuando el comentario trae varias
# causas y ninguna domina por conteo de coincidencias. Las causas documentales van
# primero: si un comentario mezcla un faltante con un tema de trámite, el faltante
# es lo que el broker puede prevenir.
PRIORIDAD = [
    FALTANTE,
    FORMULARIO,
    VENCIDO,
    INCONSISTENCIA,
    ILEGIBLE,
    TRAMITE,
    POLITICA,
    BANCO_INTERNO,
    OTROS,
]

DOCUMENTALES = [FALTANTE, FORMULARIO, VENCIDO, INCONSISTENCIA, ILEGIBLE]

REGLAS = {
    ILEGIBLE: r"""
        ilegib | legible | borros | mala\s+calidad | baja\s+calidad | mejor\s+calidad
      | no\s+se\s+(?:alcanza\s+a\s+)?(?:leer|lee) | no\s+se\s+logra\s+(?:leer|visualizar)
      | no\s+se\s+(?:visualiza|observa|distingue|aprecia)
      | ampliad?[ao]?\s+al\s+150 | ampliar\s+al\s+150 | 150\s*%
      | (?:ambas|dos)\s+caras | una\s+sola\s+hoja | por\s+ambos\s+lados
      | escane | nitid | difus | pixel | calidad\s+de\s+(?:la\s+)?imagen
      | (?:mas|sea|ser|este|queden?)\s+clar | recortad | \bcortad
      | foto\s+(?:del|de\s+la) | se\s+encuentra\s+ilegible
    """,
    VENCIDO: r"""
        vencid | no\s+mayor\s+a\s+\d+ | mayor\s+a\s+\d+\s+dias | superior\s+a\s+\d+\s+dias
      | no\s+superior\s+a | desactualiz | no\s+(?:se\s+encuentra\s+)?vigente
      | fuera\s+de\s+vigencia | \bvigencia\b
      | actualiz | renovar | expedid[oa]\s+(?:hace|con) | reciente\s+expedicion
    """,
    INCONSISTENCIA: r"""
        inconsist | no\s+coincid | no\s+concuerd | no\s+corresponde | no\s+corresponden
      | no\s+cruza | no\s+cuadra | difiere | diferencia | diferente\s+a
      | distint[oa]\s+a | discrepanc | contradic | mal\s+digitad
      | error\s+de\s+digitacion | digitad[oa]\s+mal | errad[oa] | equivocad
      | incorrect | no\s+es\s+el\s+mismo | no\s+son\s+iguales | dato\s+err | datos\s+err
      | no\s+justifica | no\s+soporta | no\s+se\s+refleja | \bvariacion\b
    """,
    # `solicitud de credito` y `perfil` a secas se sacaron: la primera aparece en el
    # encabezado boilerplate ("Su solicitud de crédito fue DEVUELTA") y la segunda
    # designa tanto el formulario como el perfil de riesgo. Ambas hundían la precisión.
    FORMULARIO: r"""
        diligenci | sin\s+llenar | formulario | formato(?!\s+(?:pdf|digital|excel|word))
      | \bsipla\b | conocimiento\s+del\s+cliente | autorizacion\s+de\s+consulta
      | carta\s+de\s+beneficios | \bplanilla\b | perfil\s+(?:diligenciad|sin|mal|a\s+mano)
      | casilla | \bfirma\b | \bfirmas\b | sin\s+firmar | firmad | \bhuella | tachon
      | enmendadura | pu[nñ]o\s+y\s+letra
      | (?:campo|espacio)s?\s+(?:en\s+blanco|vacio|sin|no\s+diligenciad)
      | marcar\s+(?:la|el|con) | mal\s+marcad | sin\s+marcar | sobrepuest
    """,
    # Recalibración 2026-08-31: la segunda línea usaba infinitivos exactos
    # (`\badjuntar\b`) y se perdía "adjunte/adjunten/adjuntando", muy comunes en el
    # texto nuevo ("favor adjunte declaración de renta"). Se cambió a formas
    # conjugadas explícitas en vez de un stem libre para no matchear "aportante"
    # (rol, no acción) al abrir `aport`.
    FALTANTE: r"""
        \bfalta\b | \bfaltan\b | faltante | hace\s+falta | \bcarece
      | no\s+(?:\w+\s+){0,2}?(?:se\s+)?(?:adjunt|anex|aport|carg|remit|allega|suministr|relacion|especific)
      | sin\s+(?:adjuntar|anexar|el\s+soporte|soporte)
      | \badjunt(?:ar|e|en|ando)\b | \banex(?:ar|e|en|ando)\b
      | \baport(?:ar|e|en|ando)\b | \balleg(?:ar|ue|uen|ando)\b
      | \bsuministr(?:ar|e|en|ando)\b | \benv(?:iar|ie|ien|iando)\b
      | \bremit(?:ir|a|an|iendo)\b | \bcarg(?:ar|ue|uen|ando)\b | \bpendiente\b
      | se\s+(?:le\s+)?(?:solicita|solicitan|requiere|requieren|necesita|necesitan|pide|piden)
      | (?:solicita|solicitan|requiere|requieren)\s+(?:el|la|los|las|documento|carta|certificad|copia|soporte|antiguedad|extracto|declaracion)
      | (?:banco|area)\s+solicita | quedamos\s+a\s+la\s+espera | \bespera\s+de\b
      | completitud | documentacion\s+incompleta | errores?\s+en\s+la\s+document
      | no\s+se\s+logra\s+contact | ilocaliz
    """,
    # Recalibración 2026-08-31: se agregó "doble radicad", "radicado vigente",
    # "canal de referidos" y variantes de cliente ya gestionado por otro asesor/campaña
    # — aparecen recurrentes en comentarios nuevos que antes caían todos en Otros.
    TRAMITE: r"""
        no\s+(?:se\s+)?(?:avanz|finaliz|registra|aparece|refleja)
      | caso\s+digital | reproceso | no\s+hay\s+solicitud
      | (?:solicitud|radicacion)\s+(?:abierta|vigente|activa) | caso\s+abierto
      | en\s+el\s+link | \bplataforma\b | \bmantiz\b | pantallazo
      | duplicad | \bbuzon\b | crear\s+el\s+caso | volver\s+a\s+radicar
      | desistimient | se\s+cierra | \bcerrado\b | \bsistema\b
      | error\s+en\s+el\s+(?:sistema|aplicativo) | \baplicativo\b
      | doble\s+radicad | radicad[oa]\s+(?:vigente|por\s+oficina)
      | oficina\s+desist | canal\s+de\s+referidos | por\s+este\s+canal
      | campa[nñ]a\s+(?:cerrada|con\s+el\s+banco) | asesor\s+de\s+la\s+fuerza
      | caso\s+aprobado\s+con | otra\s+entidad\s+financiera | caduc
      | derecho\s+ciudad | zona\s+correspondiente | encargad[oa]\s+de\s+la\s+zona
    """,
    # Recalibración 2026-08-31: PEP, "incumple politicas", "condiciones de producto" y
    # "no procede" salían seguido en el vocabulario nuevo y son elegibilidad/crédito,
    # no documental.
    POLITICA: r"""
        \bburo\b | centrales\s+de\s+riesgo | seguridad\s+social
      | capacidad\s+de\s+(?:pago|endeudamiento) | politica[s]?\s+(?:del|de\s+la)\s+(?:banco|entidad)
      | no\s+cumple\s+(?:con\s+)?(?:la\s+)?(?:politica|antiguedad|el\s+perfil|buro|los\s+criterios)
      | \bscore\b | \bmora\b | endeudamiento | antiguedad\s+laboral
      | no\s+(?:es\s+)?viable | viabilidad | \btasa\b | \bplazo\b
      | menor\s+monto | monto\s+aprobado | \bcupo\b | subsidio
      | \bpep\b | persona\s+expuesta | incumple\s+politicas
      | condiciones\s+de\s+producto | no\s+procede | bases\s+internas
    """,
    # Nueva 2026-08-31: código/jerga interna del banco pegada sin narrativa
    # (`DICCIONARIO.md`). No se interpreta el código, solo se marca como tal.
    BANCO_INTERNO: r"""
        \b\d{3}\.\d\b | \bsoi\b | \bbpp\b | \bsarlaft\b | \bcifin\b | \bbonita\b
      | analisis\s+soi | verificacion\s+soi | no\s+aplica\s+referenciacion
      | referenciacion\s+cliente | validacion\s+documental\s+satisfactoria
      | vta\s+cruzada | venta\s+cruzada
    """,
    # Solo se usa para marcar "Otros" en co-ocurrencia con otras causas.
    OTROS: r"""
        avaluo | \bgarantia | estudio\s+de\s+titulos
      | (?:libertad|certificado)\s+(?:y\s+)?(?:de\s+)?tradicion | visto\s+bueno
      | leasing | compra\s+de\s+cartera
      | licencia\s+de\s+construc | \bpredial\b | \bescritur | \bembargo
    """,
}

COMPILADAS = {
    k: re.compile(v, re.VERBOSE | re.IGNORECASE) for k, v in REGLAS.items()
}


def normalizar(texto: str) -> str:
    """Minúsculas, sin acentos, espacios colapsados."""
    t = unicodedata.normalize("NFD", str(texto).lower())
    t = "".join(c for c in t if unicodedata.category(c) != "Mn")
    return " ".join(t.split())


def clasificar(comentario) -> tuple:
    """Devuelve (lista_de_categorias, categoria_primaria)."""
    if comentario is None or (isinstance(comentario, float)) or not str(comentario).strip():
        return [SIN_COMENTARIO], SIN_COMENTARIO

    t = normalizar(comentario)
    golpes = {cat: len(rx.findall(t)) for cat, rx in COMPILADAS.items()}
    todas = [c for c in PRIORIDAD if golpes.get(c, 0) > 0]

    # Sin ninguna coincidencia -> Otros puro. Es la métrica que vigila CLAUDE.md:
    # si esto supera el 12%, la taxonomía está incompleta.
    if not todas:
        return [OTROS], OTROS

    # OTROS y BANCO_INTERNO son tags de respaldo, no causas reales: sus palabras
    # gatillo (CIFIN, SARLAFT, avaluo, garantia...) aparecen igual dentro de
    # comentarios que ya tienen una causa real y clara, y ahí no aportan señal —
    # solo ruido. Recalibración 2026-08-31 (BITACORA Iteración 5): antes se
    # listaban como co-etiqueta siempre que la palabra apareciera, y la validación
    # contra los 600 comentarios nuevos mostró 6-15% de precisión para ambas por
    # esto exacto. Ahora solo se reportan cuando NINGUNA causa real coincidió.
    FALLBACK = (OTROS, BANCO_INTERNO)
    reales = [c for c in todas if c not in FALLBACK]
    if reales:
        maximo = max(golpes[c] for c in reales)
        primaria = next(c for c in PRIORIDAD if c in reales and golpes[c] == maximo)
        return reales, primaria

    if BANCO_INTERNO in todas:
        return [BANCO_INTERNO], BANCO_INTERNO
    return [OTROS], OTROS


def main():
    df = pd.read_excel(FUENTE, sheet_name=0)
    doc = df[df.tipificacion_devolucion.eq(TIPIFICACION_OBJETIVO)].copy()

    resultado = doc.comentario_devolucion.map(clasificar)
    doc["categorias_documentales"] = [r[0] for r in resultado]
    doc["categoria_primaria"] = [r[1] for r in resultado]
    doc["n_categorias"] = doc.categorias_documentales.map(len)

    salida = doc[
        [
            "radicacion_id",
            "fecha_de_radicado",
            "fecha_devolucion",
            "tipificacion_devolucion",
            "comentario_devolucion",
            "categorias_documentales",
            "categoria_primaria",
            "n_categorias",
        ]
    ].copy()
    # Formato de lista JSON: ["Documentos ilegibles", "Otros"]
    salida["categorias_documentales"] = salida.categorias_documentales.map(
        lambda xs: json.dumps(xs, ensure_ascii=False)
    )
    salida.to_excel(SALIDA, index=False)

    con_texto = doc[doc.categoria_primaria != SIN_COMENTARIO]
    n = len(con_texto)
    print(f"filas 'Política documental': {len(doc)}")
    print(f"  con comentario clasificable: {n}")
    print(f"  sin comentario:              {len(doc) - n}")
    print(f"\nCobertura por categoría (sobre {n} con comentario):")
    for cat in PRIORIDAD:
        m = con_texto.categorias_documentales.map(lambda xs: cat in xs).sum()
        print(f"  {cat:45s} {m:5d}  {100 * m / n:5.1f}%")

    solo_otros = int((con_texto.categorias_documentales.map(lambda xs: xs == [OTROS])).sum())
    print(f"\n'Otros' como única categoría: {solo_otros} ({100 * solo_otros / n:.1f}%)"
          f"  [umbral CLAUDE.md: 12%]")
    print(f"promedio de categorías por comentario: {con_texto.n_categorias.mean():.2f}")
    print(f"\nescrito -> {SALIDA}")


if __name__ == "__main__":
    main()
