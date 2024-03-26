// Importando módulos Controllers
const projetoController = require('./controller/ProjetoController.js');
const voluntarioController = require('./controller/VoluntarioController.js');

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
const diretorioDeViews = 'ActNow-front-end/view';
const diretorioDoIndexHTML = 'ActNow-front-end';
// Definição do diretório onde estão os arquivos de visualização
app.set('views', path.join(__dirname, diretorioDeViews));
app.use(express.static(path.join(__dirname, diretorioDoIndexHTML)));
// Configurando const app para 'body-parser' que lida com o conteúdo das requisições HTTP 
app.use(bodyParser.urlencoded({ extended: false }));

/** Definição das Rotas */
// Página: Index
app.get('/', (req,res) => {
    res.redirect('index.html');
});

// Página: Criação de novo projeto
app.post('/criar-projeto', (req, res) => {
    projetoController.criarProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com a mensagem do banco e os dados do projeto
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Redireciona de volta para página de cadastro de projeto enviando a mensagem de erro do banco como alert
            res.render('cadastrar-projeto.ejs',{ alerta: resposta.erro });
        }
    });
});

// Página: Projeto
app.get('/projeto', (req, res) => {
            res.render('cadastrar-projeto.ejs');
});


// Página: Filtro de Voluntário
// Acesso
app.get('/recrutar-voluntario', (req, res) => {
    res.render('recrutar-voluntarios.ejs');
});
// Receber dados formulário
app.post('/recrutar-voluntario', (req, res) => {
    console.log(req.body);
    voluntarioController.filtrarVoluntario(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com a mensagem do banco e os dados do projeto
            res.render('recrutar-voluntarios.ejs', resposta);
        }else{
            // Redireciona de volta para página de cadastro de projeto enviando a mensagem de erro do banco como alert
            res.render('recrutar-voluntarios.ejs',{ alerta: resposta.erro });
        }
    });
});


/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});