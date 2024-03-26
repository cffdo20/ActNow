// Importando a classe FiltroVoluntario
const filtro = require('../model/Voluntario.js');
const dados = require('../model/Voluntario.js');

function filtrarVoluntario(req) {
    return new Promise((resolve, reject) => {
        /** Filtro com base nos parâmetros */
        filtro.getFiltroVoluntario(req.body.filtroDiaSemana, req.body.voluntarioHorario, req.body.voluntarioHabilidades)
            .then(resultado => {
                if (resultado.erro !== undefined) {
                    // Se houver um erro na resposta, apenas envia a resposta
                    resolve(resultado);
                } else {
                    log.console(resultado);

                    // Caso contrário, busca os dados dos voluntários filtrados e depois envia a resposta e os dados dos voluntários
                    var tamResultado = resultado.length - 1;
                    var dadosVoluntarios = [];
                    for (let i = 0; i < tamResultado; i++){
                        dados.getVoluntario(resultado[0][i]).then(elementos => {
                            dadosVoluntarios.push({Nome: elementos.nome,
                                                Bio: elementos.biografia,
                                                Contato: elementos.telefone});
                        })
                    }
                    resolve({
                        alerta: resultado.resposta,
                        Voluntarios: dadosVoluntarios
                    });
                }               
            })
            .catch(error => {
                reject(error);
            });
    });
}

module.exports = { filtrarVoluntario };