// Importando módulos Controllers
const ProjController = require('./controller/ProjController.js');
const UsuController = require('./controller/UsuController.js');

// Importando 'express' para requisiçõe HTTP
const express = require('express');
const app = express();

// Importando 'cors' para permitir requisições HTTP de outro local
const cors = require('cors');

// Setando a porta a ser usada no localhost
const PORT = 3000;

// Adicionando middleware para permitir requisições HTTP de outro local
app.use(cors());

// Adicionadno middleware para lidar com o corpo de solicitações HTTP formatadas em JSON 
app.use(express.json());

/** Simulação de evento de usario criando um Projeto */
// Recebemos uma instancia de usuário de exemplo
const usuario = UsuController.gerarUsuarioExemplo();

// Rota para lidar com a solicitação POST enviada pelo formulário
app.post('/projetos', (req, res) => {   // Recebemos os dados do projeto informados pelo Front-End
    // Exibe os dados recebidos do frontend no console
    console.log('Dados recebidos do frontend:', req.body);

    // A função que cria um projeto é chamada
    let projetonovo = ProjController.criarProjeto(usuario ,req.body.idProjeto, req.body.tituloProj, req.body.descricaoProj, req.body.publicoAlvoProj, req.body.justificativaProj, req.body.objetivosProj, req.body.dataInicioProj, req.body.statusProj);

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
            <h1>Dados do Projeto</h1>
            <p>Título do Projeto: ${projetonovo.tituloProj}</p>
            <p>Descrição: ${projetonovo.descricaoProj}</p>
            <p>Público-Alvo: ${projetonovo.publicoAlvoProj}</p>
            <p>Justificativa: ${projetonovo.justificativaProj}</p>
            <p>Objetivo do Projeto: ${projetonovo.objetivosProj}</p>
            <p>Data de Início: ${projetonovo.dataInicioProj}</p>
            <p>Username do Criador/Gestor: ${projetonovo.usuario.idUsuario}</p>
            <p>Username do Criador/Gestor: ${projetonovo.usuario.userName}</p>
        </body>
        </html>
        `;

    // Rota para enviar a resposta HTML
    app.get('/', (req, res) => {
    res.send(htmlContent);
    });
    
    // Responde ao frontend com uma mensagem de sucesso
    res.json({ mensagem: 'Dados recebidos com sucesso, projeto criado!' });

});

// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});