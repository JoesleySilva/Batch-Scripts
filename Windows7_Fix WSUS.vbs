'Script Begins Here
Dim objNetwork, objDrives, objShell, i, objContainer, strCommand, Num, hostsemnumero, sIDDeleted, sRegKey
Dim regkey, regkey2, regkeyos, CorrigeWindows7, fuso, ajuste
Set objNetwork = WScript.CreateObject("Wscript.Network")
Set objDrives = objNetwork.EnumNetworkDrives
Set objShell = WScript.CreateObject("WScript.Shell")
ON ERROR RESUME NEXT

'############################### COMEÇA O SCRIPT AQUI ###############################
objShell.run "cmd /c echo script_ok>c:\windows\gposcript.txt",6,True
'************************************************************************************
'*            SE O NOME DO HOST TIVER A PALAVRA "SRV" ELE SAI DO SCRIPT             *
'************************************************************************************

'Verifica se e SERVIDOR e se for nao executa nada daqui pra frente
If NomeHostContem("srv") = 1 Then Wscript.Quit
If NomeHostContem("VPN_RRAS") = 1 Then Wscript.Quit
If NomeHostContem("c1vm") = 1 Then Wscript.Quit
If NomeHostContem("c2vm") = 1 Then Wscript.Quit
If NomeHostContem("c1sb") = 1 Then Wscript.Quit
If NomeHostContem("c2sb") = 1 Then Wscript.Quit
objShell.run "cmd /c echo PASSOU_NAO_SERVIDOR>>c:\windows\gposcript.txt",6,True
'************************************************************************************
'*                             CORRECAO PARA WINDOWS 7                              *
'************************************************************************************

regkeyos = objshell.RegRead ("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName")
CorrigeWindows7 = InStr(1,regkeyos,"Windows 7")
If CorrigeWindows7 = "1" Then

	regkey = objShell.RegRead ("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLinkedConnections")
	If regkey = "" Then
		objShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLinkedConnections", 1, "REG_DWORD"
	End If
    
	regkey2 = objShell.RegRead ("HKCU\Control Panel\Desktop\Wallpaper")
	If regkey2 = "" Then
		objShell.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", 1, "REG_SZ"
	End If
End If
objShell.run "cmd /c echo PASSOU_WINDOWS_7>>c:\windows\gposcript.txt",6,True
'************************************************************************************
'*                      	  CORREÇÕES WSUS	                            *
'************************************************************************************

sRegKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate"
sIDDeleted = objShell.RegRead( sRegKey & "\IDDeleted")

If sIDDeleted <> "yes" Then
   ' delete values
   objShell.RegDelete sRegKey & "\AccountDomainSid"
   objShell.RegDelete sRegKey & "\PingID"
   objShell.RegDelete sRegKey & "\SusClientId"
   objShell.Run "%SystemRoot%\system32\net.exe stop wuauserv", 6, True
   objShell.Run "%SystemRoot%\system32\net.exe start wuauserv", 6, True
   objShell.Run "%SystemRoot%\system32\wuauclt.exe /resetauthorization /detectnow", 6, True
   objShell.RegWrite sRegKey & "\IDDeleted", "yes"
End If
objShell.run "cmd /c echo PASSOU_CORRECOES_WSUS>>c:\windows\gposcript.txt",6,True
'************************************************************************************
'*                      	  COMUM A TODOS		                            *
'************************************************************************************



'************************************************************************************
'*                       POR TIPO DE COMPUTADOR (est OU anx)                        *
'************************************************************************************
hostsemnumero = NomeHostSemNumero
	Select Case hostsemnumero

	Case "anx"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Start Page", "http://intranet", "REG_SZ"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL", "http://intranet", "REG_SZ"
'			'Mapeando unidades de rede...
'			Mapeia "T:", "\\srvh415-b\temp"
'			Mapeia "H:", "\\srvh415-b\APLIC"
'			Mapeia "R:", "\\srvh415-b\publico"

'			objNetwork.RemovePrinterconnection "\\servidor\impressora"
'			objNetwork.AddWindowsPrinterConnection "\\servidor\impressora"
'			objNetwork.Setdefaultprinter("\\servidor\impressora")
'			ExecScripts "\\servidor_dc\netlogon\PASTA\"
'
	Case "dnrc"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Start Page", "http://intranet", "REG_SZ"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL", "http://intranet", "REG_SZ"
