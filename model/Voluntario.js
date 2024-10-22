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
    //console.log(consulta[0][0]);
    return consulta[0][0];
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

function setDisponibilidade(username, dia, turno){
  var matutino = '0' , vespertino = '0', noturno = '0';
  if(turno === 'Manhã'){
    matutino = '1';
  }else if(turno === 'Tarde'){
    vespertino = '1';
  }else if(turno === 'Noite'){
    noturno = '1';
  }else{
    switch(turno[0]){
      case 'Manhã':
        matutino = '1';
        break;
      default:
        vespertino = '1';
        break;
    }
    switch(turno[1]){
      case 'Tarde':
        vespertino = '1';
        break;
      default:
        noturno = '1';
        break;
    }
    if(turno[2] === 'Noite'){
      noturno = '1';
    }
  }
  const parametros = [username, dia, matutino, vespertino, noturno];
  return bd.callProcedureWithParameter('sp_disponibilidade_voluntario', parametros)
  .then(consulta => {
    if(consulta.warningStatus === 0){
      return {resposta: 'A disponibilidade foi incluída com sucesso'};
    } else {
      return {erro: 'houve um erro no cadastro de disponibilidade do voluntário, tente novamente.'}
    }
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

function setHabilidade(username, habilidades){
  var parametros = [];
  if(Array.isArray(habilidades)){
    parametros = [username, habilidades.length, ...habilidades];
  } else {
    parametros = [username, 1, habilidades];
  }
  return bd.callProcedureWithParameter('sp_habilidades_voluntario',parametros)
  .then(consulta => {
    return consulta[0][0];
  })
  .catch(error => {
    console.log(error);
    return error;
  });
}

async function exitProjeto(tituloProj, username){
  const parametros = [tituloProj, username];
  try {
    const consulta = await bd.callProcedureWithParameter('sp_retirar_voluntario_projeto', parametros);
    if(consulta.warningStatus === 0){
      return {resposta: 'Você saiu do projeto!'};
    } else {
      return {erro: 'Ocorreu um erro ao sair do projeto'};
    }
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function listCidades(estnome){
  try {
    const consulta = await bd.callProcedureWithParameter('sp_colsultar_cidades', [estnome]);
    return consulta[0];
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function editNomeSocial(username, nomesocial){
  const parametros = [username, nomesocial];
  try {
    const consulta = await bd.callProcedureWithParameter('sp_alterar_nomesocial_voluntario',parametros);
    return consulta[0][0];
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function editBio(username, bio){
  const parametros = [username, bio];
  try {
    const consulta = bd.callProcedureWithParameter('sp_alterar_bio_voluntario',parametros);
    return consulta[0][0];
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function editCidade(username, cidade){
  const parametros = [username, cidade];
  try {
    const consulta = bd.callProcedureWithParameter('sp_alterar_cidade_voluntario',parametros);
    return consulta[0][0];
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function editTelefone(username, telefone){
  const parametros = [username, telefone];
  try {
    const consulta = bd.callProcedureWithParameter('sp_alterar_telefone_voluntario',parametros);
    return consulta[0][0];
  } catch (error) {
    console.log(error);
    return error;
  }
}

async function  deleteVoluntario(username) {
  try {
    const consulta = bd.callProcedureWithParameter('sp_inativar_voluntario',[username]);
    return consulta[0][0];
  } catch (error) {
    console.log(error);
    throw error;
  }
}

module.exports = {  getVoluntario , getFiltroVoluntario , setVoluntario, listVoluntarios,
                    getProjetosVoluntario, exitProjeto, listCidades, editNomeSocial, editBio,
                    editCidade, editTelefone, setDisponibilidade, setHabilidade, deleteVoluntario};