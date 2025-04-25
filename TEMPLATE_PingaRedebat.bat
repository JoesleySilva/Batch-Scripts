@echo off
setlocal enabledelayedexpansion

:: Definir a faixa de IPs da rede (substitua 192.168.1 por o seu endereço correto)
set "REDE=192.168.1"

:: Loop de 1 a 254 (padrão para redes IPv4 privadas)
for /L %%i in (1,1,254) do (
    set "IP=!REDE!.%%i"
    ping -n 1 -w 500 !IP! >nul
    if !errorlevel! equ 0 (
        echo [ATIVO] - !IP!
    ) else (
        echo [INATIVO] - !IP!
    )
)

echo.
echo Scan finalizado!
pause