'			'Mapeando unidades de rede...
'			Mapeia "T:", "\\srvh415-b\temp"
'			Mapeia "H:", "\\srvh415-b\APLIC"
'			Mapeia "R:", "\\srvh415-b\publico"

'			objNetwork.RemovePrinterconnection "\\servidor\impressora"
'			objNetwork.AddWindowsPrinterConnection "\\servidor\impressora"
'			objNetwork.Setdefaultprinter("\\servidor\impressora")
'			ExecScripts "\\servidor_dc\netlogon\PASTA\"
'
	Case "est"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Start Page", "http://intranet", "REG_SZ"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL", "http://intranet", "REG_SZ"
'			'Mapeando unidades de rede...
'			Mapeia "T:", "\\srvh415-b\temp"
'			Mapeia "H:", "\\srvh415-b\APLIC"
'			Mapeia "R:", "\\srvh415-b\publico"

'			objNetwork.RemovePrinterconnection "\\servidor\impressora"
'			objNetwork.AddWindowsPrinterConnection "\\servidor\impressora"
'			objNetwork.Setdefaultprinter("\\servidor\impressora")
'			ExecScripts "\\servidor_dc\netlogon\PASTA\"
'
	Case "jcdf"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Start Page", "http://intranet", "REG_SZ"
			objShell.RegWrite "HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL", "http://intranet", "REG_SZ"
'			'Mapeando unidades de rede...
'			Mapeia "H:", "\\10.29.255.10\APLIC"

'			objNetwork.RemovePrinterconnection "\\servidor\impressora"
'			objNetwork.AddWindowsPrinterConnection "\\servidor\impressora"
'			objNetwork.Setdefaultprinter("\\servidor\impressora")
'			ExecScripts "\\servidor_dc\netlogon\PASTA\"
'
	Case "not"
'			'Mapeando unidades de rede...
'			Mapeia "H:", "\\10.29.255.10\APLIC"
'			objNetwork.RemovePrinterconnection "\\servidor\impressora"
'			objNetwork.AddWindowsPrinterConnection "\\servidor\impressora"
'			objNetwork.Setdefaultprinter("\\servidor\impressora")
'			ExecScripts "\\servidor_dc\netlogon\PASTA\"
'

	Case Else
		

	End Select

objShell.run "cmd /c echo PASSOU_TIPO_COMPUTADOR>>c:\windows\gposcript.txt",6,True
'
'************************************************************************************
'*                        MAPEANDO DE ACORDO COM O "MEMBER OF"                      *
'************************************************************************************
'
Set objSysInfo = CreateObject("ADSystemInfo")
strUserPath = "LDAP://" & objSysInfo.UserName
Set objUser = GetObject(strUserPath)
For Each strGroup in objUser.MemberOf
	strGroupPath = "LDAP://" & strGroup
	Set objGroup = GetObject(strGroupPath)
	strGroupName = objGroup.CN
	Select Case strGroupName


'********* Gabinete do Ministro - MDIC/GM **************************

 		Case "FS-READ-MDIC_GM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_GM_ASPAR"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASPAR"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_GM_ASTEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASTEC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_GM_ASTEC_PROTOCOLO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASTEC\PROTOCOLO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_GM_ASCOM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASCOM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_GM_ASINT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASINT"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_GM_GABINETE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\GABINETE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        	Case "FS-READ-MDIC_GM_CERIMONIAL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\CERIMONIAL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
	    	Case "FS-READ-MDIC_GM_OUVIDORIA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\OUVIDORIA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_GM_SEPECADM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\SEPEC-ADM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_GM_ASSESSORIA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\ASSESSORIA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"	

		Case "FS-READ-MDIC_GM_AECI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_GM$"
			Mapeia "P:", "\\FILESERVER\mdic$\GM\AECI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"			

'********* Secretaria de Comércio e Serviços- MDIC/SCS **************************

' 		Case "FS-READ-SIARCO"
'			Mapeia "X:", "\\FILESERVER\SIARCO$"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"
'
'
'		Case "FS-READ-SIARCOIIV4"
'			Mapeia "Y:", "\\FILESERVER\SIARCOiiV4$"
'		    DesconectarUnidade "Z:"
'		    DesconectarUnidade "H:"
'			DesconectarUnidade "T:"



