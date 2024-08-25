const express = require('express');
const router = express.Router();
const usuarioController = require('../controller/UsuarioController.js');
const voluntarioModel = require('../model/Voluntario.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated.js');

/*
  
  # # #    # # #    # # # #    # # #    # # # # #    # # # #
#          #   #    #         #     #       #        #
#          # # #    # # #     # # # #       #        # # #
#          #  #     #         #     #       #        #
  # # #    #   #    # # # #   #     #       #        # # # #

*/

// Direcionar para Formulário de Criação de Usuario
router.get('/criar-conta', (req, res) => {
    res.render('criar-conta.ejs');
});

// Tratar Dados enviados do Formulário de Criação de Projeto
router.post('/criar-conta', (req, res) => {
    usuarioController.criarUsuario(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.redirect('/login');
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('criar-conta.ejs',{ alerta: resposta.erro });
        }
    });
});


/*

# # #     # # # #    # # #      # # #
#   #     #         #     #     #     #
# # #     # # #     # # # #     #     #
#  #      #         #     #     #     #
#   #     # # # #   #     #     # # #

*/

// Acessa o perfil de usuário
router.get('/', ensureAuthenticated, (req,res) => {
    console.log('\nEntrada do front-end: ',req.body,req.session.user,'\n');
    var dadosUsuario = { userName: req.session.user.username, userEmail: req.session.user['e-mail']};
    voluntarioModel.getVoluntario(dadosUsuario.userName)
    .then(Voluntario => {
        console.log('\nResposta do back-end: ',{...dadosUsuario, Voluntario},'\n');
        res.render('user-profile.ejs', {...dadosUsuario, Voluntario});
    })
    .catch(error => {
        console.log(error);
        console.log('\nresposta do back-end: ',{dadosUsuario, error},'\n');
        res.redirect('/');
    })
});


/*

#     #    # # #     # # #       # # #    # # # # #    # # # #
#     #    #     #   #     #    #     #       #        #
#     #    # # #     #     #    # # # #       #        # # #
#     #    #         #     #    #     #       #        #
 # # #     #         # # #      #     #       #        # # # #

*/

// Faz a edição do email do usuario
router.post('/editar', ensureAuthenticated, (req, res) => {
    console.log('\nEntrada do front-end: ',req.body,req.session.user,'\n');
    usuarioController.alterarEmailUsuario(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',{alerta: resposta},'\n');
            req.session.user['e-mail'] = req.body.userEmail;
            res.redirect(`/usuarios?alerta=${encodeURIComponent({alerta: resposta})}`);
        }else{
            console.log('\nResposta do back-end: ',{alerta: resposta.erro},'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent({alerta: resposta.erro})}`);
        }
    })
    .catch(error => {
        console.log('\nResposta do back-end (com erro): ',error,'\n');
        res.redirect(`/usuarios?alerta=${encodeURIComponent({alerta: 'Houve um erro interno no servidor, tente mais tarde ou contacte o administrador do sistema.'})}`);
    });
});

/*

# # #      # # # #    #          # # # #    # # # # #    # # # #
#     #    #          #          #              #        #
#     #    # # #      #          # # #          #        # # #
#     #    #          #          #              #        #
# # #      # # # #    # # # #    # # # #        #        # # # #

*/

// Inativa um usuário
router.post('/excluir', ensureAuthenticated, (req,res) => {
    console.log('\nEntrada do front-end: ',req.body,req.session.user,'\n');
    usuarioController.inativarUsuario(req)
    .then(resposta => {
        if(!resposta.erro){
            console.log('\nResposta do back-end: ',{alerta: resposta},'\n');
            req.session.destroy(err => {
                if (err) {
                  return res.redirect('/');
                }
                res.redirect('/');
              });
        }else{
            console.log('\nResposta do back-end: ',{alerta: resposta.erro},'\n');
            res.redirect(`/usuarios?alerta=${encodeURIComponent({alerta: resposta.erro})}`);
        }
    })
    .catch(error => {
        console.log('\nResposta do back-end (com erro): ',error,'\n');
        res.redirect(`/usuarios?alerta=${encodeURIComponent({alerta: 'Houve um erro interno no servidor, tente mais tarde ou contacte o administrador do sistema.'})}`);
    });
});

module.exports = router;