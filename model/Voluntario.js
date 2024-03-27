const bd = require('../BD/db.js');

function getFiltroVoluntario(filtroDiaSemana, voluntarioHorario, voluntarioHabilidades) {
  // Tratar horário
  var matutino = '0' , vespertino = '0', noturno = '0';
  if(voluntarioHorario === 'matutino'){
    matutino = '1';
  }else if(voluntarioHorario === 'vespertino'){
    vespertino = '1';
  }else if(voluntarioHorario === 'noturno'){
    noturno = '1';
  }else{
    switch(voluntarioHorario[0]){
      case 'matutino':
        matutino = '1';
        break;
      default:
        vespertino = '1';
        break;
    }
    switch(voluntarioHorario[1]){
      case 'vespertino':
        vespertino = '1';
        break;
      default:
        noturno = '1';
        break;
    }
    if(voluntarioHorario[2] === 'noturno'){
      noturno = '1';
    }
  }

  var parametros = [filtroDiaSemana, matutino, vespertino, noturno, voluntarioHabilidades];
  console.log(parametros);
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_filtrar_voluntarios', parametros).then(consulta => {
    console.log(consulta);
    return consulta[0][0];
  })
}

function getVoluntario(userName){
  let parametros = [userName];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_voluntario', parametros).then(consulta => {
    return consulta[0][0];
  })
};

module.exports = { getVoluntario , getFiltroVoluntario };