'********* Secretaria Executiva - MDIC/SE **************************


		Case "FS-READ-MDIC_SE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\GAB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SE_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_ASSESSORIA-TEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\ASSESSORIA-TEC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SUPE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SUPE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_ASTEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\ASTEC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_COORD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\COORD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SE-ADJUNTO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SE-ADJUNTO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SE-ADJUNTO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SE-ADJUNTO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'********* Secretaria de Gestão Corporativa - MDIC/SE/SGC **************************


		Case "FS-READ-MDIC_SE_SGC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SGC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SGC_DAL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SGC\DAL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SGC_DAL_CGGAL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SGC\DAL\CGGAL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


'********* Subsecretaria de Planejamento, Orçamento e Administração - MDIC/SE/SPOA **************************

 		Case "FS-READ-MDIC_SE_SPOA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\GAB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGAU"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGAU"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'********* Coordenação-Geral de Modernização e Informática - MDIC/SE/SPOA/CGMI **************************

 		Case "FS-READ-MDIC_SE_SPOA_CGMI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_APOIO.CGMI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\APOIO.CGMI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_DIDOB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\DIDOB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_DIDOB_SEPRO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\DIDOB\SEPRO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_HDESK"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\HDESK"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_HDESK_PRESTADOR.HDESK"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\HDESK\PRESTADOR.HDESK"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_INFRA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\INFRA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_INFRA_PRESTADOR.INFRA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\INFRA\PRESTADOR.INFRA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_BD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\BD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_BD_PRESTADOR.BD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\BD\PRESTADOR.BD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COSIM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COSIM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_CONFIDERE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\CONFIDERE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COSIM_DESENV"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COSIM\DESENV"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_COSIM_DESENV_PRESTADOR.DESENV"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COSIM\DESENV\PRESTADOR.DESENV"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_MODERNIZACAO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\MODERNIZACAO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_NUCLEOS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\NUCLEOS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
			Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_BD_Projeto.BI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\BD\Projeto.BI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
'			Case "FS-READ-MDIC_SE_SPOA_CGMI_COIES_BD_Projeto.BI_PROJETO_PILOTO"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\COIES\BD\Projeto.BI\PROJETO_PILOTO"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGMI_SETEL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\SETEL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-TARIFADOR"
			Mapeia "T:", "\\FILESERVER\TARIFADOR$"


		Case "FS-READ-MDIC_SE_SPOA_CGMI_GOVERNANCA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGMI$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGMI\GOVERNANCA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		


'********** Coodenadoria Geral de Recursos Humanos MDIC\SE\SPOA\CGRH*****************			

        Case "FS-READ-MDIC_SE_SPOA_CGRH"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_CODAS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\CODAS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_COLEG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\COLEG"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_COPES"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\COPES"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

       Case "FS-READ-MDIC_SE_SPOA_CGRH_DIPAG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\DIPAG"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\GAB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
        Case "FS-READ-MDIC_SE_SPOA_CGRH_SEAMS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\SEAMS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_SEDIP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\SEDIP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

       Case "FS-READ-MDIC_SE_SPOA_CGRH_SERAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\SERAP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

       Case "FS-READ-MDIC_SE_SPOA_CGRH_DICAD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\DICAD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SE_SPOA_CGRH_SOFRH"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRH$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRH\SOFRH"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'********* Coordenação-Geral de Recursos Logísticos - MDIC/SE/SPOA/CGRL **************************

 		Case "FS-READ-MDIC_SE_SPOA_CGRL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CCONV"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CCONV"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_SEDAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\SEDAP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_SEDAP_SEARQ"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\SEDAP\SEARQ"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_SEDAP_SEDOB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\SEDAP\SEDOB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_SEDAP_SEPRO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\SEDAP\SEPRO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CCONV_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CCONV\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CCONV_DICOV"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CCONV\DICOV"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CCONV_SECON"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CCONV\SECON"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CEORF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CEORF"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_CEORF_DIPAS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\CEORF\DIPAS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_COATA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COATA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_COATA_DIMPA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COATA\DIMPA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_COATA_ENGENHARIA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COATA\ENGENHARIA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_COATA_ENGENHARIA_SEPRE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COATA\ENGENHARIA\SEPRE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"



		Case "FS-READ-MDIC_SE_SPOA_CGRL_COPLI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COPLI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_COPLI_SECOP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\COPLI\SECOP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_GAB.CGRL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\GAB.CGRL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

        	Case "FS-READ-MDIC_SE_SPOA_CGRL_NUTRA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\NUTRA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SE_SPOA_CGRL_NUCON"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGRL$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGRL\NUCON"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


