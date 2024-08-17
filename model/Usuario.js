const bd = require('./db.js');

function setUsuario(userName, userSenha, userEmail) {
  let parametros = [userName, userSenha, userEmail];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_usuario', parametros)
  .then(consulta => {
    return consulta[0][0];
  })
}

function getUsuario(userName) {
  let parametros = [userName];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_usuario', parametros)
  .then(consulta => {
    return consulta[0][0];
  })
}

function getUsuarioByEmail(userEmail) {
  return bd.callProcedureWithParameter('sp_buscar_username_usuario', [userEmail])
  .then(consulta => {
    return consulta[0][0];
  })
}

function updateSenhaUsuario(userName, userSenha) {
  let parametros = [userName, userSenha];
  return bd.callProcedureWithParameter('sp_alterar_senha_usuario', parametros)
  .then(consulta => {
    return consulta[0][0];
  })
}

function updateEmailUsuario(userName, userEmail) {
  let parametros = [userName, userEmail];
  return bd.callProcedureWithParameter('sp_alterar_email_usuario', parametros)
  .then(consulta => {
    return consulta[0][0];
  })
}

function deleteUsuario(userName){
  return bd.callProcedureWithParameter('sp_inativar_usuario', userName)
  .then(consulta => {
    return consulta[0][0];
  })
}

module.exports = { getUsuario, getUsuarioByEmail, setUsuario, updateSenhaUsuario, updateEmailUsuario, deleteUsuario };