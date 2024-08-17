const express = require('express');
const router = express.Router();
const atividadeController = require('../controller/AtividadeController.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated');

// CREATE
// Abrir o formulário de criação da atividade
router.get('/criar-atividade', ensureAuthenticated, (req, res) => {
    res.render('cadastrar-atividade.ejs');
});

// Criar a atividade no projeto
router.post('criar-atividade', ensureAuthenticated, (req, res) => {
    console.log('entrada do front-end: ', req.body);
    atividadeController.cadastrarAtividade(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta);
        if(!resposta.erro){
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            res.render('criar-atividade.ejs', {alerta: resposta.erro});
        }
    })
    .catch(error => {
        console.log('resposta do back-end (com erro): ', error);
        res.render('criar-atividade.ejs', {alerta: 'Houve um erro no servidor, favor tente mais tarde ou entre em contato com o suporte'});
    });
});

// READ

// UPDATE

// DELETE

module.exports = router;