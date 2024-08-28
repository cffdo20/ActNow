# ActNow

Link do Repositório GitHub: https://github.com/cffdo20/ActNow.git

Para iniciar os serviços do ActNow, siga as instruções abaixo:

Como iniciar o Banco de Dados:
    Utilizando o serviço MySQL, execute os arquivos com os script .sql que estruturam e povoam o banco de dados.
    Os arquivos estão localizados no diretório '../_Desenvolvimento/Banco de Dados/'.
    Para correto funcionamento do banco de dados execute os arquivos na seguinte sequência:
        1º. 'estruturaBD.sql',
        2º. 'Triggers.sql',
        3º. 'Aux_Functions.sql',
        4º. 'Functions.sql',
        5º. 'Procedures.sql',
        6º. 'povoarBD.sql'.

Como iniciar o servidor da Aplicação WEB:
    Utilizando o serviço NodeJS, execute o arquivo '../index.js'.

    Certifique-se de ter configurado anteriormente as seguintes dependências:
        "ejs": "^3.1.10",
        "express": "^4.19.2",
        "express-session": "^1.18.0",
        "mysql2": "^3.11.0",
        "route": "^0.2.5"

Como acessar a aplicação WEB 'ActNow':
    Utilizando o navegador MSEdge ou Chrome acesse o endereço 'localhost:3000'.

Abaixo apresentamos algumas credenciais de usuários predefinidos no banco de dados que podem ser
interessantes para conhecer/testar a aplicação, mas sinta-se livre para criar o seu próprio usuário:
    
    Opção 1
        login: user123@example.com
        senha: senha

    Opção 2
        login: juliascott@example.org
        senha: senha

    Opção 3
        login: ashleywhite@example.com
        senha; senha

    Opção 4
        login: chrisgreen@email.com
        senha: senha


Abaixo apresentamos algumas opções de filtro de voluntário válidas com os dados já predefinidos no banco
de dados, mas sinta-se livre para criar um voluntário e filtrá-lo de acordo com os parâmetros que você definiu:
    
    Opção 1
        Habilidades: 'Encanador' e/ou 'Bordado'
        Dia da Semana: 'Domingo' ou 'Segunda-Feira'
        Turno: 'Noite'

    Opção 2
        Habilidades: 'Eletricista' e/ou 'Joalheria'
        Dia da Semana: 'Segunda-Feira'
        Turno: 'Tarde'
