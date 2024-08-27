// Importando a classe FiltroVoluntario
const voluntario = require('../model/Voluntario.js');
const disponibilidade = require('../model/Voluntario.js');
const dados = require('../model/Voluntario.js');
const projeto = require('../model/ProjetoSocial.js');

function filtrarVoluntario(req) {
    return new Promise((resolve, reject) => {
        /** Filtro com base nos parâmetros */
        voluntario.getFiltroVoluntario(req.body.filtroDiaSemana, req.body.voluntarioHorario, req.body.voluntarioHabilidades)
            .then(resultado => {
                if (Array.isArray(resultado) && resultado.length !== 0) {
                    // Se for um array, ou seja, tem mais de um voluntário que atende aos critérios do filtro
                    console.log('É Array: ', resultado);

            // Mapear o array `resultado` para obter as promessas dos dados dos voluntários
            var promises = resultado.map(item => dados.getVoluntario(item.username));

            Promise.all(promises)
                .then(elementos => {
                    // Associar cada elemento dos dados dos voluntários ao item correspondente em `resultado`
                    var dadosVoluntarios = resultado.map((item, index) => ({
                        username: item.username, // Pegar o username do item atual
                        Nome: elementos[index].nome,
                        Bio: elementos[index].biografia,
                        Contato: elementos[index].telefone
                    }));

                    resolve({
                        alerta: resultado.resposta, // Pode ser necessário verificar se 'resposta' está acessível
                        Voluntarios: dadosVoluntarios
                    });
                })
                .catch(error => {
                    // Lidar com erros, se necessário
                    console.error('Erro ao obter dados dos voluntários:', error);
                    reject(error);
                });                        
                } else {
                    console.log('Não é Array: ', resultado);
                    // Se não for um array, ou seja, somente um, ou nenhum, voluntário atende aos critérios do filtro
                
                    if(resultado === undefined || resultado.length === 0){
                        // Caso nenhum voluntário atendeu aos critérios
                        resolve({erro: 'Nenhum voluntário atendeu aos critérios. Tente executar um filtro diferente.'});
                    }else{
                        dados.getVoluntario(resultado.username)
                            .then(elemento => {
                                // Caso um voluntário atendeu aos critérios
                                var dadosVoluntarios = [{
                                    username: resultado.username,
                                    Nome: elemento.nome,
                                    Bio: elemento.biografia,
                                    Contato: elemento.telefone
                                }];
                                resolve({
                                    alerta: resultado.resposta,
                                    Voluntarios: dadosVoluntarios
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

async function voluntariarUsuario(req) {
    try {
        const resultadoSet = await voluntario.setVoluntario(req.session.user.username, req.body.volCPF, req.body.volNome, req.body.volNomeSocial, req.body.volBio, req.body.volTelefone, req.body.volCidNome);

        if (!resultadoSet.erro) {
            const resultadoHabilidade = await addHabilidade(req.session.user.username, req.body.voluntarioHabilidades);
            if (!resultadoHabilidade.erro) {
                if (Array.isArray(req.body.voluntarioDias)) {
                    for (const dia of req.body.voluntarioDias) {
                        const resultadoDisponibilidade = await addDisponibilidade(req.session.user.username, dia, req.body.voluntarioHorario);
                        if (resultadoDisponibilidade.erro) {
                            await dados.deleteVoluntario(req.session.user.username);
                            return { alerta: 'Não foi possível criar o voluntário' };
                        }
                    }
                } else {
                    const resultadoDisponibilidade = await addDisponibilidade(req.session.user.username, req.body.voluntarioDias, req.body.voluntarioHorario);
                    if (resultadoDisponibilidade.erro) {
                        await dados.deleteVoluntario(req.session.user.username);
                        return { alerta: 'Não foi possível criar o voluntário' };
                    }
                }

                return { alerta: 'O Voluntário foi adicionado com sucesso' };
            } else {
                await dados.deleteVoluntario(req.session.user.username);
                return { alerta: 'Não foi possível criar o voluntário' };
            }
        } else {
            await dados.deleteVoluntario(req.session.user.username);
            return { alerta: 'Não foi possível criar o voluntário' };
        }
    } catch (error) {
        console.error(error);
        throw error;
    }
}


async function addDisponibilidade(user, dia, turno){
    try{
    const resultado = await disponibilidade.setDisponibilidade(user, dia, turno);
    return resultado;
    } catch (error) { 
        throw error;
    }
}

async function addHabilidade(user, habilidades){
    try{
        const resultado = await disponibilidade.setHabilidade(user, habilidades);
        return resultado;
        } catch (error) { 
            throw error;
        }
}

 function recrutarVoluntario(req){
    return new Promise((resolve, reject) => {
        projeto.addVoluntario(req.body.username, req.session.projNome)
        .then(resultado => {
            resolve({
                alerta: resultado.resposta
            });
        })
        .catch(error => {
            reject(error);
        })
    });
 }

function listarVoluntarios(voluntarios){
    return new Promise((resolve, reject) => {
        /** Listar voluntarios do projeto atual*/
                if (Array.isArray(voluntarios)) {
                // Se for um array, ou seja, o usuario é gestor de mais de um projeto
                var promises = voluntarios.map(item => dados.getVoluntario(item.username));
                Promise.all(promises)
                .then(elementos => {
                    var dadosVoluntarios = elementos
                    .map(elemento => ({
                        Nome: elemento.nome,
                        Telefone: elemento.telefone
                    })
                );
                    resolve({
                        alerta: voluntarios.resposta,
                        Voluntarios: dadosVoluntarios
                    });
                })
                .catch(error => {
                    console.log(error);
                    reject(error);
                });
            } else {
                // Se não for um array, ou seja, o usuário é gestor de somente um, ou nenhum projeto
                if(voluntarios === undefined || voluntarios.length === 0){
                    // Caso o usuario não gere nenhum projeto
                    resolve({
                        erro: 'Não há voluntários nesse projeto.'
                    });
                }else{
                    dados.getVoluntario(voluntarios.username)
                    .then(elemento => {
                        // Caso o usuario seja gestor de apenas um projeto
                        var dadosVoluntarios = [{
                            Nome: elemento.nome,
                            Telefone: elemento.telefone
                        }];
                        resolve({
                            alerta: voluntarios.resposta,
                            Voluntarios: dadosVoluntarios
                        });
                    })
                    .catch(error => {
                        console.log(error);
                        reject(error);
                    })
                }
            }
    });
}

function exibirAreaVoluntario(req){
    return new Promise((resolve, reject) => {
        voluntario.getVoluntario(req.session.user.username)
        .then(voluntario => {
            if(voluntario.erro === 'ERRO: O voluntário indicado não existe.'){
                resolve({
                    // ele não é um voluntário: CASO 3
                    caso: 3
                });
            }else{
                if(!voluntario.erro){
                    // existe o voluntario, então vamos buscar os dados do projeto que ele está e retornar (isto é, se estiver em algum projeto)
                    dados.getProjetosVoluntario(req.session.user.username)
                    .then(dados => {
                        if(!dados.erro){
                            projeto.getProjetoSocial(dados.titulo)
                            .then(resultado => {
                                // ele está em um projeto e retornamos os dados deste projeto: CASO 1
                                resolve({
                                    caso: 1,
                                    ...resultado
                                });
                            })
                            .catch(error => {
                                resolve(error);
                            });
                        }else{
                            // o usuario não está em um projeto retorna o erro como veio do banco: CASO 2
                            resolve({
                                caso: 2,
                                erro: dados.erro
                            });
                        }
                    })
                    .catch(error => {
                        resolve(error);
                    });
                }else{
                    resolve({
                        alerta: 'Houve um erro interno no servidor.'
                    });
                }
            }
        })
        .catch(error => {
            reject(error);
        })
    });
}

function sairProjeto(req){
    return new Promise((resolve, reject) => {
        voluntario.exitProjeto(req.body.projNome, req.session.user.username)
        .then(resultado => {
            if(!resultado.erro){
                resolve({
                    alerta: resultado.resposta
                });
            }else{
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

function listarCidades(req){
    return new Promise((resolve, reject) => {
        voluntario.listCidades(req.params.estado)
        //voluntario.listCidades(req)
        .then(resultado => {
            if(!resultado.erro){
                resolve(resultado);
            }else{
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

function editarNomeSocial(req){
    return new Promise((resolve, reject) => {
        voluntario.editNomeSocial(req.session.user.username, req.body.volNomeSocial)
        .then(resultado => {
            if(!resultado.erro){
                resolve({
                    alerta: resultado.resposta
                });
            } else {
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

function editarBio(req){
    return new Promise((resolve, reject) => {
        voluntario.editBio(req.session.user.username, req.body.volBio)
        .then(resultado => {
            if(!resultado.erro){
                resolve({
                    alerta: resultado.resposta
                });
            } else {
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

function editarCidade(req){
    return new Promise((resolve, reject) => {
        voluntario.editCidade(req.session.user.username, req.body.volCidNome)
        .then(resultado => {
            if(!resultado.erro){
                resolve({
                    alerta: resultado.resposta
                });
            } else {
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

function editarTelefone(req){
    return new Promise((resolve, reject) => {
        voluntario.editTelefone(req.session.user.username, req.body.volTelefone)
        .then(resultado => {
            if(!resultado.erro){
                resolve({
                    alerta: resultado.resposta
                });
            } else {
                resolve({
                    erro: resultado.erro
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

module.exports = {  filtrarVoluntario, voluntariarUsuario, recrutarVoluntario, listarVoluntarios,
                    exibirAreaVoluntario, sairProjeto, listarCidades, editarNomeSocial, editarBio,
                    editarCidade, editarTelefone };
