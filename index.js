// Importando módulos Controllers
const projetoController = require('./controller/ProjetoController.js');
const voluntarioController = require('./controller/VoluntarioController.js');

// Importando módulo Express
const express = require('express');
const app = express();

// Configura a view engine como EJS
app.set('view engine', 'ejs');
// Define o diretório onde estão os arquivos de visualização (views)
app.set('views', 'view/pages');
// Define o diretório onde estão os arquivos estáticos (como CSS, imagens, etc.)
app.use(express.static('view'));
// Middleware para fazer o parsing do corpo das requisições HTTP
app.use(express.urlencoded({ extended: false }));

/** Definição das Rotas */
// Página: Index
app.get('/', (req,res) => {
    res.redirect('index.html');
});

/** Página: Criação de novo projeto */
// Acesso
app.get('/projeto', (req, res) => {
            res.render('cadastrar-projeto.ejs');
});

// Receber dados formulário e dar resposta
app.post('/criar-projeto', (req, res) => {
    projetoController.criarProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('cadastrar-projeto.ejs',{ alerta: resposta.erro });
        }
    });
});

/** Página: Filtro de Voluntário */
// Acesso
app.get('/recrutar-voluntario', (req, res) => {
    res.render('recrutar-voluntarios.ejs');
});

// Receber dados formulário e dar resposta
app.post('/recrutar-voluntario', (req, res) => {
    console.log(req.body);
    voluntarioController.filtrarVoluntario(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com a mensagem do banco e os dados do projeto
            res.render('visualizar-voluntarios.ejs', resposta);
            //res.render('visualizar-voluntarios.ejs'); 
        }else{
            // Redireciona de volta para página de cadastro de projeto enviando a mensagem de erro do banco como alert
            console.log(resposta.erro); 
            res.render('recrutar-voluntarios.ejs',{ alerta: resposta.erro});
           
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
