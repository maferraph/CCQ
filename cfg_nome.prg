/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maurício Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexões de Aço Ltda.                      *
*                               CONF_NOME.PRG
****************************************************************************/

Local nMenu,nLin, cEmpresa, cCliente , cCGC , cEmpresa2 , cCliente2
Local nRec , cCGC2, nN , tAchou , cTela , GetList := {}

Set Century On
Set Date To British
Set Device to Screen
Set Message To 24 Center
Set Confirm On
Set Wrap On
SetColor("GR+/B,B/W+")

cCliente := space(12)

Use FORNE
Use BD New

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @  7 , 28 Say "MENU CONFIGURACOES CLIENTES"
      @ 10 , 22 Say "Digite o apelido do cliente: "
      @ 11 , 22 Get cCliente picture "@!"
      Read
      dbSelectArea( "FORNE" )
      dbGoTop()
      cEmpresa := space(50)
      cCGC := space(18)
      tAchou := .f.

      cCliente2 := space(12)
      cCliente2 := cCliente
      cEmpresa2 := space(50)
      cCGC2 := space(18)

      While ! EOF()
            If RTRIM( FORNE->CLIENTE ) == RTRIM( cCliente )
               cCliente := FORNE->CLIENTE
               cEmpresa := FORNE->EMPRESA
               cCGC     := FORNE->CGC
               cEmpresa2 := cEmpresa
               cCGC2     := cCGC
               nRec := RecNo()
               tAchou := .t.
               exit
            EndIf
            dbSkip()
      End
      
      @ 13 , 22 Say "Digite o nome da empresa do cliente: "
      @ 14 , 22 Get cEmpresa2
      @ 16 , 22 Say "Digite o C.G.C. do cliente: "
      @ 17 , 22 Get cCGC2 picture "@9 99.999.999/9999-99"
      Read

      If RTRIM( cCliente ) <> RTRIM( cCliente2 ) .or. ;
         RTRIM( cEmpresa ) <> RTRIM( cEmpresa2 ) .or. ;
         RTRIM( cCGC ) <> RTRIM( cCGC2 )

         Tone(500,1) ; Tone(300,1) ; Tone(800,2)
         cTela := SaveScreen(10,23,18,61)
         Tela("R+/N,GR+/B",11,24,17,60) 
         SetColor("R+/N,GR+/B")
         @ 11,27 Say "Vocˆ alterou esse registro !!"
         @ 12,33 Say "Deseja salva-lo ?"
         @ 14,33 Prompt "Sim"
         @ 14,46 Prompt "Nao"
         SetColor("GR+/B,B/W+")
         Menu to nN
         If nN = 1 .and. tAchou = .f.
            dbSelectArea( "FORNE" )
            dbGoTop()
            While FORNE->CLIENTE <> space(12)
                  dbSkip( )
            End
            FORNE->CLIENTE := cCliente2
            FORNE->EMPRESA := cEmpresa2
            FORNE->CGC     := cCGC2
            dbSelectArea( "BD" )
            dbGoTop()
            While BD->CLIENTE <> space(12)
                  dbSkip( )
            End
            BD->CLIENTE := cCliente2
            ArrumaBDForne()
         ElseIf nN = 1 .and. tAchou = .t.
            dbSelectArea( "FORNE" )
            dbGoTo( nRec )
            FORNE->CLIENTE := cCliente2
            FORNE->EMPRESA := cEmpresa2
            FORNE->CGC     := cCGC2
            dbSelectArea( "BD" )
            While BD->CLIENTE <> cCliente2
                  dbSkip( )
            End
            BD->CLIENTE := cCliente2
         EndIf
      EndIf
      exit
End

dbCloseAll()
Cls
Clear Typeahead
Return



************************
Function ArrumaBDForne()
************************

Local nArea , aC1 , nN , aC2 , nAsc , nI

nArea := select()
aC1 := aC2 := {}
nAsc := 65

Use FORNE
Use BD New

dbSelectArea( "FORNE" )
dbGoTop()
aC1 := {}
While ! EOF()
      If FORNE->CLIENTE <> space(12)
         Aadd( aC1 , { FORNE->CLIENTE , FORNE->EMPRESA , FORNE->CGC } )
      EndIf
      dbSkip()
End

nN := 1
aC2 := {}
While nAsc <= 90
      For nI = 1 To Len( aC1 )
          If ASC( SUBSTR( aC1[ nI ][1] , 1 ) ) = nAsc
             Aadd( aC2 , { aC1[nI][1] , aC1[nI][2] , aC1[nI][3] } )
          EndIf
      Next
      nAsc++
End

nN := 1
While nN <= Len( aC2 )
      FORNE->CLIENTE := aC2[nN][1]
      FORNE->EMPRESA := aC2[nN][2]
      FORNE->CGC     := aC2[nN][3]
      nN++
      dbSkip()
End

dbSelectArea( "BD" )
dbGoTop()
nN := 1
While nN <= Len( aC2 )
      BD->CLIENTE := aC2[nN][1]
      nN++
      dbSkip()
End

dbCloseArea()
Select( nArea )
Clear Typeahead
Return NIL






