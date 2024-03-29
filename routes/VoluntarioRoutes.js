const express = require('express');
const router = express.Router();
const voluntarioController = require('../controller/VoluntarioController.js');

/** Página: Filtro de Voluntário */
// Acesso
router.get('/recrutar-voluntario', (req, res) => {
    res.render('recrutar-voluntarios.ejs');
});
// Receber dados formulário e dar resposta
router.post('/recrutar-voluntario', (req, res) => {
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

module.exports = router;