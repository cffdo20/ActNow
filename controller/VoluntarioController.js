m// Importando a classe FiltroVoluntario
const filtro = require('../model/Voluntario.js');
const dados = require('../model/Voluntario.js');

function filtrarVoluntario(req) {
    return new Promise((resolve, reject) => {
        /** Filtro com base nos parâmetros */
        filtro.getFiltroVoluntario(req.body.filtroDiaSemana, req.body.voluntarioHorario, req.body.voluntarioHabilidades)
            .then(resultado => {
                if (Array.isArray(resultado)) {
                    // Se for um array, ou seja, tem mais de um voluntário que atende aos critérios do filtro
                    console.log('É Array: ' + resultado);
                    var promises = resultado.map(item => dados.getVoluntario(item.username));

                    Promise.all(promises)
                        .then(elementos => {
                            var dadosVoluntarios = elementos.map(elemento => ({
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
                    console.log('Não é Array: ' + resultado);
                    // Se não for um array, ou seja, somente um, ou nenhum, voluntário atende aos critérios do filtro
                
                    if(resultado === undefined){
                        // Caso nenhum voluntário atendeu aos critérios
                        resolve({erro: 'Nenhum voluntário atendeu aos critérios.\nTente executar um filtro diferente.'});
                    }

                    dados.getVoluntario(resultado.username)
                        .then(elemento => {
                            // Caso um voluntário atendeu aos critérios
                            var dadosVoluntarios = [{
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
            })
            .catch(error => {
                reject(error);
            });
    });
}
module.exports = { filtrarVoluntario };
