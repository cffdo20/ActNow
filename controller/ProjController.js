// Importando a classe ProjetoSocial
const ProjetoSocial = require('../model/ProjetoSocial.js');

class ProjController {
    criarProjeto(usuario, idProjeto, tituloProj, descricaoProj,
        publicoAlvoProj, justificativaProj, objetivosProj,
        dataInicioProj, statusProj) {
        
        var novoProjeto = new ProjetoSocial(idProjeto, tituloProj, descricaoProj, publicoAlvoProj,
            justificativaProj, objetivosProj, dataInicioProj, statusProj);
        
        novoProjeto.adicionarGestorProj(usuario);
        
        return novoProjeto;
    }
}

module.exports = new ProjController();
