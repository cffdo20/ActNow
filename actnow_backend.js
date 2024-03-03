// Importando módulos Controllers
const ProjController = require('./controller/ProjController.js');
const UsuController = require('./controller/UsuController.js');

// Importando 'express' para requisiçõe HTTP
const express = require('express');
const app = express();
// Setando a porta a ser usada no localhost
const PORT = 3000;

// Importando 'body-parser' para lidar com o corpo da requisição HTTP
const bodyParser = require('body-parser');
// Configuração do body-parser para lidar com o corpo das requisições
app.use(bodyParser.urlencoded({ extended: true }));

/*/ Importando 'cors' para permitir requisições HTTP de outro local
const cors = require('cors');
// Adicionando middleware para permitir requisições HTTP de outro local
app.use(cors());

/** Simulação de evento de usario criando um Projeto */
// Recebemos uma instancia de usuário de exemplo
const usuario = UsuController.gerarUsuarioExemplo();

// Rota para lidar com a solicitação POST enviada pelo formulário
app.post('/projetos', (req, res) => {   // Recebemos os dados do projeto informados pelo Front-End

    // A função que cria um projeto é chamada
    let projetonovo = ProjController.criarProjeto(usuario , 1, req.body.titulo, req.body.descricao, req.body.publicoAlvo,
        req.body.justificativa, req.body.objetivos, req.body.dataInicio, req.body.status);

    //Gerar uma sáida HTML para visualização no localhost
    let htmlContent = `
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

    // Rota para enviar a resposta HTML
    //app.get('/projetos', (req, res) => {
    //});
    
    // Responde ao frontend com uma mensagem de sucesso
    res.send(htmlContent);

});

// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});