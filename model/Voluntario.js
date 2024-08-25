const bd = require('./db.js');

function getVoluntario(userName){
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_consultar_voluntario', [userName]).then(consulta => {
    return consulta[0][0];
  })
}

function setVoluntario(volUserName, volCPF, volNome, volNomeSocial, volBio, volTelefone, volCidNome) {
  let parametros = [volUserName, volCPF, volNome, volNomeSocial, volBio, volTelefone, volCidNome];
  // Retorna a promessa gerada pela função callProcedureWithParameter
  return bd.callProcedureWithParameter('sp_criar_voluntario', parametros).then(consulta => {
    return consulta[0][0];
  })
}

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

  if(Array.isArray(voluntarioHabilidades)){
    var parametrosBase = [filtroDiaSemana, matutino, vespertino, noturno];
    var respostasUnicas = new Set(); // Conjunto para armazenar respostas únicas

    // Mapeia cada habilidade do voluntário para uma promessa de consulta
    var promessasConsulta = voluntarioHabilidades.map(habilidade => {
        // Cria uma cópia dos parâmetros base e adiciona a habilidade atual
        var parametros = parametrosBase.slice(); // Copia os parâmetros base
        parametros.push(habilidade); // Adiciona a habilidade atual
        // Retorna a promessa gerada pela função callProcedureWithParameter
        return bd.callProcedureWithParameter('sp_filtrar_voluntarios', parametros).then(consulta => {
            var resposta = consulta[0][0];
            // Verifica se a resposta não está vazia e se não está presente no conjunto de respostas únicas
            if (resposta && !respostasUnicas.has(JSON.stringify(resposta))) {
                respostasUnicas.add(JSON.stringify(resposta)); // Adiciona a resposta ao conjunto de respostas únicas
                return resposta;
            } else {
                // Se a resposta estiver vazia ou repetida, retorna undefined para que não seja adicionada ao array de respostas
                return undefined;
            }
        });
    });

    // Retorna uma promessa que será resolvida quando todas as consultas forem concluídas
    return Promise.all(promessasConsulta).then(respostas => {
        // Filtra as respostas para remover os elementos undefined
        var respostasValidas = respostas.filter(resposta => resposta !== undefined);
        // Retorna as respostas válidas como um array
        return respostasValidas;
    });
  }else{
    var parametros = [filtroDiaSemana, matutino, vespertino, noturno, voluntarioHabilidades];
    // Retorna a promessa gerada pela função callProcedureWithParameter
    return bd.callProcedureWithParameter('sp_filtrar_voluntarios', parametros).then(consulta => {
      //console.log(consulta[0][0]);
      return consulta[0][0];
    })
  }
}

function listVoluntarios(tituloProj){
  return bd.callProcedureWithParameter('sp_voluntarios_projeto',[tituloProj])
  .then(consulta => {
    return consulta[0];
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

function getProjetosVoluntario(username){
  return bd.callProcedureWithParameter('sp_projetos_voluntario',[username])
  .then(consulta => {
    console.log(consulta[0][0]);
    return consulta[0][0];
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

function exitProjeto(tituloProj, username){
  const parametros = [tituloProj, username];
  return bd.callProcedureWithParameter('sp_retirar_voluntario_projeto',parametros)
  .then(consulta => {
    return consulta[0][0];
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

module.exports = { getVoluntario , getFiltroVoluntario , setVoluntario, listVoluntarios, getProjetosVoluntario, exitProjeto};