'********* Secretaria de Inovação - MDIC/SIN **************************

   		Case "FS-READ-MDIC_SIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_SIN_DEFIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN\DEFIN"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"



 		Case "FS-READ-MDIC_SIN_DETIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN\DETIN"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_SIN_DETIN_PI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN\DETIN\PI"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_SIN_GAB.SIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN\GAB.SIN"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SIN_DETIN_PRONATEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SIN$"
			Mapeia "P:", "\\FILESERVER\mdic$\SIN\DETIN\PRONATEC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'********* Secretaria Executiva do Conselho Nacional das Zonas de Processamento de Exportação - MDIC/CZPE **************************

 		Case "FS-READ-MDIC_CZPE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CZPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\CZPE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_CZPE_SEADM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CZPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\CZPE\SEADM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_CZPE_CGPF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CZPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\CZPE\CGPF"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_CZPE_CGAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CZPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\CZPE\CGAP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'********* Secretária Executiva da Câmara de Comércio Exterior - MDIC/CAMEX **************************

		Case "FS-READ-MDIC_CAMEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CAMEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\CAMEX"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_CAMEX_SE_1"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CAMEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\CAMEX\SE_1"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_CAMEX_SE_2"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CAMEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\CAMEX\SE_2"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"


'********* Secretaria de Comércio Exterior - MDIC/SECEX **************************

		Case "FS-READ-MDIC_SECEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
		Case "FS-READ-MDIC_SECEX_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\GAB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
		Case "FS-READ-MDIC_SECEX_GAB_COOAD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\GAB\COOAD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
		Case "FS-READ-MDIC_SECEX_GAB_DIVAD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\GAB\DIVAD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"
			
		Case "FS-READ-MDIC_SECEX_DEPLA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEAEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEAEX_CGDE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGDE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEAEX_CGET"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGET"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEAEX_CGET_ANALISE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGET\ANALISE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SECEX_DEAEX_CGET_PORTAL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGET\PORTAL"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SECEX_DEAEX_CGET_PRODUCAO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGET\PRODUCAO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

Case "FS-READ-MDIC_SECEX_DEAEX_CGET_BCBPESQUISA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEAEX\CGET\BCBPESQUISA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"



		Case "FS-READ-MDIC_SECEX_DEPLA_CGAD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA\CGAD"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEPLA_CGAD_BCB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA\CGAD\BCB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEPLA_CGAD_PBCE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA\CGAD\PBCE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

	 	Case "FS-READ-MDIC_SECEX_DEPLA_CGPE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA\CGPE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEPLA_CGDE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEPLA\CGDE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DECOM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

'		Case "FS-READ-MDIC_SECEX_DECOM_CGAP-CGPI"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOM\CGAP-CGPI"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

'              Case "FS-READ-MDIC_SECEX_DECOM_CGDI"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOM\CGDI"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

'        Case "FS-READ-MDIC_SECEX_DECOM_CGDI_GABINETE"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOM\CGDI\GABINETE"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
                        Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX_GABIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\GABIN"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX_CGIS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\CGIS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX_COEXC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\COEXC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX_CGEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\CGEX"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


        Case "FS-READ-MDIC_SECEX_DECEX_CGIM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\CGIM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SECEX_DECEX_COIMP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\COIMP"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SECEX_DECEX_INSTRUCOES"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECEX\INSTRUCOES"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SECEX_DEINT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGNR"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGNR"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGOM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGOM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGER"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGER"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGTM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGTM"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGCB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGCB"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGDC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGDC"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DEINT_CGRO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\CGRO"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"
                
               Case "FS-READ-MDIC_SECEX_DEINT_SECRETARIAS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DEINT\SECRETARIAS"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DECOE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOE"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DECOE_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOE\APOIO"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DECOE_CGPT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOE\CGPT"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SECEX_DECOE_CGNF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SECEX$"
			Mapeia "P:", "\\FILESERVER\mdic$\SECEX\DECOE\CGNF"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		


