@echo on

color A

xcopy \\E-098386\f\Scripts\PsExec.exe c:\Windows\System32\

Set /P machine= Qual computador deseja HABILITAR O REMOTE DESKTOP:

reg add "\\%machine%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /d 0 /t REG_DWORD /f 

reg add "\\%machine%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fSingleSessionPerUser /t REG_DWORD /d 0 /f

reg add "\\%machine%\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t REG_DWORD /d 0 /f

PAUSE

