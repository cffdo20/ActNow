const bd = require('./db.js');

// CREATE
function setAtividade(tituloAtividade, descricaoAtividade, dataEntregaAtividade, tituloProjeto){
    const dataEntrega = new Date(dataInicioProj).toISOString().split('T')[0];
    parametros = [tituloAtividade, descricaoAtividade, dataEntrega, '1', tituloProjeto];
    return bd.callProcedureWithParameter('sp_definir_Atividade', parametros)
    .then(consulta => {
        return consulta[0][0];
    })
    .catch(error => {
        console.log(error);
        return error;
    });
}

// READ
function getAtividade(){
    //stub
}

function listAtividades(tituloProjeto){
    return bd.callProcedureWithParameter('sp_consultar_atividades_projeto',[tituloProjeto])
    .then(consulta => {
        //console.log('O que voltou do banco de dados', consulta[0]);
        return consulta[0];
    })
    .catch(error => {
        console.log(error);
        return error;
    });
}

// UPDATE
function editarDataAtividade(tituloAtividade, tituloProjeto, dataEntregaAtividade){
    const data = new Date();
    const dataEntrega = data.toISOString(dataEntregaAtividade).split('T')[0];
    parametros = [tituloAtividade, tituloProjeto, dataEntrega];
    return bd.callProcedureWithParameter('sp_alterar_data_atividade', parametros)
    .then(consulta => {
        return consulta[0][0];
    })
    .catch(error => {
        console.log(error);
        return error;
    });
}

function editarDescAtividade(tituloAtividade, tituloProjeto, descricaoAtividade){
    parametros = [tituloAtividade, tituloProjeto, descricaoAtividade];
    return bd.callProcedureWithParameter('sp_alterar_descricao_atividade', parametros)
    .then(consulta => {
        return consulta[0][0];
    }).catch(error => {
        console.log(error);
        return error;
    });
}

// DELETE
function deleteAtividade(tituloAtividade, tituloProjeto){
    parametros = [tituloAtividade, tituloProjeto, '0'];
    return bd.callProcedureWithParameter('sp_alterar_status_atividade', parametros)
    .then(consulta =>{
        return consulta[0][0];
    })
    .catch(error => {
        console.log(error);
        return error;
    });
}

module.exports = { setAtividade, getAtividade, listAtividades, editarDataAtividade, editarDescAtividade, deleteAtividade }