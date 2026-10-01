-- Tabla destino de la rotación Radicación -> Aprobación.
-- Mismo formato que habicredit.rotacion_general_pre_legalizacion, sin las columnas de
-- devolución ni apagado_tech, y con una columna extra 'negado'.
--
-- salida_real / apagado / negado son excluyentes entre sí, así que siempre se cumple
--   salidas = salida_real + apagado + negado

CREATE OR REPLACE TABLE `papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion`
(
  fecha_sync DATE,
  fase STRING,
  fecha DATE,
  inicial INT64,
  nuevas INT64,
  salidas INT64,
  inciales_primer_dia_mes INT64,
  inicial_semana INT64,
  salidas_semana INT64,
  rotacion_semana FLOAT64,
  salidas_mes INT64,
  rotacion_mes FLOAT64,
  salida_real INT64,
  apagado INT64,
  negado INT64
);
