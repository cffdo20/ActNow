// Importando a classe ProjetoSocial
const projeto = require('../model/ProjetoSocial.js');
const dados = require('../model/ProjetoSocial.js');

function criarProjeto(req) {
    /** Criação do novo projeto*/
    projeto.setProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
        req.body.projJustificativa, req.body.projObjetivos, req.body.projDataInicio, '1', '1');

    if (projeto.erro) {
        return {
            status: 'ERRO',
            mensagem: projeto.erro,
        }
    } else {
        dados.getProjetoSocial(req.body.projNome);
        return {
            status: 'SUCESSO',
            mensagem: projeto.resposta,
            dados: dados
        }
    }
}

module.exports = { criarProjeto };

