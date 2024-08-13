// Importando módulo Express
const express = require('express');
const session = require('express-session');
const app = express();

// Configuração da sessão deve vir antes da definição das rotas
app.use(session({
    secret: 'seuSegredoAqui',
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

/** Definição das Rotas */
// Página: Index
app.get('/', (req, res) => {
    res.redirect('index.html');
});
// Páginas de Voluntario
app.use('/', volutarioRoutes);
// Páginas de Projeto
app.use('/', projetoRoutes);
// Páginas de Usuário
app.use('/', usuarioRoutes);
// Páginas de Sessão
app.use('/', sessionRoutes);

/** Inicialização do servidor */
// Setando a porta a ser usada no localhost
const PORT = 3000;
// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor da web iniciado na porta ${PORT}`);
});
