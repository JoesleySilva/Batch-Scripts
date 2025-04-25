@echo off
setlocal EnableDelayedExpansion

:menu
cls
echo =====================================
echo         PING IP CHECKER (BATCH)
echo =====================================
echo 1. Modo Lento (Ler IPs do arquivo ipreport.txt)
echo 2. Modo Rápido (Verificar rede 192.168.1.0/24)
echo 0. Sair
echo =====================================
set /p escolha=Digite sua escolha [0-2]:

if "%escolha%"=="1" goto modo_lento
if "%escolha%"=="2" goto modo_rapido
if "%escolha%"=="0" goto sair
goto menu

:modo_lento
cls
echo Executando Modo Lento...
if not exist ipreport.txt (
    echo Arquivo ipreport.txt nao encontrado!
    pause
    goto menu
)
for /f %%i in (ipreport.txt) do (
    echo Verificando %%i...
    ping -n 1 -w 500 %%i | find "Resposta de" > nul
    if !errorlevel! == 0 (
        echo %%i esta ativo
    ) else (
        echo %%i nao respondeu
    )
)
pause
goto menu

:modo_rapido
cls
echo Executando Modo Rapido...
for /L %%i in (1,1,254) do (
    set "ip=192.168.1.%%i"
    ping -n 1 -w 200 !ip! | find "Resposta de" > nul
    if !errorlevel! == 0 (
        echo !ip! esta ativo
    )
)
pause
goto menu

:sair
echo Encerrando...
exit /b
