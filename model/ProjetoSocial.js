const bd = require('../BD/db.js');

function setProjetoSocial(tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, codUsuCriador) {
  var parametros = [tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, '1', codUsuCriador];
  // Converter a Data para String
  const data = new Date();
  var dataInicioProj = data.toISOString(req.body.projDataInicio).split('T')[0];
  console.log(dataInicioProj);
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
}

function getProjetoSocial(tituloProj) {
  // stub da função getProjetoSocial
  return bd.callProcedureWithParameter('sp_consultar_projeto', tituloProj).then(consulta => {
    return consulta[0][0];
  })
}

module.exports = { setProjetoSocial, getProjetoSocial };