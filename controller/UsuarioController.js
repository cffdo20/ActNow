// Importando a Classe Usuario
const Usuario = require('../model/Usuario.js');

function gerarUsuarioExemplo(){
    return usuarioExemplo = new Usuario(1, 'user123', 'user123@example.com', null);
}

module.exports = {gerarUsuarioExemplo}