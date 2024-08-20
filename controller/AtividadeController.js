const atividade = require('../model/Atividade.js');

// CREATE
function cadastrarAtividade(req){
    return new Promise((resolve, reject) => {
        atividade.setAtividade(req.body.tituloAtividade, req.body.descricaoAtividade, req.body.dataEntregaAtividade, req.body.projNome)
        .then(resultado => {
            if(resultado.erro !== undefined){
                resolve(resultado);
            }else{
                resolve({
                    alerta: resultado.resposta
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

// READ
function listarAtividades(req){
    return new Promise((resolve, reject) => {
        atividade.listAtividades(req.body.projNome)
        .then(resultado => {
            if(resultado !== undefined){
                resolve(resultado);
            }else{
                resolve({
                    alerta: resultado.resposta
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

// UPDATE
function editarAtividade(req) {
    return new Promise((resolve, reject) => {
        atividade.listAtividades(req.body.projNome)
            .then(resultado => {
                const atividadeEncontrada = resultado.find(atividade => atividade.titulo === req.body.tituloAtividade);

                if (atividadeEncontrada) {
                    const promises = [];

                    if (atividadeEncontrada.descricao !== req.body.descricaoAtividade) {
                        promises.push(alterarDescricaoAtividade(req));
                    }

                    if (atividadeEncontrada.Entrega !== req.body.dataEntregaAtividade) {
                        promises.push(alterarDataEntrega(req));
                    }

                    if (promises.length > 0) {
                        Promise.all(promises)
                            .then(() => resolve({ alerta: 'Atividade alterada com sucesso' }))
                            .catch(error => reject(error));
                    } else {
                        resolve({ alerta: 'Não houve alteração nos dados da atividade' });
                    }
                } else {
                    resolve({ alerta: 'Atividade não encontrada' });
                }
            })
            .catch(error => {
                reject(error);
            });
    });
}



function alterarDataEntrega(req){
    return new Promise((resolve, reject) => {
        atividade.editarDataAtividade(req.body.tituloAtividade, req.body.projNome, req.doby.dataEntregaAtividade)
        .then(resultado => {
            if(resultado.erro !== undefined){
                resolve(resultado);
            }else{
                resolve({
                    alerta: resultado.resposta
                });
            }
        }).catch(error => {
            reject(error);
        });
    });
}

function alterarDescricaoAtividade(req){
    return new Promise((resolve, reject) => {
        atividade.editarDescAtividade(req.body.tituloAtividade, req.body.projNome, req.doby.descricaoAtividade)
        .then(resultado => {
            if(resultado.erro !== undefined){
                resolve(resultado);
            }else{
                resolve({
                    alerta: resultado.resposta
                });
            }
        }).catch(error => {
            reject(error);
        });
    });
}

// DELETE
function inativarAtividade(req){
    return new Promise((resolve, reject) => {
        atividade.deleteAtividade(req.body.tituloAtividade, req.body.projNome)
        .then(resultado => {
            if(resultado.erro !== undefined){
                resolve(resultado);
            }else{
                resolve({
                    alerta: resultado.resposta
                });
            }
        })
        .catch(error => {
            reject(error);
        });
    });
}

module.exports = {cadastrarAtividade, listarAtividades , editarAtividade, inativarAtividade};