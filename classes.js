class Usuario {
  // Método construtor para inicializar propriedades
  constructor(idUsuario, userName, email, senha) {
    this.idUsuario = idUsuario;
    this.userName = userName;
    this.email = email;
    this.senha = senha;
  }
}

class ProjetoSocial {
  // Método construtor para inicializar propriedades
  constructor(idProjeto, tituloProj, descricaoProj, publicoAlvoProj,
    justificativaProj, objetivosProj, dataInicioProj,
    dataFimProj, statusProj) {
    this.idProjeto = idProjeto;
    this.tituloProj = tituloProj;
    this.descricaoProj = descricaoProj;
    this.publicoAlvoProj = publicoAlvoProj;
    this.justificativaProj = justificativaProj;
    this.objetivosProj = objetivosProj;
    this.dataInicioProj = dataInicioProj;
    this.dataFimProj = dataFimProj;
    this.statusProj = statusProj;
    this.usuario = null;
  }

  // Adicionar o Usuario Criador/Gestor do Projeto
  adicionarGestorProj(usuario) {
    this.usuario = usuario;
  }
}