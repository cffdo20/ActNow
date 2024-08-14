const express = require('express');
const router = express.Router();
const usuarioController = require('../controller/UsuarioController.js');

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



/*

#     #    # # #     # # #       # # #    # # # # #    # # # #
#     #    #     #   #     #    #     #       #        #
#     #    # # #     #     #    # # # #       #        # # #
#     #    #         #     #    #     #       #        #
 # # #     #         # # #      #     #       #        # # # #

*/



/*

# # #      # # # #    #          # # # #    # # # # #    # # # #
#     #    #          #          #              #        #
#     #    # # #      #          # # #          #        # # #
#     #    #          #          #              #        #
# # #      # # # #    # # # #    # # # #        #        # # # #

*/


module.exports = router;