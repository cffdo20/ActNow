const bd = require('./db.js');

function setUsuario(userName, userSenha, userEmail) {
  let parametros = [userName, userSenha, userEmail];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_usuario', parametros).then(consulta => {
    return consulta[0][0];
  })
}

function getUsuario(userName) {
  let parametros = [userName];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_usuario', parametros).then(consulta => {
    return consulta[0][0];
  })
};

function updateSenhaUsuario(userName, userSenha) {
  let parametros = [userName, userSenha];
  return bd.callProcedureWithParameter('sp_alterar_senha_usuario', parametros).then(consulta => {
    return consulta[0][0];
  })
}

module.exports = { getUsuario, setUsuario, updateSenhaUsuario };