'********* Secretaria de Comércio e Serviços - MDIC/SCS **************************

		Case "FS-READ-MDIC_SCS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SCS_APOIO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\APOIO"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SCS_CGPC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\CGPC"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

	Case "FS-READ-MDIC_SCS_CGPS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\CGPS"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

'        Case "FS-READ-MDIC_SCS_DEPME"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SCS\DEPME"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SCS_DNRC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\DNRC"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SCS_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\GAB"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SCS_GabCriseJCDF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SCS$"
			Mapeia "P:", "\\FILESERVER\mdic$\SCS\GabCriseJCDF"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"





'********* SECRETARIA DE DESENVOLVIMENTO E PRODUÇÃO - MDIC/SDP**************************

        Case "FS-READ-MDIC_SDP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

        Case "FS-READ-MDIC_SDP_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\GAB"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_GAB_CGEII"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\GAB\CGEII"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_GAB_DIADM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\GAB\DIADM"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_GAB_APOIO-SDIC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\GAB\APOIO-SDIC"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_GAB_DIARIAS-PASSAGENS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\GAB\DIARIAS-PASSAGENS"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DEIET"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEIET"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DEIET_CGMR"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEIET\CGMR"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DEIET_CGAT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEIET\CGAT"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SDP_DEIET_CGAE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEIET\CGAE"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DESIT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DESIT"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

 		Case "FS-READ-MDIC_SDP_DESIT_CGBC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DESIT\CGBC"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DESIT_CGEL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DESIT\CGEL"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DESIT_CGTP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DESIT\CGTP"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DECOI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DECOI_ESTATISTICA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\ESTATISTICA"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DECOI_CGAL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\CGAL"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SDP_DECOI_RENAI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\RENAI"


		Case "FS-READ-MDIC_SDP_DECOI_CGACDS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\CGACDS"


		Case "FS-READ-MDIC_SDP_DEORN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEORN"



		Case "FS-READ-MDIC_SDP_DEORN_CGAG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEORN\CGAG"



		Case "FS-READ-MDIC_SDP_DEORN_CGRN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEORN\CGRN"



		Case "FS-READ-MDIC_SDP_DEORN_CGMO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DEORN\CGMO"

		
'		Case "FS-READ-MDIC_SDP_DECOI_CGIV"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\CGIV"

		Case "FS-READ-MDIC_SDP_DECOI_CGPI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\CGPI"


		Case "FS-READ-MDIC_SDP_CGGPI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\CGGPI"

		Case "FS-READ-MDIC_SDP_CGICP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\CGICP"

		Case "FS-READ-MDIC_SDP_DECOI_RENAI-ANTIGO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\RENAI-ANTIGO"

'		Case "FS-READ-MDIC_SDP_DECOI_GABINETE"
'			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
'			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
'			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
'			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\GABINETE"
'			DesconectarUnidade "Z:"
'			DesconectarUnidade "H:"
'			DesconectarUnidade "T:"


		Case "FS-READ-MDIC_SDP_DECOI_DIRETORIA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SDP$"
			Mapeia "P:", "\\FILESERVER\mdic$\SDP\DECOI\DIRETORIA"
			DesconectarUnidade "Z:"
			DesconectarUnidade "H:"
			DesconectarUnidade "T:"

		Case "FS-READ-MDIC_SEPEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC"

		Case "FS-READ-MDIC_SEPEC_SEAE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SEAE"

		Case "FS-READ-MDIC_SEPEC_SEAE_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SEAE\GAB"

		Case "FS-READ-MDIC_SEPEC_SDIC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\GAB"

		Case "FS-READ-MDIC_SEPEC_SDI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI"

		Case "FS-READ-MDIC_SEPEC_SDI_SIEM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SIEM"

		Case "FS-READ-MDIC_SEPEC_SDI_SRM"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SRM"
		
		Case "FS-READ-MDIC_SEPEC_SDI_SRM_CGE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SRM\CGE"
		
		Case "FS-READ-MDIC_SEPEC_SDI_SRM_CGL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SRM\CGL"

		Case "FS-READ-MDIC_SEPEC_SDI_SRM_CGS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SRM\CGS"
	
		Case "FS-READ-MDIC_SEPEC_SDI_SRM_CGT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDI\SRM\CGT"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGED"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGED"
	
		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGAP"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGSP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGSP"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGANS"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGANS"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGANS_CERES"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGANS\CERES"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGAP_CCAPL"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGAP\CCAPL"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGSP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGSP"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGFN_DIPPB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGFN\DIPPB"
		
		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGFN_CODIA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGFN\CODIA"

		Case "FS-READ-MDIC_SEPEC_SDIC_SI_CGFN_DIVEX"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEPEC\SDIC\SI\CGFN\DIVEX"

		
