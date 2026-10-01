// Limpieza previa a cada corrida de las rotaciones de radicación.
// Los procedimientos solo hacen INSERT, así que hay que borrar antes de volver a cargar
// o la tabla queda duplicada.
//
// Orden por rotación:  deleteQuery  ->  CALL del procedimiento

const deleteQuery_radicacion_aprobacion = `
  DELETE \`papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion\`
  WHERE fase = fase
  `;

const deleteQuery_mesa_salvamento = `
  DELETE \`papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento\`
  WHERE fase = fase
  `;


// ---------------------------------------------------------------------------
// Variante por fase, si alguna de estas tablas llega a guardar más de una fase
// (como rotacion_general_segregada). Borra solo la fase que se va a recargar.
// ---------------------------------------------------------------------------

const deleteQueryPorFase_radicacion_aprobacion = (fase) => `
  DELETE \`papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion\`
  WHERE fase = '${fase}'
  `;

const deleteQueryPorFase_mesa_salvamento = (fase) => `
  DELETE \`papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento\`
  WHERE fase = '${fase}'
  `;


// CALL correspondiente a cada rotación
const callQuery_radicacion_aprobacion = `
  CALL \`papyrus-delivery-data.habicredit.rotacion_general_radicacion_aprobacion\`(
    'mart.fecha_radicacion', 'mart.fecha_aprobacion', 'Rot. Radicacion Aprobacion')
  `;

const callQuery_mesa_salvamento = `
  CALL \`papyrus-delivery-data.habicredit.rotacion_general_mesa_salvamento\`(
    'fr.inicio_subproceso_mesa_salvamento', 'mart.fecha_aprobacion', 'Rot. Mesa Salvamento')
  `;
