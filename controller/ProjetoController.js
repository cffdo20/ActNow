// Importando a classe ProjetoSocial
const projeto = require('../model/ProjetoSocial.js');
const dados = require('../model/ProjetoSocial.js');

// CREAT
function criarProjeto(req) {
    return new Promise((resolve, reject) => {
        /** Criação do novo projeto*/
        projeto.setProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
            req.body.projJustificativa, req.body.projObjetivos, req.body.dataInicioProj, 'ashleywhite')
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

// UPDATE
function editarDescProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.updateProjeto_descricao(req.body.projNome, req.body.projDescricao)
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

function editarPublProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.updateProjeto_publico(req.body.projNome, req.body.projPublico)
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

function editarJustProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.updateProjeto_justificativa(req.body.projNome, req.body.projJustificativa)
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

function editarObjeProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.updateProjeto_objetivos(req.body.projNome, req.body.projObjetivos)
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


function listarProjetos(req){
    return new Promise((resolve, reject) => {
        /** Listar projeto do usuario atual*/
        projeto.listProjetoSocial('ashleywhite') // Depois tem que trocar pelo username de usuário da sessão
            .then(resultado => {
                console.log(resultado);
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
                                    Projetos: dadosProjetos
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

function exibirProjeto(req) {
    return new Promise((resolve, reject) => {
                    // Caso contrário, busca os dados do projeto recém-criado e depois envia a resposta e os dados do projeto
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
    });
}

function inativarProjeto(req){
    return new Promise((resolve, reject) => {
        /** Editar um projeto*/
        projeto.deleteProjeto(req.body.projNome)
            .then(resultado => {
                    resolve(resultado);              
            })
    });
}

module.exports = { criarProjeto , listarProjetos, editarDescProjeto, exibirProjeto, editarPublProjeto, editarJustProjeto, editarObjeProjeto, inativarProjeto};