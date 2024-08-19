const express = require('express');
const router = express.Router();
const projetoController = require('../controller/ProjetoController.js');
const ensureAuthenticated = require('../middleware/ensureAuthenticated'); // Importa o middleware de autenticação

/*
  
  # # #    # # #    # # # #    # # #    # # # # #    # # # #
#          #   #    #         #     #       #        #
#          # # #    # # #     # # # #       #        # # #
#          #  #     #         #     #       #        #
  # # #    #   #    # # # #   #     #       #        # # # #

*/

// Direcionar para Formulário de Criação de Projeto
router.get('/criar', ensureAuthenticated, (req, res) => {
    res.render('cadastrar-projeto.ejs');
});

// Tratar Dados enviados do Formulário de Criação de Projeto
router.post('/criar', ensureAuthenticated, (req, res) => {
    console.log('entrada do front-end: ', req.body);
    projetoController.criarProjeto(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta);
        console.log(resposta);
        if(!resposta.erro){
            req.session.projNome = req.body.projNome;
            res.redirect(`/projetos/visualizar?alerta:${encodeURIComponent(resposta.alerta)}`);
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

// Listar os projetos do Usuário
router.get('/', ensureAuthenticated, (req, res) => {
    projetoController.listarProjetos(req) // Depois trocar pelo usuário ativo
    .then(resposta => {
        console.log('resposta do back-end: ',resposta,'\n');
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.render('listar-projetos.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('cadastrar-projeto.ejs',{ alerta: resposta.erro });
        }
    })
    .catch(error => {
        console.log(error);
        res.redirect('/');
    });
});

// Abrir um projeto pelo nome
router.post('/visualizar', ensureAuthenticated,(req, res) => {
    console.log('entrada do front-end: ', req.body);
    projetoController.exibirProjeto(req)
    .then(resposta => {
        console.log('resposta do back-end: ',resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do filtro com os dados de voluntários que atenderam aos critérios da busca
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizar-projeto.ejs',{ alerta: resposta.erro });
        }
    });
})

router.get('/visualizar', ensureAuthenticated, (req, res) => {
    projetoController.exibirProjeto(req)
    .then(resposta => {
        console.log('resposta do back-end: ', resposta);
        if (!resposta.erro) {
            delete req.session.projNome;
            res.render('visualizacao-projeto.ejs', resposta);
        } else {
            delete req.session.projNome;
            res.render('visualizar-projeto.ejs', { alerta: resposta.erro });
        }
    })
    .catch(error => {
        console.log(error);
        delete req.session.projNome;
        res.redirect('/');
    });
});


/*

#     #    # # #     # # #       # # #    # # # # #    # # # #
#     #    #     #   #     #    #     #       #        #
#     #    # # #     #     #    # # # #       #        # # #
#     #    #         #     #    #     #       #        #
 # # #     #         # # #      #     #       #        # # # #

*/


// Editar a Descrição
router.post('/editar-descricao', ensureAuthenticated, (req, res) => {
    projetoController.editarDescProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com os dados editados
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    });
});

// Editar a Justificativa
router.post('/editar-justificativa', ensureAuthenticated, (req, res) => {
    projetoController.editarJustProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com os dados editados
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    });
});

// Editar os Objetivos
router.post('/editar-objetivos', ensureAuthenticated, (req, res) => {
    projetoController.editarObjeProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com os dados editados
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    });
});

// Editar o Público Alvo
router.post('/editar-publico', ensureAuthenticated, (req, res) => {
    projetoController.editarPublProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if(!resposta.erro){
            // Se não retornar erro renderiza a pagina do projeto com os dados editados
            res.render('visualizacao-projeto.ejs', resposta);
        }else{
            // Em caso de erro renderiza a mesma página sem dados e enviando a mensagem de erro como alert
            res.render('visualizacao-projeto.ejs',{resposta, alerta: resposta.erro });
        }
    })
    .catch(error => {
        console.log('resposta do back-end (com erro): ', error,'\n');
        res.render('criar-atividade.ejs', {alerta: 'Houve um erro no servidor, favor tente mais tarde ou entre em contato com o suporte'});
    });
});

/*

# # #      # # # #    #          # # # #    # # # # #    # # # #
#     #    #          #          #              #        #
#     #    # # #      #          # # #          #        # # #
#     #    #          #          #              #        #
# # #      # # # #    # # # #    # # # #        #        # # # #

*/

// Inativar o Projeto
router.post('/excluir', ensureAuthenticated, (req, res) => {
    projetoController.inativarProjeto(req)
    .then(resposta => {
        console.log(resposta);
        if (!resposta.erro) {
            // Se não retornar erro, redireciona para a página do projeto com os dados editados
            // Aqui você pode adicionar dados na URL como parâmetros de consulta ou usar um sistema de sessão
            res.redirect('/projetos');
        } else {
            // Em caso de erro, redireciona para a mesma página e passa a mensagem de erro na URL como parâmetro de consulta
            res.redirect(`/visualizar-projeto?erro=${encodeURIComponent(resposta.erro)}`);
        }
    })
    .catch(error => {
        console.log(error);
        // Se ocorrer um erro inesperado, redireciona para uma página de erro ou para a mesma página
        res.redirect(`/visualizar-projeto?erro=${
            encodeURIComponent('Ocorreu um erro inesperado.')
        }`);
    });
});


module.exports = router;