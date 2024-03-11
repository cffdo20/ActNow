// Importando a classe ProjetoSocial
const projeto = require('../model/ProjetoSocial.js');

function criarProjeto(req) {
    // Converter a Data para String
    const data = new Date();
    var dataInicioProj = data.toISOString(req.body.projDataInicio).split('T')[0];
    console.log(dataInicioProj);

    /** Criação do novo projeto*/
    return projeto.setProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
        req.body.projJustificativa, req.body.projObjetivos, dataInicioProj, '1', '1');
}

module.exports = { criarProjeto };

