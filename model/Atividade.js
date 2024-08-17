const bd = require('./db.js');

// CRATE
function setAtividade(tituloAtividade, descricaoAtividade, dataEntregaAtividade, tituloProjeto){
    const data = new Date();
    const dataInicio = data.toISOString(dataEntregaAtividade).split('T')[0];
    parametros = [tituloAtividade, descricaoAtividade, dataInicio, '1', tituloProjeto];
    return bd.callProcedureWithParameter('sp_definir_Atividade', parametros)
    .then(consulta =>{
        return consulta[0][0];
    })
    .catch(error =>{
        console.log(error);
        return error;
    });
}

// READ
function getAtividade(){
    //stub
}

// UPDATE
function editarDataAtividade(){
    //stub
}

function editarDescAtividade(){
    //stub
}

// DELETE
function deleteAtividade(){
    //stub
}

module.exports = { setAtividade, getAtividade, editarDataAtividade, editarDescAtividade, deleteAtividade }