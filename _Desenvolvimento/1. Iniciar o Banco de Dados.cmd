:: Vá no diretório do seu usuário e crie um arquivo chamado 'my.ini'
:: Este arquivo deve conter o código abaixo:
::	[client]
::	user=(seu usuario do MySQL)
::	password=(sua senha do MySQL)


@echo off
:: Acessar o MySQL, se necessário, mude o diretório de acordo com a versão na linha abaixo.
c:
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"

:: Iniciar o servidor MySQL (caso não esteja em execução), troque a versão se necessário
net start MySQL80

:: Executa o arquivo 'estruturaBD.sql', mude o diretório conforme a necessidade
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\estruturaBD.sql

:: Executa o arquivo 'Triggers.sql'
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\Triggers.sql

:: Executa o arquivo 'povoarBD.sql'
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\povoarBD.sql

:: Executa o arquivo 'Aux_Functions.sql'
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\Aux_Functions.sql

:: Executa o arquivo 'Functions.sql'
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\Functions.sql

:: Executa o arquivo 'Procedures.sql'
mysql < D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow\_Desenvolvimento\Banco de Dados\Procedures.sql