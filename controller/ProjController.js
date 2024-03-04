// Importando a classe ProjetoSocial
const ProjetoSocial = require('../model/ProjetoSocial.js');

function criarProjeto(usuario, tituloProj, descricaoProj,
    publicoAlvoProj, justificativaProj, objetivosProj,
    dataInicioProj, statusProj) {

    // Converter a Data
    this.dataInicioProj = new Date(dataInicioProj);

    // Aqui vem a função que buscará no banco de dados qual o próximo id disponível, por enquanto será setado sempre como '1'
    let idProjeto = 1;

    // Criação do novo projeto
    var novoProjeto = new ProjetoSocial(idProjeto, tituloProj, descricaoProj, publicoAlvoProj,
        justificativaProj, objetivosProj, this.dataInicioProj, statusProj);
    
    //Adicionar o usuário como gestor do projeto
    novoProjeto.adicionarGestorProj(usuario);
    
    return novoProjeto;
}

module.exports = {criarProjeto};
