const bd = require('./db.js');

function setProjetoSocial(tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, codUsuCriador) {
  // Converter a Data para String
  const data = new Date();
  const dataInicio = data.toISOString(dataInicioProj).split('T')[0];
  console.log(dataInicio);
  let parametros = [tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicio, '1', codUsuCriador];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
}

function getProjetoSocial(tituloProj){
  let parametros = [tituloProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

module.exports = { setProjetoSocial , getProjetoSocial };