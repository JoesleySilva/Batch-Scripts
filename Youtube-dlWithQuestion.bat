color c

@echo on


Set /P YOUTUBEADDRESS= Insira o endereço do Youtube:
%YOUTUBEADDRESS%=[digitevalor]

youtube-dl.exe --extract-audio --audio-format flac --audio-quality 0 %YOUTUBEADDRESS%

PAUSE