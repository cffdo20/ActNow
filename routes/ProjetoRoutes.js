const express = require('express');
const router = express.Router();
const projetoController = require('../controller/ProjetoController.js');

/** Página: Criação de novo projeto */
// Acesso
router.get('/projeto', (req, res) => {
    res.render('cadastrar-projeto.ejs');
});

// Receber dados formulário e dar resposta
router.post('/criar-projeto', (req, res) => {
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

module.exports = router;