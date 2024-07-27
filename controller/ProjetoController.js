// Importando a classe ProjetoSocial
const projeto = require('../model/ProjetoSocial.js');
const dados = require('../model/ProjetoSocial.js');

// CRUD de Projetos
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

function editarProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.updateProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
            req.body.projJustificativa, req.body.projObjetivos, req.body.dataInicioProj)
            .then(resultado => {
                if (resultado.erro !== undefined) {
                    // Se houver um erro na resposta, apenas envia a resposta.
                    resolve(resultado);
                } else {
                    // Caso contrário, busca os dados do projeto recém-editado e depois envia a resposta e os dados do projeto
                    resolve({
                        alerta: resultado.resposta,
                        Titulo: resultado.titulo,
                        Descricao: resultado.descricao,
                        Publico: resultado.publico,
                        Justificativa: resultado.justificativa,
                        Objetivos: resultado.objetivos,
                        Inicio: resultado.inicio
                    });
                }               
            })
    });
}


function listarProjetos(req){
    return new Promise((resolve, reject) => {
        /** Listar projeto do usuario atual*/
        projeto.listProjetoSocial('ashleywhite') // Depois tem que trocar pelo username de usuário da sessão
            .then(resultado => {
                if (Array.isArray(resultado)) {
                    // Se for um array, ou seja, o usuario é gestor de mais de um projeto
                    console.log('É Array: ' + resultado);
                    var promises = resultado.map(item => dados.getProjetoSocial(item.titulo));

                    Promise.all(promises)
                        .then(elementos => {
                            var dadosProjetos = elementos.map(elemento => ({
                                Titulo: elemento.titulo,
                                Descricao: elemento.descricao,
                                Publico: elemento.publico,
                                Justificativa: elemento.justificativa,
                                Objetivos: elemento.objetivos,
                                Inicio: elemento.inicio
                            }));

                            resolve({
                                alerta: resultado.resposta,
                                Projetos: dadosProjetos
                            });
                        })
                        .catch(error => {
                            reject(error);
                        });
                } else {
                    console.log('Não é Array: ' + resultado);
                    // Se não for um array, ou seja, o usuário é gestor de somente um, ou nenhum projeto
                
                    if(resultado === undefined || resultado.length === 0){
                        // Caso o usuario não gere nenhum projeto
                        resolve({erro: 'Usuário não é gestor de nenhum projeto. Sinta-se livre para criar seu projeto.'});
                    }else{
                        dados.getProjetoSocial(resultado.titulo)
                            .then(elemento => {
                                // Caso o usuario seja gestor de apenas um projeto
                                var dadosProjetos = [{
                                    Titulo: elemento.titulo,
                                    Descricao: elemento.descricao,
                                    Publico: elemento.publico,
                                    Justificativa: elemento.justificativa,
                                    Objetivos: elemento.objetivos,
                                    Inicio: elemento.inicio
                                }];
                                resolve({
                                    alerta: resultado.resposta,
                                    Voluntarios: dadosProjetos
                                });
                            })
                            .catch(error => {
                                reject(error);
                            });
                        }
                    }
                })
                .catch(error => {
                    reject(error);
                });
    });
}

module.exports = { criarProjeto , listarProjetos, editarProjeto};