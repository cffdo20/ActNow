// Importando a classe Usuario
const Usuario = require('./Usuario');

// Criação da classe ProjetoSocial
class ProjetoSocial {
    // Método construtor para inicializar propriedades
    constructor(idProjeto, tituloProj, descricaoProj, publicoAlvoProj,
      justificativaProj, objetivosProj, dataInicioProj, statusProj) {
      this.idProjeto = idProjeto;
      this.tituloProj = tituloProj;
      this.descricaoProj = descricaoProj;
      this.publicoAlvoProj = publicoAlvoProj;
      this.justificativaProj = justificativaProj;
      this.objetivosProj = objetivosProj;
      this.dataInicioProj = dataInicioProj;
      this.dataFimProj = null;
      this.statusProj = statusProj;
      this.usuario = null;
    }
  
    // Adicionar o Usuario Criador/Gestor do Projeto
    adicionarGestorProj(usuario) {
        if (!(usuario instanceof Usuario)) {
            throw new Error('O parâmetro deve ser uma instância da classe Usuario');
          }
      this.usuario = usuario;
    }
  }

  module.exports = ProjetoSocial;