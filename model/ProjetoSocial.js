const { editarProjeto } = require('../controller/ProjetoController.js');
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

function listProjetoSocial(userName){
  let parametros = [userName];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_projetos_usuario', parametros).then(consulta => {
    return consulta[0];
  })
}

function updateProjeto_descricao(tituloProj, descricaoProj){
  let parametros = [tituloProj, descricaoProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_alterar_descricao_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

function updateProjeto_publico(tituloProj, publicoAlvoProj){
  let parametros = [tituloProj, publicoAlvoProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_alterar_publico_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

function updateProjeto_justificativa(tituloProj, justificativaProj){
  let parametros = [tituloProj, justificativaProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_alterar_justificativa_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

function updateProjeto_objetivos(tituloProj, objetivosProj){
  let parametros = [tituloProj, objetivosProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_alterar_objetivos_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

function deleteProjeto(tituloProj){
  let parametros = [tituloProj];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_inativar_projeto', parametros).then(consulta => {
    return consulta[0][0];
  })
};

module.exports = { setProjetoSocial , getProjetoSocial , listProjetoSocial, updateProjeto_descricao, updateProjeto_publico, updateProjeto_justificativa, updateProjeto_objetivos, deleteProjeto};