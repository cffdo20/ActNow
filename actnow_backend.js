// Importando módulos Controllers
const projetoController = require('./controller/ProjController.js');
const usuarioController = require('./controller/UsuController.js');

// Importando 'express' para requisiçõe HTTP e inicialização do host
const express = require('express');
// Importando 'body-parser' para lidar com o corpo da requisição HTTP
const bodyParser = require('body-parser');

// Configurando const app para aplicar 'express'
const app = express();
// Configuração do 'body-parser' para lidar com o corpo das requisições
app.use(bodyParser.urlencoded({ extended: true }));

// Setando a porta a ser usada no localhost
const PORT = 3000;

/** Simulação de evento de usario criando um Projeto */
// Recebemos uma instancia de usuário de exemplo
const usuario = usuarioController.gerarUsuarioExemplo();

// Rota para lidar com a solicitação POST enviada pelo formulário
app.post('/projetos', (req, res) => {   // Recebemos os dados do projeto informados pelo Front-End

    // A função que cria um projeto é chamada
    var projetonovo = projetoController.criarProjeto(usuario, req.body.titulo, req.body.descricao, req.body.publicoAlvo,
        req.body.justificativa, req.body.objetivos, req.body.dataInicio, req.body.status);

    //Gerar uma sáida HTML para visualização no localhost
    var htmlContent = `
        <!DOCTYPE html>
        <html lang="pt-br">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Página HTML Dinâmica</title>
        </head>
        <body>
            <h1>Dados do Projeto Criado</h1>
            <p>Título do Projeto: ${projetonovo.tituloProj}</p>
            <p>Descrição: ${projetonovo.descricaoProj}</p>
            <p>Público-Alvo: ${projetonovo.publicoAlvoProj}</p>
            <p>Justificativa: ${projetonovo.justificativaProj}</p>
            <p>Objetivo do Projeto: ${projetonovo.objetivosProj}</p>
            <p>Data de Início: ${projetonovo.dataInicioProj}</p>
            <p>id do Usuário Criador/Gestor: ${projetonovo.usuario.idUsuario}</p>
            <p>Username do Criador/Gestor: ${projetonovo.usuario.userName}</p>
        </body>
        </html>
        `;
    
    // Responde ao frontend com a página do projeto criado
    res.send(htmlContent);

});

// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});