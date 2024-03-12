// Importando a classe ProjetoSocial
const projeto = require('../model/ProjetoSocial.js');
const dados = require('../model/ProjetoSocial.js');

function criarProjeto(req) {
    return new Promise((resolve, reject) => {
        /** Criação do novo projeto*/
        projeto.setProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
            req.body.projJustificativa, req.body.projObjetivos, req.body.dataInicioProj, '1', '1')
            .then(resultado => {
                if (resultado.erro !== undefined) {
                    // Se houver um erro na resposta, apenas envia a resposta
                    resolve(resultado);
                } else {
                    // Caso contrário, busca os dados do projeto recém-criado e depois envia a resposta e os dados do projeto
                    dados.getProjetoSocial(req.body.projNome).then(elementos => {
                        resolve({
                            alerta: resultado.resposta,
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



module.exports = { criarProjeto };