// Importando módulo Express
const express = require('express');
const session = require('express-session');
const app = express();

// Configuração da sessão deve vir antes da definição das rotas
app.use(session({
    secret: 'actnow',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // `secure: true` se você estiver usando HTTPS
}));

// Configura a view engine como EJS
app.set('view engine', 'ejs');
// Define o diretório onde estão os arquivos de visualização (views)
app.set('views', 'view/pages');
// Define o diretório onde estão os arquivos estáticos (como CSS, imagens, etc.)
app.use(express.static('view'));
// Middleware para fazer o parsing do corpo das requisições HTTP
app.use(express.urlencoded({ extended: false }));

// Importando módulos de Rotas
const volutarioRoutes = require('./routes/VoluntarioRoutes.js');
const projetoRoutes = require('./routes/ProjetoRoutes.js');
const usuarioRoutes = require('./routes/UsuarioRoutes.js');
const sessionRoutes = require('./routes/SessionRoutes.js');
const atividadeRouter = require('./routes/AtividadeRoutes.js');

/** Definição das Rotas */
// Página: Index
app.get('/', (req, res) => {
    if(req.session.user !== undefined)
        res.render('user-page', { user: req.session.user });
    else
        res.render('../index', { user: req.session.user });
});

// Páginas de Voluntario
app.use('/voluntarios', volutarioRoutes);
// Páginas de Projeto
app.use('/projetos', projetoRoutes);
// Páginas de Usuário
app.use('/usuarios', usuarioRoutes);
// Páginas de Sessão
app.use('/', sessionRoutes);
// Páginas de Atividade
app.use('/atividades', atividadeRouter);

/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});
