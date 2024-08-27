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
    console.log('\nEntrada do front-end: ',req.session.user,req.body,'\n');
    voluntarioController.recrutarVoluntario(req)
    .then(resposta => {
        console.log('\nResposta do back-end: ',resposta,'\n');
        if(!resposta.erro){
            res.redirect(`/projetos/visualizar?alerta=${encodeURIComponent(resposta.alerta)}`);
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
            res.redirect(`/voluntarios?alerta=${encodeURIComponent(resposta.alerta)}`);
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
    res.render('voluntario-form.ejs',{userName: req.session.user.username});
});

router.post('/voluntariar-se', ensureAuthenticated, (req, res) => {
    console.log('\nEntrada do front-end: ',req.session.user, req.body,'\n');
    voluntarioController.voluntariarUsuario(req)
    .then(resposta => {
        console.log('\nRetorno do back-end: ',resposta,'\n');
        if(!resposta.erro){
            res.redirect(`/voluntarios?alerta=${encodeURIComponent(resposta.alerta)}`);
        }else{
            res.redirect(`/voluntariar-se?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

router.get('/cidades/:estado', (req, res) => {
    console.log('\nEntrada do front-end: ', req.params, '\n');
    voluntarioController.listarCidades(req)
    .then(resposta => {
        if (!resposta.erro) {
            console.log('\nResposta do Back-end: ', resposta, '\n');
            res.json(resposta); // Envia a resposta JSON
        } else {
            console.log('\nResposta do Back-end: ', resposta.erro, '\n');
            res.status(500).json({ erro: 'Erro ao buscar cidades.' }); // Envia um erro se houver
        }
    })
    .catch(error => {
        console.error('Erro no servidor:', error);
        res.status(500).json({ erro: 'Erro interno do servidor.' }); // Lida com erros internos
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
    console.log('\nEntrada do frot-end: ',req.session.user,req.body,'\n');
    voluntarioController.editarNomeSocial(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',resposta.alerta,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.alerta)}`);
        } else {
            console.log('\nResposta do back-end: ',resposta.erro,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

// Editar a Biografia do voluntário
router.post('/editar-bio',ensureAuthenticated,(req,res)=> {
    console.log('\nEntrada do frot-end: ',req.session.user,req.body,'\n');
    voluntarioController.editarBio(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',resposta.alerta,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.alerta)}`);
        } else {
            console.log('\nResposta do back-end: ',resposta.erro,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

// Editar a Cidade do voluntário
router.post('/editar-cidade',ensureAuthenticated,(req,res)=> {
    console.log('\nEntrada do frot-end: ',req.session.user,req.body,'\n');
    voluntarioController.editarCidade(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',resposta.alerta,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.alerta)}`);
        } else {
            console.log('\nResposta do back-end: ',resposta.erro,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

// Editar o Telefone do voluntário
router.post('/editar-telefone',ensureAuthenticated,(req,res)=> {
    console.log('\nEntrada do frot-end: ',req.session.user,req.body,'\n');
    voluntarioController.editarTelefone(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',resposta.alerta,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.alerta)}`);
        } else {
            console.log('\nResposta do back-end: ',resposta.erro,'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect(`/?alerta=${encodeURIComponent('Houve um erro interno no servidor. Contacte o administrador do sistema ou tente mais tarde')}`);
    });
});

module.exports = router;