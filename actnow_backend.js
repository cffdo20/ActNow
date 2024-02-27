// Importar classes
import Usuario from './classes.js';
import ProjetoSocial from './classes.js';

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

class Habilidades {
  // Método construtor
  constructor(nomeHabilidade, nivelDeConhecimento) {
    this.nomeHabilidade = nomeHabilidade;
  }
}

class Voluntario {
  // Método construtor para inicializar propriedades
  constructor(nome, cpf, telefone, endereco) {
    this.nome = nome;
    this.cpf = cpf;
    this.telefone = telefone;
    this.endereco = endereco;
    this.Habilidades = [];
  }
}

// Criação de um Usuário para Simulação
var usuario1 = new Usuario(1, "usuario1", "usuario@teste.com", "teste123");

// Evento: Usuário decide se inscrever como um voluntário
usuarioVoluntariaSe(usuario1);

function usuarioVoluntariaSe(usuario) {
  let nome1, cpf1, telefone1, endereco1;
  rl.question('Digite o nome: ', (resposta1) => {
    nome1 = resposta1;

    rl.question('Digite o CPF: ', (resposta2) => {
      cpf1 = resposta2;

      rl.question('Digite o Telefone: ', (resposta3) => {
        telefone1 = resposta3;

        rl.question('Digite o Endereço: ', (resposta4) => {
          endereco1 = resposta4;
          let voluntario = new Voluntario(nome1, cpf1, telefone1, endereco1);
          usuario.adicionarVoluntario(voluntario);
          console.log("idUsuario: ", usuario1.idUsuario);
          console.log("e-mail: ", usuario1.email);
          console.log("Nome: ", usuario1.voluntario.nome);
          console.log("CPF: ", usuario1.voluntario.cpf);
          console.log("Telefone: ", usuario1.voluntario.telefone);
          console.log("Endereço: ", usuario1.voluntario.endereco);
          rl.close();
        });
      });
    });
  });

  //return usuario;
}