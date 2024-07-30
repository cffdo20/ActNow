const express = require('express');
const router = express.Router();
const projetoController = require('../controller/ProjetoController.js');

/*
  
  # # #    # # #    # # # #    # # #    # # # # #    # # # #
#          #   #    #         #     #       #        #
#          # # #    # # #     # # # #       #        # # #
#          #  #     #         #     #       #        #
  # # #    #   #    # # # #   #     #       #        # # # #

*/

// Acesso
router.get('/criar-projeto', (req, res) => {
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


/*

# # #     # # # #    # # #      # # #
#   #     #         #     #     #     #
# # #     # # #     # # # #     #     #
#  #      #         #     #     #     #
#   #     # # # #   #     #     # # #

*/
/** Página: Listar projetos do usuário  */
// Rota para Página com lista dos projetos do usuário 
router.get('/projetos', (req, res) => {
    projetoController.listarProjetos(req) // Depois trocar pelo usuário ativo
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.render('listar-projetos.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('cadastrar-projeto.ejs',{ alerta: resposta.erro });
        }
    });
});

router.post('/visualizar-projeto',(req, res) =>{
    projetoController.exibirProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizar-projeto.ejs',{ alerta: resposta.erro });
        }
    });
})


/** Página: Editar o projeto */
// Acesso
router.get('/editar-projeto', (req, res) => {
    res.render('editar-projeto.ejs', req);
});

// Receber dados formulário e dar resposta
router.post('/projeto-editado', (req, res) => {
    projetoController.editarProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com os dados editados
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('editar-projeto.ejs',{req, alerta: resposta.erro });
        }
    });
});

module.exports = router;