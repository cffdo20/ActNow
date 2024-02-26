class Usuario {
    // Método construtor para inicializar propriedades
    constructor(idUsuario, userName, email, senha, tipo){
        this.idUsuario = idUsuario;
        this.userName = userName;
        this.email = email;
        this.senha = senha;
        this.tipo = tipo;
    }

    // Método para validar usuário
    validarUsuario(userName, senha){
        // stub do método        
    }


}

class Habilidades{
    // Método construtor
    constructor(nomeHabilidade, nivelDeConhecimento){
        this.nomeHabilidade = nomeHabilidade;
        this.nivelDeConhecimento = nivelDeConhecimento;
    }
}

class Voluntario {
    // Método construtor para inicializar propriedades
    constructor (nome, cpf, telefone, endereco){
        this.nome = nome;
        this.cpf = cpf;
        this.telefone = telefone;
        this.endereco = endereco;
        this.Habilidades = [];
    }
}