:: Vá no diretório do seu usuário e crie um arquivo chamado 'my.ini'
:: Este arquivo deve conter o código abaixo:
::	[client]
::	user=(seu usuario do MySQL)
::	password=(sua senha do MySQL)


@echo off
:: Acessar o MySQL, se necessário, mude o diretório de acordo com a versão na linha abaixo.
cd "C:\Program Files\MySQL\MySQL Server 8.3\bin"

:: Iniciar o servidor MySQL (caso não esteja em execução), troque a versão se necessário
net start MySQL83

:: Executa o arquivo 'estruturaBD.sql', mude o diretório conforme a necessidade
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\estruturaBD.sql

:: Executa o arquivo 'Triggers.sql'
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\Triggers.sql

:: Executa o arquivo 'povoarBD.sql'
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\povoarBD.sql

:: Executa o arquivo 'Aux_Functions.sql'
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\Aux_Functions.sql

:: Executa o arquivo 'Functions.sql'
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\Functions.sql

:: Executa o arquivo 'Procedures.sql'
mysql < C:\Users\josed\ActNow\_Desenvolvimento\Banco de Dados\Procedures.sql