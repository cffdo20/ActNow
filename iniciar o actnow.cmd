@echo off

:: Primeiro Prompt - Inicia o MySQL
start cmd /k "cd C:\Program Files\MySQL\MySQL Server 8.0\bin\ && mysqld -u root -p actnow24"

:: Segundo Prompt - Inicia o Script Node.js
start cmd /k "cd D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow && node index.js"

:: Terceiro Prompt - Abre o Microsoft Edge com a URL
start msedge "http://localhost:3000/"