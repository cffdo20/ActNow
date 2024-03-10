// Importando módulos Controllers
const projetoController = require('./controller/ProjController.js');

// Importando 'ejs' para Engine View
//const ejs = require('ejs');
// Importando 'express' para requisiçõe HTTP e inicialização do host
const path = require('path'); // Importando o módulo 'path'
const express = require('express');
// Importando 'body-parser' para lidar com o corpo das requisições HTTP
const bodyParser = require('body-parser');
// Configurando const app para aplicar 'express'
const app = express();
// Configuração do EJS como view engine
app.set('view engine', 'ejs');
// Definição do diretório onde estão os arquivos de visualização (opcional)
app.set('views', path.join(__dirname, 'ActNow-front-end'));
// Configurando const app para 'body-parser' que lida com o conteúdo das requisições HTTP 
app.use(bodyParser.urlencoded({ extended: true }));

/** Definição das Rotas */
// Criação de novo projeto
app.post('/criar-projeto', (req, res) => {
    let resposta = projetoController.criarProjeto(req);
    if(resposta.mensagem === 'erro'){
        //res.send('Erro ao cadastrar projeto');
        res.redirect('/cadastra-projetoTeste');
    }else{
        let data = {
            Mensagem: 'Projeto criado com sucesso!',
            idProjeto:resposta.idProjeto,
            Titulo:resposta.Titulo,
            Publico:resposta.Publico,
            Justificativa:resposta.Justificativaustificativa,
            Status:resposta.Status,
            Email:resposta.Email,
            Objetivos: resposta.Objetivos
        };
        // Renderiza a página 'visualizacao-projeto.ejs' e envia para o cliente junto com os dados
        res.render('visualizacao-projeto.ejs', data);
    }
});

/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});