'********* Coordenação-Geral de Planejamento Orçamento e Finanças - MDIC/SE/SPOA/CGOF **************************

		Case "FS-READ-MDIC_SE_SPOA_CGOF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF"


		Case "FS-READ-MDIC_SE_SPOA_CGOF_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF\GAB"


		Case "FS-READ-MDIC_SE_SPOA_CGOF_COFIN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF\COFIN"


		Case "FS-READ-MDIC_SE_SPOA_CGOF_COPLA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF\COPLA"


		Case "FS-READ-MDIC_SE_SPOA_CGOF_CPROG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF\CPROG"


		Case "FS-READ-MDIC_SE_SPOA_CGOF_CCONT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SE_SPOA_CGOF$"
			Mapeia "P:", "\\FILESERVER\mdic$\SE\SPOA\CGOF\CCONT"



'********* Consultoria Juridica - MDIC/CONJUR **************************


	 	Case "FS-READ-MDIC_CONJUR"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR"


	 	Case "FS-READ-MDIC_CONJUR_COAJA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA"


		Case "FS-READ-MDIC_CONJUR_COAJA_DIAAD"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\DIAAD"


		Case "FS-READ-MDIC_CONJUR_COAJA_DIAAN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\DIAAN"



		Case "FS-READ-MDIC_CONJUR_COAJA_DIAAN"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\DIAAN"


		Case "FS-READ-MDIC_CONJUR_COAJA_DIAJU"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\DIAJU"


		Case "FS-READ-MDIC_CONJUR_COAJA_DIACC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\DIACC"


		Case "FS-READ-MDIC_CONJUR_COAJA_SELEJ"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\COAJA\SELEJ"



		Case "FS-READ-MDIC_CONJUR_SEATA"
			Mapeia "s:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\SEATA"

			
			Case "FS-READ-MDIC_CONJUR_SEATA_APOIO"
			Mapeia "s:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_CONJUR$"
			Mapeia "P:", "\\FILESERVER\mdic$\CONJUR\SEATA\APOIO"

			
			
'********* Consultoria Juridica - MDIC/SUFRAMA **************************

			Case "FS-READ-MDIC_SUFRAMA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SUFRAMA$"
			Mapeia "P:", "\\FILESERVER\mdic$\SUFRAMA"

			
'*********Comissao de Etica - MDIC/CE ************************************

			Case "FS-READ-MDIC_CE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_COMISSAO$"
			Mapeia "P:", "\\FILESERVER\mdic$\CE"
			
'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE ************************************

			Case "FS-READ-MDIC_SEMPE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/DAMPE ************************************

			Case "FS-READ-MDIC_SEMPE_DAMPE"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\DAMPE"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/DEART ************************************

			Case "FS-READ-MDIC_SEMPE_DEART"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\DEART"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/DREI ************************************

			Case "FS-READ-MDIC_SEMPE_DREI"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\DREI"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/GAB ************************************

			Case "FS-READ-MDIC_SEMPE_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\GAB"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/GAB/ASGAB ************************************

			Case "FS-READ-MDIC_SEMPE_GAB_ASGAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\GAB\ASGAB"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/GAB/PROT ************************************

			Case "FS-READ-MDIC_SEMPE_GAB_PROT"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\GAB\PROT"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/GAB/SEC ************************************

			Case "FS-READ-MDIC_SEMPE_GAB_SEC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\GAB\SEC"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/JCDF ************************************

			Case "FS-READ-MDIC_SEMPE_JCDF"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\JCDF"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/JCDF/GAB ************************************

			Case "FS-READ-MDIC_SEMPE_JCDF_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\JCDF\GAB"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/JCDF/DSC ************************************

			Case "FS-READ-MDIC_SEMPE_JCDF_DSC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\JCDF\DSC"

