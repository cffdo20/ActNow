// Importando a classe Usuario
const usuario = require('../model/Usuario.js');
const dados = require('../model/Usuario.js');

// CREAT
function criarUsuario(req) {
  return new Promise((resolve, reject) => {
    /** Criação do novo usuario*/
    usuario.setUsuario(req.body.userName, req.body.userSenha, req.body.userEmail)
      .then(resultado => {
        if (resultado.erro !== undefined) {
          // Se houver um erro na resposta, apenas envia a resposta
          resolve(resultado);
        } else {
          // Caso contrário, busca os dados do usuario recém-criado e depois envia a resposta e os dados do usuario
          dados.getUsuario(req.body.userName).then(elementos => {
            resolve({ alerta: resultado.resposta });
          })
        }
      })
  });
}

// UPDATE
function alterarSenhaUsuario(req) {
  return new Promise((resolve, reject) => {
    /** Editar um projeto*/
    usuario.updateSenhaUsuario(req.body.projNome, req.body.projDescricao)
      .then(resultado => {
        if (resultado.erro !== undefined) {
          // Se houver um erro na resposta, apenas envia a resposta.
          resolve(resultado);
        } else {
          dados.getProjetoSocial(req.body.projNome).then(elementos => {
            console.log(req.body.projNome);
            resolve({
              Titulo: elementos.titulo,
              Descricao: elementos.descricao,
              Publico: elementos.publico,
              Justificativa: elementos.justificativa,
              Objetivos: elementos.objetivos,
              Inicio: elementos.inicio
            });
          })
        }
      })
  });
}

module.exports = { criarUsuario, alterarSenhaUsuario};