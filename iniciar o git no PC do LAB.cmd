@echo
d:
cd D:\Salve_Aqui_Seus_Arquivos\DIOGO\ActNow
git config --global --add safe.directory D:/Salve_Aqui_Seus_Arquivos/DIOGO/ActNow
git config --global --unset safe.directory 'D:/Salve_Aqui_Seus_Arquivos/DIOGO/ActNow'
git config --global --get-all safe.directory