'*********Secretaria de Micro e Pequena Empresa - MDIC/SEMPE/JCDF/SG ************************************

			Case "FS-READ-MDIC_SEMPE_JCDF_SG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_MDIC_SEMPE$"
			Mapeia "P:", "\\FILESERVER\mdic$\SEMPE\JCDF\SG"




'*********Secretaria de Aquicultura e Pesca - SAP/ ************************************

			Case "FS-READ-SAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$"


'*********Secretaria de Aquicultura e Pesca - SAP/GAB ************************************

			Case "FS-READ-SAP_GAB"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\GAB"

'*********Secretaria de Aquicultura e Pesca - SAP/CAO ************************************

			Case "FS-READ-SAP_CAO"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\CAO"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOA ************************************

			Case "FS-READ-SAP_DPOA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOA"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOA/CG ************************************

			Case "FS-READ-SAP_DPOA_CG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOA\CG"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOA/CG/CAAU ************************************

			Case "FS-READ-SAP_DPOA_CG_CAAU"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOA\CG\CAAU"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOA/CG/CPOA ************************************

			Case "FS-READ-SAP_DPOA_CG_CPOA"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\CPOA\CG\CPOA"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOP ************************************

			Case "FS-READ-SAP_DPOP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOP"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOP/CG ************************************

			Case "FS-READ-SAP_DPOP_CG"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOP\CG"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOP/CG/C1 ************************************

			Case "FS-READ-SAP_DPOP_CG_C1"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOP\CG\C1"

'*********Secretaria de Aquicultura e Pesca - SAP/DPOP/CG/C2 ************************************

			Case "FS-READ-SAP_DPOP_CG_C2"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DPOP\CG\C2"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC ************************************

			Case "FS-READ-SAP_DRMC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGMC ************************************

			Case "FS-READ-SAP_DRMC_CGMC"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGMC"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGMC/C1 ************************************

			Case "FS-READ-SAP_DRMC_CGMC_C1"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGMC\C1"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGMC/C2 ************************************

			Case "FS-READ-SAP_DRMC_CGMC_C2"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGMC\C2"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGRAP ************************************

			Case "FS-READ-SAP_DRMC_CGRAP"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGRAP"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGRAP/C1 ************************************

			Case "FS-READ-SAP_DRMC_CGRAP_C1"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGRAP\C1"

'*********Secretaria de Aquicultura e Pesca - SAP/DRMC/CGRAP/C2 ************************************

			Case "FS-READ-SAP_DRMC_CGRAP_C2"
			Mapeia "S:", "\\FILESERVER\SISTEMAS_MDIC$"
			Mapeia "M:", "\\FILESERVER\PUBLICO_MDIC$"
			Mapeia "N:", "\\FILESERVER\PUBLICO_SAP$"
			Mapeia "P:", "\\FILESERVER\SAP$\DRMC\CGRAP\C2"


'*********Arquivos Scaneados DNRC-JUNTA COMERCIAL DO DISTRITO FEDERAL*******************************************
        Case "FS-READ-AUTOS"
			Mapeia "A:", "\\FILESERVER\AUTOS$"

		Case "FS-READ-SCANEADOS-JCDF"
			Mapeia "O:", "\\FILESERVER\SCANEADOS-JCDF$"	

		Case "FS-READ-MDIC_CT01DBN"
			Mapeia "G:", "\\FILESERVER\CT01DBN$"					





		Case Else

	End Select

Next

objShell.run "cmd /c echo PASSOU_MEMBEROF>>c:\windows\gposcript.txt",6,True
'
'############################### FUNCOES ###############################

Sub Mapeia(sDrive, sShare)
	For i = 0 to objDrives.Count -1 Step 2
	if LCase(sDrive) = LCase(objDrives.Item(i)) then
		if not LCase(sShare) = LCase(objDrives.Item(i+1)) then
			objNetwork.RemoveNetworkDrive sDrive, true, true
		Else
			Exit Sub
		End if
	End if
	Next
	on error resume next
	objNetwork.MapNetworkDrive sDrive, sShare
	on error goto 0
End Sub

