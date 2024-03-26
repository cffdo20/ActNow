// Importando a classe FiltroVoluntario
const filtro = require('../model/Voluntario.js');
const dados = require('../model/Voluntario.js');

function filtrarVoluntario(req) {
    return new Promise((resolve, reject) => {
        /** Filtro com base nos parâmetros */
        filtro.getFiltroVoluntario(req.body.filtroDiaSemana, req.body.voluntarioHorario, req.body.voluntarioHabilidades)
            .then(resultado => {
                if (Array.isArray(resultado)) {
                    console.log(resultado);
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
                    console.log(resultado);
                    // Se resultado não for um array, chama dados.getVoluntario com resultado.username
                    dados.getVoluntario(resultado.username)
                        .then(elemento => {
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