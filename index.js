// Importando módulos Controllers
const projetoController = require('./controller/ProjController.js');

// Importando 'express' para requisiçõe HTTP e inicialização do host
const express = require('express');
// Importando 'body-parser' para lidar com o corpo das requisições HTTP
const bodyParser = require('body-parser');
// Configurando const app para aplicar 'express'
const app = express();
// Configuração do EJS como view engine
app.set('view engine', 'ejs');
// Definição do diretório onde estão os arquivos de visualização (opcional)
app.set('view', path.join(__dirname, 'view'));
// Configurando const app para 'body-parser' que lida com o conteúdo das requisições HTTP 
app.use(bodyParser.urlencoded({ extended: true }));

/** Definição das Rotas */
// Define a rota para o index
app.get('/index', (req, res) => {
    // Envie a página HTML preexistente
    res.sendFile(__dirname + '/ActNow-front-end/index.html');
});
// Define a rota para a página do projeto criado
app.get('/meu-projeto', (req, res) => {
    // Envie a página HTML preexistente
    //res.sendFile(__dirname + '/ActNow-front-end/visualizacao-projeto.html');
    //Outra abordagem
    // Os dados que você deseja passar para o template
    const data = {
        titulo: 'Projeto criado com sucesso!',
        conteudo: 'Olá, mundo!'
    };

    // Renderiza a página 'pagina.ejs' e envia para o cliente
    res.render('meu-projeto', data);
});

/** Acionamento dos controllers para cada rota acionada | Rotas para lidar com as solicitaçõs POST enviada pelo formulário(HTML)*/
// Criação de novo projeto
app.post('/criar-projeto', (req, res) => {
    let resposta = projetoController.criarProjeto(req);
    if(resposta.startsWith('Erro')){
        //res.send('Erro ao cadastrar projeto');
        res.redirect('/index');
    }else{
        res.redirect('/meu-projeto');
    }
});

/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});