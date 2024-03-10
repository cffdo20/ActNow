// Importando a classe ProjetoSocial
const ProjetoSocial = require('../model/ProjetoSocial.js');
const usuarioController = require('./UsuController.js');

function criarProjeto(req) {
    // Converter a Data
    this.dataInicioProj = new Date(req.body.projDataInicio);
    this.dataFimProj = new Date(req.body.projDataFim)

    // Aqui vem a função que buscará no banco de dados qual o próximo id disponível, por enquanto será setado sempre como '1'
    //var idProjeto = 1;

    /** Criação do novo projeto --  Esta chamada deve ser adaptada para a mudança no model ProjetoSocial que irá servir como intermédio para a camada de persistência
                                    e não mais instanciará objetos da classe ProjetoSocial diretamente no backend.
*/  var novoProjeto = new ProjetoSocial(req.body.projNome, req.body.projDescricao, req.body.projPublico,
        req.body.projJustificativa, req.body.projObjetivos, this.dataInicioProj, this.dataFimProj);

    // Recebemos uma instancia de usuário de exemplo (Implementar depois)
    const usuario = usuarioController.gerarUsuarioExemplo();
    //Adicionar o usuário como gestor do projeto
    novoProjeto.adicionarGestorProj(usuario);
    
    if (novoProjeto !== null){
        console.log('Dados Projeto:\n' + 'IdProjeto:' + novoProjeto.idProjeto + '\nTítulo:' + novoProjeto.tituloProj + '\nPúblico:' + novoProjeto.publicoAlvoProj + '\nJustificativa:' +
        novoProjeto.justificativaProj + '\nObjetivos:' + novoProjeto.objetivosProj + '\nData de Início:' + novoProjeto.dataInicioProj + '\nData Fim:' +
        novoProjeto.dataFimProj + '\nStatus:' + novoProjeto.statusProj + '\nemail usuario criador:' + novoProjeto.usuario.email);
        return {mensagem: 'sucesso', idProjeto: novoProjeto.tituloProj, Titulo: novoProjeto.tituloProj, Publico:novoProjeto.publicoAlvoProj,
            Objetivos:novoProjeto.objetivosProj, Justificativa:novoProjeto.justificativaProj, Status:novoProjeto.statusProj,Email:novoProjeto.usuario.email};
    }else{
        return {mensagem: 'erro'};
    }
}

module.exports = {criarProjeto};