Function NomeHostContem(strSubString)
	dim strSearchString,WshNetwork
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	strSearchString = LCase(WshNetwork.ComputerName)
	NomeHostContem = InStr(1,strSearchString,strSubString)
End Function

Function NomeHostSemNumero
	dim strSearchString,WshNetwork
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	strSearchString = LCase(WshNetwork.ComputerName)
	For Num = 0 To 9
		strSearchString = Replace(strSearchString, Num, "")
	Next
	NomeHostSemNumero = strSearchString
End Function

Sub ConnectContainer(strContainer)
	Set objRootDSE = GetObject("LDAP://rootDSE")
	If strContainer = "" Then
		Set objContainer = GetObject("LDAP://" & _
		objRootDSE.Get("defaultNamingContext"))
	Else
		Set objContainer = GetObject("LDAP://" & strContainer & "," & _
		objRootDSE.Get("defaultNamingContext"))
	End If
End Sub

Function GetUserOU
	Set sys = CreateObject("ADSystemInfo")
	arrAux = split(sys.UserName,",",-1,1)
	intArrLength = UBound(arrAux)
	strContainer = ""
	For i=0 to intArrLength
		If LCase(Left(arrAux(i),2)) = "ou" Then
			If strContainer = "" Then
				strContainer = arrAux(i)
			Else
				strContainer = strContainer & "," & arrAux(i)
			End If
		End If
	Next
	GetUserOU = strContainer
End Function

Sub ConnectPublishedFolders
	ConnectContainer GetUserOU
	objContainer.Filter = Array("volume")
	For Each objVol In objContainer
		MapearUnidade objVol.Description,objVol.UNCName
	Next
End Sub

Function ExecCommand(strCommand)
	Dim WshShell, oExec
	Set WshShell = CreateObject("WScript.Shell")
	ExecCommand = WshShell.Run(strCommand,0)
	strCommand = ""
End Function

Sub ExecScriptsPadrao
	Dim objFSO,objFolder,colFiles,objFile, objDC, strFolder
	Set objDomain = GetObject("LDAP://rootDse")
	objDC = objDomain.Get("dnsHostName")
	strFolder = "\\"&objDC&"\netlogon\padrao\"
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(strFolder)
	Set colFiles = objFolder.Files
	For Each objFile in colFiles
		If LCase(Right(objFile.Name,4)) = ".bat" Then
			strCommand = "cmd /c "& strFolder & objFile.Name
			ExecCommand(strCommand)
		End If
	Next
End Sub

Sub ExecScripts(strFolder)
	Dim objFSO,objFolder,colFiles,objFile
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(strFolder)
	Set colFiles = objFolder.Files
	For Each objFile in colFiles
		If LCase(Right(objFile.Name,4)) = ".bat" Then
			strCommand = "cmd /c "& strFolder & objFile.Name
			ExecCommand(strCommand)
		End If
	Next
End Sub

Sub DesconectarUnidade(strDrive)
	Dim WshNetwork
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	WshNetwork.RemoveNetworkDrive strDrive, true, true
End Sub

Sub MapearUnidade(strDrive, strShare)
	Dim WshNetwork
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	WshNetwork.MapNetworkDrive strDrive, strShare
End Sub

'*********Senha Administrador Local ************************************
'	strComputer = "."
'	Set colAccounts = GetObject("WinNT://" & strComputer & ",computer")
'	Set objUser = GetObject("WinNT://" & strComputer & "/Hdesk, user")
'	objUser.SetPassword "CSmdic#318#"
'	objUser.SetInfo

Sub ajustehorario
	objShell.run "cmd /c ""net time \\C1VM51.mdic.gov.br /set /y""",6,True
	objShell.run "cmd /c ""\\c1vm51\NETLOGON\Timezone\CmdHV /TZ:E. South America Standard Time /E""",6,True
	objShell.run "cmd /c ""\\c1vm51\NETLOGON\Timezone\CmdHV /TZ:E. South America Standard Time /HI:2015-10-17 /HF:2016-02-21 /S:1""",6,True
	objShell.run "cmd /c ""\\c1vm51\NETLOGON\Timezone\CmdHV /s 00:0:3:10 00:0:3:02""",6,True
	objShell.run "cmd /c ""net time \\C1VM51.mdic.gov.br /set /y""",6,True
End Sub


'############################### END ###############################
