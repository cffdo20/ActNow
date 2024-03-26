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

                    
                    /*

                    dados.getVoluntario().then(elementos => {
                        resolve({
                            alerta: resultado.resposta,
                            Titulo: elementos.titulo,
                            Descricao: elementos.descricao,
                            Publico: elementos.publico,
                            Justificativa: elementos.justificativa,
                            Objetivos: elementos.objetivos,
                            Inicio: elementos.inicio
                        });
                    })*/
                }               
            })
            .catch(error => {
                // Se ocorrer algum erro na promessa anterior, rejeita a promessa atual com o erro
                reject(error);
            });
    });
}

module.exports = { filtrarVoluntario };