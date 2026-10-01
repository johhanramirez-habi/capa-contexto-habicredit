-- Tabla destino de la rotación Mesa de Salvamento.
-- salida_real = rescatado (aprobado), apagado = descartado. Son excluyentes, así que
--   salidas = salida_real + apagado

CREATE TABLE IF NOT EXISTS `papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento`
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
  apagado INT64
);
