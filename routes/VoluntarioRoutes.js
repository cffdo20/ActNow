const express = require('express');
const router = express.Router();
const voluntarioController = require('../controller/VoluntarioController.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated'); // Importa o middleware de autenticação

/** Página: Filtro de Voluntário */
// Acesso
router.get('/recrutar-voluntario', ensureAuthenticated, (req, res) => {
    res.render('recrutar-voluntarios.ejs');
});
// Receber dados formulário e dar resposta
router.post('/recrutar-voluntario', ensureAuthenticated, (req, res) => {
    console.log(req.body);
    voluntarioController.filtrarVoluntario(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com a mensagem do banco e os dados do projeto
            res.render('recrutar-voluntarios.ejs', resposta);
            //res.render('visualizar-voluntarios.ejs'); 
        }else{
            // Redireciona de volta para página de cadastro de projeto enviando a mensagem de erro do banco como alert
            console.log(resposta.erro); 
            res.render('recrutar-voluntarios.ejs',{ alerta: resposta.erro});
           
        }
    });
});

router.post('/voluntario', ensureAuthenticated, (req, res) => {
    voluntarioController.voluntariarUsuario(req)
    .then(resposta => {
        if(!resposta.erro){
            res.render('/', resposta);
        }else{
            res.render('/tonar-voluntario', {alerta: resposta.erro});
        }
    })
});

module.exports = router;