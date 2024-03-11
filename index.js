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
var diretorioDeViews = 'ActNow-front-end';
// Definição do diretório onde estão os arquivos de visualização
app.set('views', path.join(__dirname, diretorioDeViews));
app.use(express.static(path.join(__dirname, diretorioDeViews)));
// Configurando const app para 'body-parser' que lida com o conteúdo das requisições HTTP 
app.use(bodyParser.urlencoded({ extended: false }));


/** Definição das Rotas */
// Criação de novo projeto
app.post('/criar-projeto', (req, res) => {
    projetoController.criarProjeto(req)
    .then(resposta => {
        //console.log(resposta);
        if(!resposta.erro){
            // Precisa tratar aqui quando não der erro, a ideia é fazer uma consulta e puxar os dados do projeto recém criado para abrir sua página
            res.render('visualizacao-projeto.ejs', { elementos: resposta.resposta, alerta: resposta.resposta});
        }else{
            // Redireciona de volta para página de cadastro de projeto enviando uma mensagem para um alerta
            res.redirect('/cadastrar-projetoTeste.html?alerta=' + encodeURIComponent(resposta.erro));
        }
        
        //res.render('visualizacao-projeto.ejs', { elementos: resposta });
    });
});

/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});