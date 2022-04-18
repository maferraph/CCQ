/***************************************************************************\
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               CONF_LAM.PRG                                *
****************************************************************************/

#Include "Inkey.ch"

Local nLin,nMenu_Conex,xFig,xBit,xLam,xMat,xCor,aFig,nMT,cTela,nTam,nN,aCor
Local cCor,cCor2,aTab,aVaz,aDisp,nOp,aMenu
Local GetList := {}

xFig := xBit := space(12)
xLam := xMat := space(10)
xCor := cCor := cCor2 := space(10)
aFig := aCor := aTab := aVaz := aDisp := aMenu := {}
nN := nTam := nOp := 0

Use LAMINADO Index LAMINADO 
Use CF_CO_LA Index CF_CO_LA New 
Use CORR_LAM Index CORR_LAM New 

While .T.
      dbSelectArea("LAMINADO")
      MontaTela()
      SetColor("GR+/B,B/W+")
      @ 7,29 Say "CONFIGURA€AO LAMINADOS"
      @ 10,29 Say "Figura  :" Get xFig picture "@!"
      @ 12,29 Say "Bitola  :" Get xBit picture "@!"
      @ 14,29 Say "Laminado:" 
      @ 16,29 Say "Material:" 
      @ 18,29 Say "Corrida :"
      read
      dbGoTop()
      If Empty ( xFig + xBit) .or. LastKey() = 27
         Exit
      Endif
      dbSeek( xFig )
      If !Found()
         tone(200,2)
         cTela := SaveScreen(11,17,19,67)
         Tela("R+/N,GR+/B",12,18,18,67) 
         SetColor("R+/N,GR+/B")
         @ 12,19 Say "Esse registro nao existe nesse Banco de Dados" color "GR+*/N"
         @ 14,23 Say "   Deseja incluir novo registro ?    "
         @ 16,33 Prompt "Sim"
         @ 16,46 Prompt "Nao"
         SetColor("GR+/B,B/W+")
         Menu to nMT
         If nMT = 1
            RestScreen(11,17,19,67,cTela)
            @ 14,29 Say "Laminado:" Get xLam picture "@!"
            @ 16,29 Say "Material:" Get xMat picture "@!"
            @ 18,29 Say "Corrida :"
            Read



            @ 19,26 Say "Deseja salvar esse registro ?"
            @ 20,33 Prompt "Sim"
            @ 20,46 Prompt "Nao"
            Menu To nN
            If nN = 1
               dbAppend()
               LAMINADO->FIGURA   := xFig
               LAMINADO->BITOLA   := xBit
               LAMINADO->LAMINADO := xLam
               LAMINADO->MATERIAL := xMat
               LAMINADO->CORRIDA  := xCor
            Else
               exit
            EndIf
         Else
            xFig := space(12)
            xBit := space(12)
            exit
         EndIf
      Else
         Aadd(aFig, { LAMINADO->FIGURA , LAMINADO->BITOLA , RecNo() } )
         dbSkip(1)
         While .not. EOF()
               If RTRIM( LAMINADO->FIGURA ) = RTRIM(xFig)
                  Aadd( aFig , { LAMINADO->FIGURA , LAMINADO->BITOLA , RecNo() } )
                  dbSkip(1)
                  loop
               Else
                  dbSkip(1)
               EndIf
         End
         nTam := 1
         While nTam <= Len(aFig)
               If RTRIM( aFig[nTam][2] ) = RTRIM(xBit)
                  nN := nTam
                  exit
               EndIf
               nTam++
         End
         If nN <> 0
            dbGoTo( aFig[nN][3] )
            xFig := LAMINADO->FIGURA
            xBit := LAMINADO->BITOLA
            xLam := LAMINADO->LAMINADO
            xMat := LAMINADO->MATERIAL
            xCor := LAMINADO->CORRIDA
            @ 10,29 Say "Figura  :" Get xFig picture "@!"
            @ 12,29 Say "Bitola  :" Get xBit picture "@!"
            @ 14,29 Say "Laminado:" Get xLam picture "@!"
            @ 16,29 Say "Material:" Get xMat picture "@!"
            @ 18,29 Say "Corrida :" Get xCor picture "@!"
            inkey(00)
         Else
            @ 14,29 Say "Laminado:" Get xLam picture "@!"
            @ 16,29 Say "Material:" Get xMat picture "@!"
            @ 18,29 Say "Corrida :" 
            Read


            dbSelectArea("CF_CO_LA")
            dbSeek( xFig )
            If Found()
               Aadd(aCor, { CF_CO_LA->FIGURA , CF_CO_LA->MATERIAL , CF_CO_LA->CORRIDA , RecNo() } )
               dbSkip(1)
               While .not. EOF()
                     If RTRIM( CF_CO_LA->FIGURA ) = RTRIM(xFig)
                        Aadd(aCor, { CF_CO_LA->FIGURA , CF_CO_LA->MATERIAL , CF_CO_LA->CORRIDA , RecNo() } )
                  dbSkip(1)
                  loop
               Else
                  dbSkip(1)
               EndIf
               End
               nN := 0
               nTam := 1
               While nTam <= Len(aFig)
                     If RTRIM( aCor[nTam][2] ) = RTRIM(xMat)
                        nN := nTam
                        exit
                     EndIf
                     nTam++
               End
               If nN <> 0
                  cCor := RTRIM( aCor[nN][3] )
               Else 
                  Tone (200,3)
                  @ 24,22 Say "Essa corrida nao existe !!!" color "GR*+/B"
               EndIf
               dbSelectArea("CORR_LAM")
               dbGoTop()
               cCor2 := space(10)
               aTab := {}
               While .not. EOF()
                     cCor2 := CORR_LAM->CORRIDA
                     If LEFT(cCor2 , 2) = RTRIM(cCor)
                        Aadd(aTab, { CORR_LAM->CORRIDA , CORR_LAM->FIGURA , RecNo() } )
                     EndIf    
                     dbSkip(1)
               End                                                                                                                                                               
               nN := 1
               aVaz := {}
               While nN <= Len( aTab )
                     If Empty( aTab[nN][2] )
                        Aadd(aVaz, { aTab[nN][1] , aTab[nN][3] } )
                     EndIf
                     nN++
               End
               nN := 1
               aMenu := {}
               While nN <= Len(aVaz)
                     Aadd( aMenu, aVaz[nN][1] )
                     nN++
               End
               nN := 1
               aDisp := {}
               While nN <= Len( aVaz )
                     Aadd(aDisp, .t. )
                     nN++
               End
               cTela := SaveScreen(10,31,15,51)
               SetColor("R+/N,GR+/B")
               @ 10,31 clear to 15,51
               DispBox(10,31,15,51,2)
               nOp := Achoice ( 11, 32, 14, 50, aMenu, aDisp,'Auxiliar_da_Achoice')
               RestScreen(10,31,15,51,cTela)
               SetColor("GR+/B,B/W+")
               nN := aVaz[nOp][2]
               dbGoTo(nN)
               xCor := CORR_LAM->CORRIDA
               @ 18,29 Say "Corrida :" Get xCor
            Else
               Tone (200,3)
               @ 24,22 Say "Essa corrida nao existe !!!" color "GR*+/B"
            EndIf
            @ 19,26 Say "Deseja salvar esse registro ?"
            @ 20,33 Prompt "Sim"
            @ 20,46 Prompt "Nao"
            Menu To nN
            If nN = 1
               nN := aVaz[nOp][2]
               dbGoTo(nN)
               CORR_LAM->FIGURA := xFig
               CORR_LAM->BITOLA := xBit
               CORR_LAM->MATERIAL := xMat
               dbSelectArea("LAMINADO")
               dbAppend()
               LAMINADO->FIGURA   := xFig
               LAMINADO->BITOLA   := xBit
               LAMINADO->LAMINADO := xLam
               LAMINADO->MATERIAL := xMat
               LAMINADO->CORRIDA  := xCor
            Else
               exit
            EndIf
         EndIf
      EndIf
      exit
End

Cls
Clear Typeahead
dbCloseAll()
Return
