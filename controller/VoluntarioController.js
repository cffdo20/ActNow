// Importando a classe FiltroVoluntario
const voluntario = require('../model/Voluntario.js');
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
                    var promises = resultado.map(item => dados.getVoluntario(item.username));

                    Promise.all(promises)
                        .then(elementos => {
                            var dadosVoluntarios = elementos.map(elemento => ({
                                username: resultado.username,
                                Nome: elemento.nome,
                                Bio: elemento.biografia,
                                Contato: elemento.telefone
                            }));

                            resolve({
                                alerta: resultado.resposta,
                                Voluntarios: dadosVoluntarios
                            });
                        })
                        .catch(error => {
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

function voluntariarUsuario(req){
    return new Promise((resolve, reject) => {
        voluntario.setVoluntario(req.session.user.username, req.body.volCPF, req.body.volNome, req.body.volNomeSocial, req.body.volBio, req.body.volTelefone, req.body.volCidNome)
        .then(resultado => {
            resolve ({
                alerta: resultado.resposta
            })
        })
        .catch(error => {
            reject(error)
        })
    })
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


module.exports = { filtrarVoluntario, voluntariarUsuario, recrutarVoluntario };
