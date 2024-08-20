const express = require('express');
const router = express.Router();
const atividadeController = require('../controller/AtividadeController.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated.js');

// CREATE
// Abrir o formulário de criação da atividade
router.get('/criar', ensureAuthenticated, (req, res) => {
    res.render('cadastrar-atividade.ejs');
});

// Criar a atividade no projeto
router.post('/criar', ensureAuthenticated, (req, res) => {
    console.log('entrada do front-end: ', req.body,'\n');
    atividadeController.cadastrarAtividade(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta, '\n');
        if(!resposta.erro){
            // Armazena na sessão e redireciona
            req.session.projNome = req.body.projNome;
            res.redirect('/projetos/visualizar');
        }else{
            req.session.projNome = req.body.projNome;
            res.redirect(`/projetos/visualizar?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log('resposta do back-end (com erro): ', error);
        res.render('visualizacao-projeto.ejs', {alerta: 'Houve um erro no servidor, favor tente mais tarde ou entre em contato com o suporte'});
    });
});

// READ
/**Não haverá rota diretamente para visualização de Atividades.
 * As atividades serão visualizadas na página de visualização do Projeto. 
 */


// UPDATE
router.post('/editar',ensureAuthenticated, (req, res) => {
    console.log('entrada do front-end: ', req.body,'\n');
    atividadeController.editarAtividade(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta,'\n');
        if(!resposta.erro){
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    })
    .catch(error => {
        console.log('resposta do back-end (com erro): ', error,'\n');
        res.render('criar-atividade.ejs', {alerta: 'Houve um erro no servidor, favor tente mais tarde ou entre em contato com o suporte'});
    });
});

/*
router.post('/editar-data',ensureAuthenticated, (req, res) => {
    console.log('entrada do front-end: ', req.body,'\n');
    atividadeController.alterarDataEntrega(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta,'\n');
        if(!resposta.erro){
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    })
    .catch(error => {
        console.log('resposta do back-end (com erro): ', error,'\n');
        res.render('criar-atividade.ejs', {alerta: 'Houve um erro no servidor, favor tente mais tarde ou entre em contato com o suporte'});
    });
});
*/

// DELETE

module.exports = router;