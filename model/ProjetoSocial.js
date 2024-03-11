const bd = require('../BD/db.js');

function setProjetoSocial(tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, codUsuCriador) {
  var parametros = [tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, '1', codUsuCriador];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
}

function getProjetoSocial(tituloProj){
  // stub da função getProjetoSocial
};

module.exports = { setProjetoSocial };