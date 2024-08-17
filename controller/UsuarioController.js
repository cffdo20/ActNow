// Importando a classe Usuario
const usuario = require('../model/Usuario.js');

// CREAT
function criarUsuario(req) {
  return new Promise((resolve, reject) => {
    usuario.setUsuario(req.body.userName, req.body.userSenha, req.body.userEmail)
      .then(resultado => {
        resolve({
          alerta: resultado.resposta
        });
      })
      .catch(error => {
        reject(error)
      })
  });
}

// READ
function verDadosUsuario(req){
  return new Promise((resolve, reject) => {
    usuario.getUsuario(req.session.user.username)
    .then(resultado =>{
      if(resultado.erro !== undefined){
        resolve(resultado.erro)
      }else{
        resolve({
          userName: resultado.username,
          userEmail: resultado.e-mail
        })
      }
    })
    .catch(error =>{
      reject(error)
    });
  });
}

// UPDATE
function alterarSenhaUsuario(req) {
  return new Promise((resolve, reject) => {
    usuario.updateSenhaUsuario(req.session.user.username, req.body.userSenha)
    .then(resultado => {
      resolve({
        alerta: resultado.resposta
      });  
    })
    .catch(error => {
      reject(error)
    })
  })
}

function alterarEmailUsuario(req) {
  return new Promise((resolve, reject) => {
    usuario.updateEmailUsuario(req.session.user.username, req.body.userEmail)
    .then(resultado => {
      resolve({
        alerta: resultado.resposta
      })
    })
    .catch(error => {
      reject(error)
    })
  });
}

// DELETE
function inativarUsuario(req){
  return new Promise((resolve, reject) => {
    usuario.deleteUsuario(req.session.user.username)
    .then(resultado => {
      if(resultado.erro !== undefined){
        resolve(resultado.erro)
      }else{
        resolve({
          alerta: resultado.resposta
        })
      }
    })
    .catch(error => {
      reject(error)
    })
  });
}

module.exports = { criarUsuario, verDadosUsuario, alterarSenhaUsuario, alterarEmailUsuario, inativarUsuario};