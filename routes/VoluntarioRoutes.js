const express = require('express');
const router = express.Router();
const voluntarioController = require('../controller/VoluntarioController.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated'); // Importa o middleware de autenticação

/*
  
# # # #    #     #    #     #      # # #    # # # # #    # # #     # # #      #     #
#          #     #    # #   #    #              #          #     #       #    # #   #
# # #      #     #    #  #  #    #              #          #     #       #    #  #  #
#          #     #    #   # #    #              #          #     #       #    #   # #
#           # # #     #     #      # # #        #        # # #     # # #      #     #

*/

/** Página: Filtro de Voluntário */
// Acesso
router.get('/filtro', ensureAuthenticated, (req, res) => {
    res.render('recrutar-voluntarios.ejs');
});

// Receber dados formulário e dar resposta
router.post('/filtro', ensureAuthenticated, (req, res) => {
    console.log(req.body);
    req.session.projNome = req.body.projNome;
    res.redirect('/voluntarios/filtro');
});

router.post('/filtrar', ensureAuthenticated, (req, res) => {
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

router.post('/recrutar',ensureAuthenticated, (req, res) => {
    voluntarioController.recrutarVoluntario(req)
    .then(resposta => {
        console.log('Entrada do front-end: ',req.body);
        if(!resposta.erro){
            res.redirect(`/projetos/visualizar?alerta=${encodeURIComponent(resposta)}`);
        }else{
            res.render('/filtro', {alerta: resposta.erro});
        }
    })
    .catch(error => {
        console.log('\nResposta do back-end (com erro): ',error,'\n');
        res.redirect(`/?alerta=${encodeURIComponent({alerta: 'Houve um erro interno no servidor, tente mais tarde ou contacte o administrador do sistema.'})}`);
    });
});

router.post('/sair-projeto', ensureAuthenticated, (req, res) => {
    console.log('\nEntrada no front-end: ',req.session.user,req.body,'\n');
    voluntarioController.sairProjeto(req)
    .then(resposta => {
        if(!resposta.erro){
            res.redirect(`/voluntarios?alerta=${encodeURIComponent(resposta)}`);
        }else{
            res.redirect(`/voluntarios?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log('\nResposta do back-end (com erro): ',error,'\n');
        res.redirect(`/?alerta=${encodeURIComponent({alerta: 'Houve um erro interno no servidor, tente mais tarde ou contacte o administrador do sistema.'})}`);
    });
});

/*
  
  # # #    # # #    # # # #    # # #    # # # # #    # # # #
#          #   #    #         #     #       #        #
#          # # #    # # #     # # # #       #        # # #
#          #  #     #         #     #       #        #
  # # #    #   #    # # # #   #     #       #        # # # #

*/

router.get('/voluntariar-se', ensureAuthenticated, (req, res) => {
    res.render('voluntario-format.ejs');
});

router.post('/voluntariar-se', ensureAuthenticated, (req, res) => {
    voluntarioController.voluntariarUsuario(req)
    .then(resposta => {
        if(!resposta.erro){
            res.render('/voluntarios', resposta);
        }else{
            res.render('/voluntariar-se', {alerta: resposta.erro});
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

/*

# # #     # # # #    # # #      # # #
#   #     #         #     #     #     #
# # #     # # #     # # # #     #     #
#  #      #         #     #     #     #
#   #     # # # #   #     #     # # #

*/

router.get('/',ensureAuthenticated, (req, res) => {
    console.log('\nEntrada do frot-end: ',req.session.user,req.body,'\n');
    voluntarioController.exibirAreaVoluntario(req)
    .then(resposta => {
        console.log('\nResposta do back-end: ',resposta,'\n');
        res.render('projeto-voluntario.ejs',resposta);
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

/*

#     #    # # #     # # #       # # #    # # # # #    # # # #
#     #    #     #   #     #    #     #       #        #
#     #    # # #     #     #    # # # #       #        # # #
#     #    #         #     #    #     #       #        #
 # # #     #         # # #      #     #       #        # # # #

*/

// Editar o Nome Social do voluntário
router.post('/editar-nomesocial',ensureAuthenticated,(req,res)=> {
    //stub
});

// Editar a Biografia do voluntário
router.post('/editar-bio',ensureAuthenticated,(req,res)=> {
    //stub
});

// Editar a Cidade do voluntário
router.post('/editar-cidade',ensureAuthenticated,(req,res)=> {
    //stub
});

// Editar o Telefone do voluntário
router.post('/editar-telefone',ensureAuthenticated,(req,res)=> {
    //stub
});

module.exports = router;