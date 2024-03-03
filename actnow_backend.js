// Importando as Classes usadas
const Usuario = require('./model/Usuario.js');
const ProjetoSocial = require('./model/ProjetoSocial.js');

// Importando módulos Controllers
const ProjController = require('./controller/ProjController.js');
const UsuController = require('./controller/UsuController.js');

/** Simulação de evento de usario criando um Projeto */
// Recebemos uma instancia de usuário de exemplo
const usuario = UsuController.gerarUsuarioExemplo();

// Recebemos os dados do projeto informados pelo Front-End
const idProjeto = 1, tituloProj = 'Educando o Futuro', descricaoProj = 'Projeto voltado a educação de crianças em computação',
      publicoAlvoProj = 'Crianças entre 5 e 10 anos', justificativaProj = 'Quanto antes as crianças tiverem contato com a computação teremos melhores programadores no futuro',
      objetivosProj = 'Ensinar a base de lógica de computação e algoritmos para crianças', dataInicioProj = '2024-03-05T18:30:00', statusProj = 1;

// A função que cria um projeto é chamada
var projetonovo = ProjController.criarProjeto(usuario, idProjeto, tituloProj, descricaoProj, publicoAlvoProj, justificativaProj, objetivosProj, dataInicioProj, statusProj);

// Importando 'express' para criar uma saída HTML
const express = require('express');
const app = express();

//Criando a saída HTML
const htmlContent = `
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
    <p>Username do Criador/Gestor: ${projetonovo.usuario.userName}</p>
</body>
</html>
`;

// Rota para enviar a resposta HTML
app.get('/', (req, res) => {
    res.send(htmlContent);
});

// Iniciando o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});