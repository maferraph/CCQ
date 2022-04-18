/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                              FUNCOES.PRG                                  *
****************************************************************************/

#include "Inkey.ch"
#include "Achoice.ch"

**************************
Function TestaImpressora()
**************************

Local lTeste

Tone(200,2) ; Tone(300,2) ; Tone(800,2)
Tela("R+/N,GR+/B",10,20,18,64) 
SetColor("R+/N,GR+/B")
@ 10,21 Say "Esse programa de certificado de qualidade"
@ 11,21 Say "   foi desenvolvido para ser usado com "
@ 12,21 Say "         impressoras HP DeskJet.       "
@ 14,27 Say "Testando impressora: "
If IsPrinter()
   lTeste := "OK"
Else
   lTeste := "ERRO!"
EndIf
   @ 14,53 Say lTeste color "GR+/B"
If lTeste = "OK"
   @ 16,21 Say "Pressione qualquer tecla para imprimir..." color "GR+/B"
   inkey(00)
Else
   @ 16,21 Say "Verifique se a impressora esta pronta !!!" color "GR+/B"
   inkey(00)
EndIf
SetColor("GR+/B,B/W+")

Return lTeste


******************************************************
Function TestaCorrida( cTipo, cFig , cBit , cCorrida )
******************************************************

// "CP" : corpo
// "CT" : castelo
// "TP" : tampa
// "PR" : preme
// "AC" : corpo quadrado agulha
// "AH" : haste redonda agulha
// "AT" : castelo sextavado agulha
// "AP" : porca-castelo sextavado agulha
// "AE" : preme redondo agulha

Local nArea, aVet, aVet1, nRec , cCP , cBC , cMC, lTeste, nN, aVet2

nArea := select()

Use VALVULA New 
dbGoTop()

aVet := {}
While .not. EOF()
      If RTRIM( cFig ) == RTRIM( VALVULA->FIGURA )
         Aadd( aVet, { VALVULA->BITOLA , RecNo() } )
      EndIf
      dbSkip(1)
End
nN := 1
nRec := 0
While nN <= Len( aVet )
      @ 24, 15 Say "Aguarde... conferindo n£mero de corrida !"
      If RTRIM( cBit ) == RTRIM( aVet[nN][1] )
         nRec := aVet[nN][2]
         @ 24, 15 Say "                                           "
         exit
      EndIf
      nN++
End
dbGoTo( nRec )

If cTipo = "CP"
   cCP := VALVULA->MP1
   cBC := VALVULA->BITMP1
   cMC := VALVULA->MATMP1
ElseIf cTipo = "CT"
   cCP := VALVULA->MP2
   cBC := VALVULA->BITMP2
   cMC := VALVULA->MATMP2
ElseIf cTipo = "TP"
   cCP := VALVULA->MP2
   cBC := VALVULA->BITMP2
   cMC := VALVULA->MATMP2
ElseIf cTipo = "PR"
   cCP := VALVULA->MP3
   cBC := VALVULA->BITMP3
   cMC := VALVULA->MATMP3
EndIf

Use VAL_COMP 
dbGoTop()

aVet := {}
While .not. EOF()
      If RTRIM( cCP ) == RTRIM( VAL_COMP->COMPONENTE )
         Aadd( aVet, { VAL_COMP->BITOLA_VAL , VAL_COMP->MATERIAL ,; 
                       VAL_COMP->CORR_FORN , RecNo() } )
      EndIf
      dbSkip(1)
End
nN := 1
aVet1 := {}
While nN <= Len( aVet )
      If RTRIM( cBC ) == RTRIM( aVet[nN][1] )
         Aadd( aVet1, { aVet[nN][2] , aVet[nN][3] , aVet[nN][4] } )
      EndIf
      nN++
End
nN := 1
aVet2 := {}
While nN <= Len( aVet1 )
      If RTRIM( cMC ) == RTRIM( aVet1[nN][1] )
         Aadd( aVet2, { aVet1[nN][2] , aVet1[nN][3] } )
      EndIf
      nN++
End
nN := 1
lTeste := .f.
While nN <= Len( aVet2 )
      If RTRIM( cCorrida ) == RTRIM( aVet2[nN][1] )
         lTeste := .t.
         exit
      EndIf
      nN++
End
   
aVet := aVet1 := aVet2 := {}
dbCloseArea()
Select( nArea )
Return lTeste


*******************************
Function Teste( cTipo , cDado )
*******************************

// "MT" : material
// "VV" : v lvulas
// "BV" : bitola da v lvula
// "CX" : conexoes
// "BC" : bitola da conexao
// "IT" : interno valvula
// "IB" : bitola interno valvula

Local lTeste, aVet, nN, aVaz, nOp, nArea , cAlias

aVet := aVaz := {}

nArea := select()
Use Bd New 
dbGoTop()

If cTipo = "MT"
   cAlias := "BD->MATERIAL"
ElseIf cTipo = "VV"
   cAlias := "BD->VALFIG"
ElseIf cTipo = "BV"
   cAlias := "BD->VALBIT"
ElseIf cTipo = "CX"
   cAlias := "BD->CONEX"
ElseIf cTipo = "BC"
   cAlias := "BD->BIT_CONEX"
EndIf

While .not. EOF()
      Aadd( aVet, &cAlias )
      dbSkip()
End
nN := 1
aVaz := {}
While nN <= Len( aVet )
      If Left(aVet[nN] , 1) <> " " 
         Aadd(aVaz, aVet[nN] )
      End
      nN++
End
nN := 1
lTeste := .f.
While nN <= Len( aVaz )
      If RTRIM( aVaz[nN] ) == RTRIM( cDado )
         lTeste := .t.
         exit
      EndIf
      nN++
End

If lTeste = .f.
   @ 24,15 Say "NAO EXISTE ESSE REGISTRO NOS BANCOS DE DADOS !!!"
   Tone(200,5) 
   Inkey(00)
   @ 24,15 Say "                                                "
EndIf

aVaz := aVet := {}
dbCloseArea()
Select( nArea )
Return lTeste

********************
Function MontaTela()
********************
Local nLin := 1

Cls
SetColor("GR+/B,B/W+")
@ 0,0 clear to 0,80
@ 0,24 Say "Conesteel Conexoes de A‡o Ltda."
@ 24,0 clear to 24,80
@ 24,0 Say "Mensagem :"
SetColor("B/W+")
@ 2,0 CLEAR TO 2,80
DispBox(1,0,3,79,2)
@ 2,18 Say "CCQ - Controle de Certificados de Qualidade"
SetColor("B/N")
For nLin = 4 To 23
    @ nLin,0 Say Replicate ("²±",40)
Next
SetColor("GR+/B,B/W+")
@ 7,21 CLEAR TO 21,60
DispBox(6,20,22,61,2)
@ 8,20 Say "Ì"
@ 8,21 Say Replicate("Í",40)
@ 8,61 Say "¹"

Return NIL


**************************
Function MontaTelaGrande()
**************************
Local nLin := 1

Cls
SetColor("GR+/B,B/W+")
@ 0,0 clear to 0,80
@ 0,24 Say "Conesteel Conexäes de A‡o Ltda."
@ 24,0 clear to 24,80
@ 24,0 Say "Mensagem :"
SetColor("B/W+")
@ 2,0 CLEAR TO 2,80
DispBox(1,0,3,79,2)
@ 2,18 Say "CCQ - Controle de Certificados de Qualidade"
SetColor("B/N")
nLin := 1
For nLin = 4 To 23
    @ nLin,0 Say Replicate ("²±",40)
Next
SetColor("GR+/B,B/W+")
DispBox(5,4,23,75,2)
@  6,5  CLEAR TO 22,74
@  7,4  Say "Ì"
@  7,5  Say Replicate("Í",70)
@  7,75 Say "¹"

Return NIL



*****************************************************
Function Tela(cColor,nLinIni,nColIni,nLinFin,nColFin)
*****************************************************

Local nLI,nCI,nLF,nCF,nL_I,nL_F,nC_I,nC_F,nI,cCor

cCor := SetColor()
nLI := nLinIni
nCI := nColIni
nLF := nLinFin
nCF := nColFin
nL_I := nLinIni + ( ABS(nLinFin - nLinIni) / 2 ) - 1
nL_F := nLinFin - ( ABS(nLinFin - nLinIni) / 2 ) - 1
nC_I := nColIni + ( ABS(nColFin - nColIni) / 2 ) - 1
nC_F := nColFin - ( ABS(nColFin - nColIni) / 2 ) - 1
nI := 1

SetColor(cColor)
While nL_I >= nLinIni .and. nL_F <= nLinFin
      For nI = 1 to 10000
      Next
      dispBox(nL_I--,nC_I,nL_F++,nC_F)
End
nI := 1
While nC_I >= nColIni .and. nC_F <= nColFin
      scroll(nL_I,nC_I,nL_F,nC_F)
      dispBox(nL_I,nC_I--,nL_F,nC_F++)
      For nI = 1 to 10000
      Next
End   

SetColor(cCor)
Return NIL


**********************************************
Function Auxiliar_da_Achoice(nModo,nElto,nPos)
**********************************************

Local nRt:=AC_CONT , nTecla := Lastkey()

If nTecla = K_ESC
   nRt := AC_ABORT
ElseIf nTecla = K_ENTER
   nRt := AC_SELECT
ElseIf nModo = 1
   Keyboard Chr( K_CTRL_PGDN )
ElseIf nModo = 2
   Keyboard Chr( K_CTRL_PGUP )
End

Return nRt



************************************
Function Menu(cTipo,nLI,nCI,nLF,nCF)
************************************

// "FF" : forjado
// "BT" : bitola do forjado
// "MT" : material
// "VV" : v lvulas
// "BV" : bitola da v lvula
// "LL" : laminado
// "BL" : bitola do laminado
// "CL" : cliente
// "CX" : conexoes
// "BC" : bitola da conexao
// "IT" : interno valvula
// "IB" : bitola interno valvula

Local cCC, aVet, nN, aVaz, aDisp, nOp, cTela, nArea , cAlias

cCC := space(2)
aVet := aVaz := aDisp := {}

nArea := select()
Use Bd New 
dbGoTop()

If cTipo = "FF"
   cAlias := "BD->FORJADO"
ElseIf cTipo = "BF"
   cAlias := "BD->BITFOR"
ElseIf cTipo = "MT"
   cAlias := "BD->MATERIAL"
ElseIf cTipo = "VV"
   cAlias := "BD->VALVULA"
ElseIf cTipo = "BV"
   cAlias := "BD->BITVAL"
ElseIf cTipo = "LL"
   cAlias := "BD->LAMINADO"
ElseIf cTipo = "BL"
   cAlias := "BD->BITLAM"
ElseIf cTipo = "CL"
   cAlias := "BD->CLIENTE"
ElseIf cTipo = "CX"
   cAlias := "BD->CONEX"
ElseIf cTipo = "BC"
   cAlias := "BD->BIT_CONEX"
ElseIf cTipo = "IT"
   cAlias := "BD->INT"
ElseIf cTipo = "IB"
   cAlias := "BD->BITINT"
EndIf

While .not. EOF()
      Aadd( aVet, &cAlias )
      dbSkip()
End
nN := 1
aVaz := {}
While nN <= Len( aVet )
      If Left(aVet[nN] , 1) <> " " 
         Aadd(aVaz, aVet[nN] )
      End
      nN++
End
nN := 1
aDisp := {}
While nN <= Len( aVaz )
      Aadd( aDisp , .t. )
      nN++
End
cTela := SaveScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 )
SetColor("R+/N,GR+/B")
@ nLI-1,nCI-1 clear to nLF+1,nCF+1
DispBox( nLI-1 , nCI-1 , nLF+1 , nCF+1 , 2 )
nOp := Achoice ( nLI, nCI, nLF, nCF, aVaz, aDisp,'Auxiliar_da_Achoice')
If nOp == 0
   cCC := 0
Else
   cCC := aVaz[nOp]
EndIf
RestScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 , cTela )
SetColor("GR+/B,B/W+")
aVaz := aDisp := aVet := {}
dbCloseArea()
Select( nArea )
Return cCC


**************************************************************
Function Corrida( cFig , cBit , cMat , nLI , nCI , nLF , nCF )
**************************************************************
Local cCC, aVet1, aVet2, aVet3, nN, aVaz, aDisp, nOp, cTela, nArea , cAlias
Local cTela2, cMP , cBITMP, nRec
Local GetList := {}

cCC := space(2)
aVet1 := aVet2 := aVet3 := aVaz := aDisp := {}

nArea := select()

Use FIGURA 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cFig ) == RTRIM( FIGURA->FIGURA )
         Aadd( aVet1, { FIGURA->BITOLA , RecNo() } )
      EndIf
      dbSkip()
End
nN := 1
While nN <= Len( aVet1 )
      If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
         nRec := aVet1[nN][2]
         dbGoTo( nRec )
         cMP := FIGURA->MP
         cBITMP := FIGURA->BITOLA_MP
         exit
      End
      nN++
End

Use CORRIDA 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cMP ) == RTRIM( CORRIDA->MP ) .and. CORRIDA->MP <> space(12)
         Aadd( aVet1, { CORRIDA->BITOLA_MP, CORRIDA->MATERIAL, CORRIDA->CORRIDA } )
      EndIf
      dbSkip()
End

nN := 1
aVet2 := {}
While nN <= Len( aVet1 )
      If RTRIM( cBITMP ) == RTRIM( aVet1[nN][1] )
         Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] } )
      End
      nN++
End
nN := 1
aVet3 := {}
While nN <= Len( aVet2 )
      If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
         Aadd(aVet3, aVet2[nN][2] )
      End
      nN++
End
nN := 1
aDisp := {}
While nN <= Len( aVet3 )
      Aadd( aDisp , .t. )
      nN++
End

If cFig = space(10) .and. cBit = space(16)
   cCC = space(5)
   Return cCC
EndIf

If Len( aVet3 ) = 0
   aVet3 := aDisp := aVet1 := aVet2 := {}
   dbCloseArea()
   Select( nArea )
   cCC := "vazio"
   Return cCC
EndIf

cTela := SaveScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 )
SetColor("R+/N,GR+/B")
@ nLI-1,nCI-1 clear to nLF+1,nCF+1
DispBox( nLI-1 , nCI-1 , nLF+1 , nCF+1 , 2 )
nOp := Achoice ( nLI, nCI, nLF, nCF, aVet3, aDisp,'Auxiliar_da_Achoice')
RestScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 , cTela )
SetColor("GR+/B,B/W+")
If nOp <> 0 
   cCC := aVet3[nOp]
EndIf

aVet3 := aDisp := aVet1 := aVet2 := {}
dbCloseArea()
Select( nArea )
Return cCC


***************************************************************************
Function CorridaUniao( cFig , cBit , cMat , nLI , nCI , nLF , nCF , cTipo )
***************************************************************************
Local cCC, aVet1, aVet2, aVet3, nN, aVaz, aDisp, nOp, cTela, nArea , cAlias
Local cTela2, cMP , cBITMP, nRec
Local GetList := {}

cCC := space(2)
aVet1 := aVet2 := aVet3 := aVaz := aDisp := {}

nArea := select()

Use UNIAO 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cFig ) = RTRIM( UNIAO->FIGURA )
         Aadd( aVet1, { UNIAO->BITOLA , RecNo() } )
      EndIf
      dbSkip()
End
nN := 1
While nN <= Len( aVet1 )
      If RTRIM( cBit ) = RTRIM( aVet1[nN][1] )
         nRec := aVet1[nN][2]
         dbGoTo( nRec )
         If cTipo = "17-BT-PM"
            cMP    := UNIAO->MP_PM
            cBITMP := UNIAO->BIT_PM
            exit
         ElseIf cTipo = "17-BT-PF"
            cMP    := UNIAO->MP_PF
            cBITMP := UNIAO->BIT_PF
            exit
         ElseIf cTipo = "17-BT-PC"
            cMP    := UNIAO->MP_PC
            cBITMP := UNIAO->BIT_PC
            exit
         EndIf
      End
      nN++
End

Use CORRIDA

dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cMP ) = RTRIM( CORRIDA->MP ) .and. CORRIDA->MP <> space(12)
         Aadd( aVet1, { CORRIDA->BITOLA_MP, CORRIDA->MATERIAL, CORRIDA->CORRIDA } )
      EndIf
      dbSkip()
End

nN := 1
aVet2 := {}
While nN <= Len( aVet1 )
      If RTRIM( cBITMP ) = RTRIM( aVet1[nN][1] )
         Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] } )
      End
      nN++
End
nN := 1
aVet3 := {}
While nN <= Len( aVet2 )
      If RTRIM( cMat ) = RTRIM( aVet2[nN][1] )
         Aadd(aVet3, aVet2[nN][2] )
      End
      nN++
End
nN := 1
aDisp := {}
While nN <= Len( aVet3 )
      Aadd( aDisp , .t. )
      nN++
End

If cFig = space(10) .and. cBit = space(16)
   cCC = space(5)
   Return cCC
EndIf

If Len( aVet3 ) = 0
   aVet3 := aDisp := aVet1 := aVet2 := {}
   dbCloseArea()
   Select( nArea )
   cCC := "vazio"
   Return cCC
EndIf

cTela := SaveScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 )
SetColor("R+/N,GR+/B")
@ nLI-1,nCI-1 clear to nLF+1,nCF+1
DispBox( nLI-1 , nCI-1 , nLF+1 , nCF+1 , 2 )
nOp := Achoice ( nLI, nCI, nLF, nCF, aVet3, aDisp,'Auxiliar_da_Achoice')
RestScreen( nLI-1 , nCI-1 , nLF+1 , nCF+1 , cTela )
SetColor("GR+/B,B/W+")
If nOp <> 0 
   cCC := aVet3[nOp]
EndIf

aVet3 := aDisp := aVet1 := aVet2 := {}
dbCloseArea()
Select( nArea )
Return cCC

         
**************************************************
Function ProcuraCQ( cFig , cBit , cMat , cCorCon )
**************************************************

Local cCC, aVet1, aVet2, aVet3, nN, nArea , cAlias, cDesc, cClas , cExtre , cBitBak
Local cTela2, cCorFor, cMP , cBITMP , nRec , aCOMP, nJ , nI
Local GetList := {}

cCC := space(2)
aVet1 := aVet2 := aVet3 := aCOMP := {}

nArea := select()

dbCloseArea()
Use FIGURA
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cFig ) == RTRIM( FIGURA->FIGURA )
         Aadd( aVet1, { FIGURA->BITOLA , RecNo() } )
      EndIf
      dbSkip()
End
// verifica se a bitola nao e reducao
nN := AT( " " , TRIM( cBit ))
If nN > 0
   cBit := LEFT( cBit , nN - 1 )
End
//procura bitola
nN := 1
While nN <= Len( aVet1 )
      If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
         nRec := aVet1[nN][2]
         dbGoTo( nRec )
         cDesc := FIGURA->DESCRICAO
         cClas := FIGURA->CLASSE
         cExtre := FIGURA->EXTRE
         cMP := TRIM( FIGURA->MP )
         cBITMP := FIGURA->BITOLA_MP
         exit
      End
      nN++
End

Use CON_COMP  New
dbGoTop()

aVet1 := {}
While .not. EOF()
      If cMP  ==  RTRIM( CON_COMP->MP )
         Aadd( aVet1, { CON_COMP->BITOLA_MP, CON_COMP->MATERIAL, CON_COMP->CORRIDA , RecNo() } )
      End
      dbSkip()
End
nN := 1
aVet2 := {}
While nN <= Len( aVet1 )
      If RTRIM( cBITMP ) == RTRIM( aVet1[nN][1] )
         Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] } ) 
      End
      nN++
End
nN := 1
aVet3 := {}
While nN <= Len( aVet2 )
      If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
         Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] } )
      End
      nN++
End
nN := 1
nRec := 0
While nN <= Len( aVet3)
      If RTRIM( cCorCon ) == RTRIM( aVet3[nN][1] )
         nRec := aVet3[nN][2]
         exit
      End
      nN++
End

dbGoTo( nRec )
aCOMP := {}
Aadd( aCOMP , { NIL , NIL , cFig , cDesc , cClas , cExtre , cBit , cMat , ;
                CON_COMP->OBS , CON_COMP->C , CON_COMP->SI , CON_COMP->MN, ;
                CON_COMP->P , CON_COMP->S , CON_COMP->CR , CON_COMP->NI , ;
                CON_COMP->MO , CON_COMP->CU , CON_COMP->V , CON_COMP->NB , ;
                CON_COMP->AL , CON_COMP->TI , CON_COMP->N2 , ;
                CON_COMP->LIM_ESCO , CON_COMP->LIM_RESIS , CON_COMP->ESTRI, ;
                CON_COMP->ALONGA , CON_COMP->DUREZA , NIL , ;
                CON_COMP->CORR_FORN , CON_COMP->CO } )

aVet3 := aVet1 := aVet2 := {}
dbCloseAll()
Select( nArea )
Return aCOMP



***************************************************************
Function ProcuraCQUniao( cFig , cBit , cMat , cCorCon , cTipo )
***************************************************************

Local cCC, aVet1, aVet2, aVet3, nN, nArea , cAlias, cDesc, cClas , cExtre
Local cTela2, cCorFor, cMP , cBITMP , nRec , aCOMP, nJ , nI
Local GetList := {}

cCC := space(2)
aVet1 := aVet2 := aVet3 := aCOMP := {}

nArea := select()

Use UNIAO 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cFig ) = RTRIM( UNIAO->FIGURA )
         Aadd( aVet1, { UNIAO->BITOLA , RecNo() } )
      EndIf
      dbSkip()
End
nN := 1
While nN <= Len( aVet1 )
      If RTRIM( cBit ) = RTRIM( aVet1[nN][1] )
         nRec := aVet1[nN][2]
         dbGoTo( nRec )
         If cTipo = "17-BT-PM"
            cMP    := UNIAO->MP_PM
            cBITMP := UNIAO->BIT_PM
            exit
         ElseIf cTipo = "17-BT-PF"
            cMP    := UNIAO->MP_PF
            cBITMP := UNIAO->BIT_PF
            exit
         ElseIf cTipo = "17-BT-PC"
            cMP    := UNIAO->MP_PC
            cBITMP := UNIAO->BIT_PC
            exit
         EndIf
      End
      nN++
End

Use CON_COMP 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( cMP ) = RTRIM( CON_COMP->MP )
         Aadd( aVet1, { CON_COMP->BITOLA_MP, CON_COMP->MATERIAL, ;
                        CON_COMP->CORRIDA , RecNo() } )
      EndIf
      dbSkip()
End
nN := 1
aVet2 := {}
While nN <= Len( aVet1 )
      If RTRIM( cBITMP ) = RTRIM( aVet1[nN][1] )
         Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] } ) 
      End
      nN++
End
nN := 1
aVet3 := {}
While nN <= Len( aVet2 )
      If RTRIM( cMat ) = RTRIM( aVet2[nN][1] )
         Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] } )
      End
      nN++
End
nN := 1
nRec := 0
While nN <= Len( aVet3)
      If RTRIM( cCorCon ) = RTRIM( aVet3[nN][1] )
         nRec := aVet3[nN][2]
         exit
      End
      nN++
End

dbGoTo( nRec )
aCOMP := {}
Aadd( aCOMP , { NIL , 1 , cTipo , "" , "" , "" , "" , cMat , ;
                CON_COMP->OBS , CON_COMP->C , CON_COMP->SI , CON_COMP->MN, ;
                CON_COMP->P , CON_COMP->S , CON_COMP->CR , CON_COMP->NI , ;
                CON_COMP->MO , CON_COMP->CU , CON_COMP->V , CON_COMP->NB , ;
                CON_COMP->AL , CON_COMP->TI , CON_COMP->N2 , ;
                CON_COMP->LIM_ESCO , CON_COMP->LIM_RESIS , CON_COMP->ESTRI, ;
                CON_COMP->ALONGA , CON_COMP->DUREZA , NIL , ;
                CON_COMP->CORR_FORN , CON_COMP->CO } )


aVet3 := aVet1 := aVet2 := {}
dbCloseAll()
Select( nArea )
Return aCOMP




************************************
Function ProcCQEmit( cDado , cTipo )
************************************

// "N" : procura CQ por numero
// "F" : procura CQ pela NF
// "D" : procura CQ pela data
// "C" : procura CQ pelo cliente
// "T" : procura CQ pelo tipo - conexao ou valvula

Local cAlias , nArea , nRec , aOp , aMenu , nN , aDisp , cTela , nOp

nArea := select()
aOp := aMenu := aDisp := {}
nOp := 0

If cTipo = "N"
   cAlias := "CQ->NUMERO"
ElseIf cTipo = "F"
   cAlias := "CQ->NF"
ElseIf cTipo = "D"
   cAlias := "CQ->DATA"
ElseIf cTipo = "C"
   cAlias := "CQ->CLIENTE"
ElseIf cTipo = "T"
   cAlias := "CQ->TIPO"
EndIf   

Use CQ 
dbGoTop()

aOp := {}
While .not. EOF()
      If ( &cAlias ) = cDado
            Aadd( aOp , { transform( CQ->NUMERO , "99999" ) +  " " + ;
                          CQ->CLIENTE + " " + ;
                          DtoC( CQ->DATA ) + " " + ;
                          transform( CQ->NF , "99999" ) +  " " + ;
                          CQ->TIPO , RecNo() } )
      EndIf
      dbSkip(1)
End

If Len( aOp ) = 0
   nRec := 0
   dbCloseArea()
   Select( nArea )
   Return nRec
EndIf
     
nN := 1
aMenu := {}
While nN <= Len( aOp )
      Aadd( aMenu , aOp[nN][1] )
      nN++
End
nN := 1
aDisp := {}
While nN <= Len( aMenu )
      Aadd( aDisp , .t. )
      nN++
End
cTela := SaveScreen( 9 , 21 , 19 , 61 )
SetColor("R+/N,GR+/B")
@  9,21 clear to 19,60
DispBox( 9 , 21 , 19 , 60 , 2 )
nOp := Achoice ( 10 , 22 , 18 , 60 , aMenu , aDisp, 'Auxiliar_da_Achoice' )
RestScreen( 9 , 21 , 19 , 61 , cTela )
SetColor("GR+/B,B/W+")
If nOp <> 0 
   nRec := aOp[nOp][2]
EndIf

aMenu := aDisp := aOp := {}
dbCloseArea()
Select( nArea )

Return nRec



**********************************************
Function CorridaInterno( cTipo , cBit , cMat )
**********************************************

Local nArea , aVet1 , aVet2, nN, aVet3 , cCorrida, nRec

nArea := select()
aVet1 := aVet2 := aVet3 := {}
cCorrida := space(10)

Use INTATUAL 
dbGoTop()

aVet1 := {}
While .not. EOF()
      If RTRIM( INTATUAL->INT ) = RTRIM( cTipo )
         Aadd( aVet1 , { INTATUAL->BITINT , INTATUAL->MAT , INTATUAL->CORR_FOR } )
      EndIf
      dbSkip(1)
End

nN := 1
aVet3 := {}
While nN <= Len( aVet1 )
      If RTRIM( aVet1[nN][1] ) = RTRIM( cBit )
         Aadd( aVet3 , { aVet1[nN][2] , aVet1[nN][3] } ) 
      EndIf
      nN++
End

nN := 1
While nN <= Len( aVet3 )
      If RTRIM( aVet3[nN][1] ) = RTRIM( cMat )
         cCorrida := aVet3[nN][2]
         exit
      EndIf
      nN++
End

dbCloseArea()
Select( nArea )

Return cCorrida
     


**********************************
Function TestaVal( cTipo , cDado )
**********************************

Local nArea , cAlias , lTeste

nArea := select()

If cTipo = "F"
   cAlias = "VALVULA->FIGURA"
ElseIf cTipo = "B"
   cAlias = "VALVULA->BITOLA"
ElseIf cTipo = "M"
   cAlias = "VALVULA->MATERIAL"
EndIf

Use VALVULA 
dbGoTop()

While .not. EOF()
      lTeste := .F.
      If RTRIM( &cAlias ) = RTRIM( cDado )
         lTeste := .T.
         exit
      EndIf
      dbSkip(1)
End

Return lTeste
                        

*******************************
Function CQMP( aDados , cTipo )
*******************************

// cTipo := "LAMINADO"
// cTipo := "FORJADO"
// cTipo := "COMPONENTE"
// cTipo := "INTERNO"

Local nLin, nN, cA , cB
nLin := nN := 1

If cTipo = "LAMINADO"
   cA := "L A M I N A D O"
   cB := "Laminado"
ElseIf cTipo = "FORJADO"
   cA := "F O R J A D O"
   cB := "Forjado"
ElseIf cTipo = "COMPONENTE"
   cA := "C O M P O N E N T E"
   cB := "Componente"
ElseIf cTipo = "INTERNO"
   cA := "I N T E R N O"
   cB := "Interno"
End

Set Device To Print

@ nLin++,0  Say DtoC(Date()) + " - " + Time()
@ nLin  ,0  Say "É"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "»"
@ nLin  ,0  Say "º"
@ nLin  ,8  Say "C O N E S T E E L    C O N E X O E S    D E   A € O    L T D A."
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ì"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "¹"
@ nLin  ,0  Say "º"
@ nLin  ,15 Say "C E R T I F I C A D O    D E    Q U A L I D A D E"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "È"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "¼"
nLin++

@ nLin  ,0  Say "É"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "»"
@ nLin  ,0  Say "º"
@ nLin  ,13 Say "D I S C R I M I N A € A O     D O     " + cA
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ì"
@ nLin  ,1  Say Replicate("Í",18)
@ nLin  ,19 Say "Ñ"
@ nLin  ,20 Say Replicate("Í",27)
@ nLin  ,47 Say "Ñ"
@ nLin  ,48 Say Replicate("Í",31)
@ nLin++,79 Say "¹"
@ nLin  ,0  Say "º"
@ nLin  ,6  Say cB
@ nLin  ,19 Say "³"
@ nLin  ,29 Say "Material"
@ nLin  ,47 Say "³"
@ nLin  ,53 Say "Corrida do Fornecedor"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",18)
@ nLin  ,19 Say "Å"
@ nLin  ,20 Say Replicate("Ä",27)
@ nLin  ,47 Say "Å"
@ nLin  ,48 Say Replicate("Ä",31)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,0  Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,2  Say aDados[1]
@ nLin  ,19 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,19 Say "³"
@ nLin  ,19 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,21 Say aDados[2]
@ nLin  ,47 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,47 Say "³"
@ nLin  ,47 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,49 Say aDados[3]
@ nLin  ,79 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",18)
@ nLin  ,19 Say "Å"
@ nLin  ,20 Say Replicate("Ä",27)
@ nLin  ,47 Say "Å"
@ nLin  ,48 Say Replicate("Ä",31)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,3  Say "Data da Compra"
@ nLin  ,19 Say "³"
@ nLin  ,23 Say "Certificado Original"
@ nLin  ,47 Say "³"
@ nLin  ,54 Say "Nome do Fornecedor"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",18)
@ nLin  ,19 Say "Å"
@ nLin  ,20 Say Replicate("Ä",27)
@ nLin  ,47 Say "Å"
@ nLin  ,48 Say Replicate("Ä",31)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,0  Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,2  Say aDados[6]
@ nLin  ,19 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,19 Say "³"
@ nLin  ,19 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,21 Say aDados[5]
@ nLin  ,47 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,47 Say "³"
@ nLin  ,47 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,49 Say aDados[4]
@ nLin  ,79 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin++,79 Say "º"
@ nLin  ,0  Say "È"
@ nLin  ,1  Say Replicate("Í",18)
@ nLin  ,19 Say "Ï"
@ nLin  ,20 Say Replicate("Í",27)
@ nLin  ,47 Say "Ï"
@ nLin  ,48 Say Replicate("Í",31)
@ nLin++,79 Say "¼"
nLin++
@ nLin  ,0  Say "É"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "»"
@ nLin  ,0  Say "º"
@ nLin  ,13 Say "%    D A S    C O M P O S I € O E S   Q U I M I C A S"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ì"
@ nLin  ,1  Say Replicate("Í",10)
@ nLin  ,11 Say "Ñ"
@ nLin  ,12 Say Replicate("Í",10)
@ nLin  ,22 Say "Ñ"
@ nLin  ,23 Say Replicate("Í",10)
@ nLin  ,33 Say "Ñ"
@ nLin  ,34 Say Replicate("Í",10)
@ nLin  ,44 Say "Ñ"
@ nLin  ,45 Say Replicate("Í",10)
@ nLin  ,55 Say "Ñ"
@ nLin  ,56 Say Replicate("Í",11)
@ nLin  ,67 Say "Ñ"
@ nLin  ,68 Say Replicate("Í",11)
@ nLin++,79 Say "¹"
@ nLin  ,0  Say "º"
@ nLin  ,5  Say "C"
@ nLin  ,11 Say "³"
@ nLin  ,16 Say "Si"
@ nLin  ,22 Say "³"
@ nLin  ,27 Say "Mn"
@ nLin  ,33 Say "³"
@ nLin  ,38 Say "P"
@ nLin  ,44 Say "³"
@ nLin  ,49 Say "S"
@ nLin  ,55 Say "³"
@ nLin  ,60 Say "Cr"
@ nLin  ,67 Say "³"
@ nLin  ,73 Say "Ni"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",10)
@ nLin  ,11 Say "Å"
@ nLin  ,12 Say Replicate("Ä",10)
@ nLin  ,22 Say "Å"
@ nLin  ,23 Say Replicate("Ä",10)
@ nLin  ,33 Say "Å"
@ nLin  ,34 Say Replicate("Ä",10)
@ nLin  ,44 Say "Å"
@ nLin  ,45 Say Replicate("Ä",10)
@ nLin  ,55 Say "Å"
@ nLin  ,56 Say Replicate("Ä",11)
@ nLin  ,67 Say "Å"
@ nLin  ,68 Say Replicate("Ä",11)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,0  Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,3  Say aDados[7]
@ nLin  ,11 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,11 Say "³"
@ nLin  ,11 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,14 Say aDados[8]
@ nLin  ,22 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,22 Say "³"
@ nLin  ,22 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,25 Say aDados[9]
@ nLin  ,33 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,33 Say "³"
@ nLin  ,33 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,36 Say aDados[10]
@ nLin  ,44 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,44 Say "³"
@ nLin  ,44 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,47 Say aDados[11]
@ nLin  ,55 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,55 Say "³"
@ nLin  ,55 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,58 Say aDados[12]
@ nLin  ,67 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,67 Say "³"
@ nLin  ,67 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,70 Say aDados[13]
@ nLin  ,79 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",10)
@ nLin  ,11 Say "Å"
@ nLin  ,12 Say Replicate("Ä",10)
@ nLin  ,22 Say "Å"
@ nLin  ,23 Say Replicate("Ä",10)
@ nLin  ,33 Say "Å"
@ nLin  ,34 Say Replicate("Ä",10)
@ nLin  ,44 Say "Å"
@ nLin  ,45 Say Replicate("Ä",10)
@ nLin  ,55 Say "Å"
@ nLin  ,56 Say Replicate("Ä",11)
@ nLin  ,67 Say "Å"
@ nLin  ,68 Say Replicate("Ä",11)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,4  Say "Mo"
@ nLin  ,11 Say "³"
@ nLin  ,16 Say "Cu"
@ nLin  ,22 Say "³"
@ nLin  ,27 Say "V"
@ nLin  ,33 Say "³"
@ nLin  ,38 Say "Nb"
@ nLin  ,44 Say "³"
@ nLin  ,49 Say "Al"
@ nLin  ,55 Say "³"
@ nLin  ,60 Say "Ti"
@ nLin  ,67 Say "³"
@ nLin  ,73 Say "N2"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",10)
@ nLin  ,11 Say "Å"
@ nLin  ,12 Say Replicate("Ä",10)
@ nLin  ,22 Say "Å"
@ nLin  ,23 Say Replicate("Ä",10)
@ nLin  ,33 Say "Å"
@ nLin  ,34 Say Replicate("Ä",10)
@ nLin  ,44 Say "Å"
@ nLin  ,45 Say Replicate("Ä",10)
@ nLin  ,55 Say "Å"
@ nLin  ,56 Say Replicate("Ä",11)
@ nLin  ,67 Say "Å"
@ nLin  ,68 Say Replicate("Ä",11)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,0  Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,3  Say aDados[14]
@ nLin  ,11 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,11 Say "³"
@ nLin  ,11 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,14 Say aDados[15]
@ nLin  ,22 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,22 Say "³"
@ nLin  ,22 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,25 Say aDados[16]
@ nLin  ,33 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,33 Say "³"
@ nLin  ,33 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,36 Say aDados[17]
@ nLin  ,44 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,44 Say "³"
@ nLin  ,44 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,47 Say aDados[18]
@ nLin  ,55 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,55 Say "³"
@ nLin  ,55 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,58 Say aDados[19]
@ nLin  ,67 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,67 Say "³"
@ nLin  ,67 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,70 Say aDados[20]
@ nLin  ,79 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin++,79 Say "º"
@ nLin  ,0  Say "È"
@ nLin  ,1  Say Replicate("Í",10)
@ nLin  ,11 Say "Ï"
@ nLin  ,12 Say Replicate("Í",10)
@ nLin  ,22 Say "Ï"
@ nLin  ,23 Say Replicate("Í",10)
@ nLin  ,33 Say "Ï"
@ nLin  ,34 Say Replicate("Í",10)
@ nLin  ,44 Say "Ï"
@ nLin  ,45 Say Replicate("Í",10)
@ nLin  ,55 Say "Ï"
@ nLin  ,56 Say Replicate("Í",11)
@ nLin  ,67 Say "Ï"
@ nLin  ,68 Say Replicate("Í",11)
@ nLin++,79 Say "¼"
nLin++
@ nLin  ,0  Say "É"
@ nLin  ,1  Say Replicate("Í",78)
@ nLin++,79 Say "»"
@ nLin  ,0  Say "º"
@ nLin  ,10 Say "P R O P R I E D A D E S    F I S I C A   /   M E C A N I C A"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ì"
@ nLin  ,1  Say Replicate("Í",11)
@ nLin  ,12 Say "Ñ"
@ nLin  ,13 Say Replicate("Í",11)
@ nLin  ,24 Say "Ñ"
@ nLin  ,25 Say Replicate("Í",11)
@ nLin  ,36 Say "Ñ"
@ nLin  ,37 Say Replicate("Í",11)
@ nLin  ,48 Say "Ñ"
@ nLin  ,49 Say Replicate("Í",12)
@ nLin  ,61 Say "Ñ"
@ nLin  ,62 Say Replicate("Í",17)
@ nLin++,79 Say "¹"
@ nLin  ,0  Say "º"
@ nLin  ,1  Say "Lim.Escoam."
@ nLin  ,12 Say "³"
@ nLin  ,13 Say "Lim.Resist."
@ nLin  ,24 Say "³"
@ nLin  ,26 Say "Estric‡ao"
@ nLin  ,36 Say "³"
@ nLin  ,37 Say "Alongamento"
@ nLin  ,48 Say "³"
@ nLin  ,52 Say "Dureza"
@ nLin  ,61 Say "³"
@ nLin  ,65 Say "Observa‡oes"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "º"
@ nLin  ,2  Say "(kgf/mmý)"
@ nLin  ,12 Say "³"
@ nLin  ,14 Say "(kgf/mmý)"
@ nLin  ,24 Say "³"
@ nLin  ,29 Say "(%)"
@ nLin  ,36 Say "³"
@ nLin  ,41 Say "(%)"
@ nLin  ,48 Say "³"
@ nLin  ,52 Say "Brinell"
@ nLin  ,61 Say "³"
@ nLin++,79 Say "º"
@ nLin  ,0  Say "Ç"
@ nLin  ,1  Say Replicate("Ä",11)
@ nLin  ,12 Say "Å"
@ nLin  ,13 Say Replicate("Ä",11)
@ nLin  ,24 Say "Å"
@ nLin  ,25 Say Replicate("Ä",11)
@ nLin  ,36 Say "Å"
@ nLin  ,37 Say Replicate("Ä",11)
@ nLin  ,48 Say "Å"
@ nLin  ,49 Say Replicate("Ä",12)
@ nLin  ,61 Say "Å"
@ nLin  ,62 Say Replicate("Ä",17)
@ nLin++,79 Say "¶"
@ nLin  ,0  Say "º"
@ nLin  ,0  Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,4  Say aDados[21]
@ nLin  ,12 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,12 Say "³"
@ nLin  ,12 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,16 Say aDados[22]
@ nLin  ,24 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,24 Say "³"
@ nLin  ,24 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,28 Say aDados[23]
@ nLin  ,36 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,36 Say "³"
@ nLin  ,36 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,40 Say aDados[24]
@ nLin  ,48 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,48 Say "³"
@ nLin  ,48 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,49 Say aDados[25]
@ nLin  ,61 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin  ,61 Say "³"
@ nLin  ,61 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
@ nLin  ,63 Say aDados[26]
@ nLin  ,79 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
@ nLin++,79 Say "º"
@ nLin  ,0  Say "È"
@ nLin  ,1  Say Replicate("Í",11)
@ nLin  ,12 Say "Ï"
@ nLin  ,13 Say Replicate("Í",11)
@ nLin  ,24 Say "Ï"
@ nLin  ,25 Say Replicate("Í",11)
@ nLin  ,36 Say "Ï"
@ nLin  ,37 Say Replicate("Í",11)
@ nLin  ,48 Say "Ï"
@ nLin  ,49 Say Replicate("Í",12)
@ nLin  ,61 Say "Ï"
@ nLin  ,62 Say Replicate("Í",17)
@ nLin++,79 Say "¼"
nLin++
   
Eject

Set Device To Screen

Return NIL



**********************
Function CQVAL( aCQC )
**********************

/****************************************************************************
Vetor aCQC: { {cCQ ,cCliApelido ,cEmpresa ,cCGC ,dData ,nNF ,cPedido }  , ;
              { nQuant , VALVULA->FIGURA , VALVULA->BITOLA , ;
                VALVULA->MATERIAL , VALVULA->DESCRICAO , ;
                VALVULA->INTERNOS , VALVULA->CLASSE , VALVULA->EXTRE , ;
                VALVULA->TESTECORPO , VALVULA->TESTEVEDA } )
         |     { "01" , VALVULA->COMP1 , VALVULA->MP1 , ;
     8   |       VALVULA->BITMP1 , VALVULA->MATMP1, NIL, NIL, NIL, ;
    X's  |       NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
         |       NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )  }
****************************************************************************/

Local nF, nG, nI, cCQ, cPecas, cData, cMaterial, nLin := 0

nF := nG := 1
nLin := 0
cCQ := space(10)

Set Date To British
Set Device To Print

@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(050)+CHR(054)+CHR(065)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(055)+CHR(080)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(055)+CHR(069)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(055)+CHR(070)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(107)+CHR(054)+CHR(087)


FontePequena( nLin )
@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteGrande( nLin )
FonteNegrito( nLin )
@ nLin   , 4   Say "CONESTEEL CONEXOES DE A€O LTDA."
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 8   Say "C.N.P.J. 55.783.427/0001-03   -   Avenida Montemagno, 2.454 - Vila Formosa - Sao Paulo - (SP) - Fone: (011) 6910-1444 - Fax: (011) 6910-5701"
@ nLin++ , 159 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",158) + "¼"
nLin++

nF := Len( LTRIM( aCQC[1][1] ) )
nG := 10 - nF
cCQ := LTRIM( aCQC[1][1] )
For nI = 1 To nG
    cCQ := "0" + cCQ
Next
FonteGrande( nLin )
FonteNegrito( nLin )
@ nLin++ , 1   Say "CERTIFICADO DE QUALIDADE n§ " + cCQ
FonteClara( nLin )
FontePequena( nLin )
nLin++

@ nLin++ , 0   Say "É" + Replicate("Í",63) + "Ñ" + Replicate("Í",29) + "Ñ" + ;
                   Replicate("Í",18) + "Ñ" + Replicate("Í",15) + "Ñ" + ;
                   Replicate("Í",29) + "»"
@ nLin   , 0   Say "º"
@ nLin   , 64  Say "³"
@ nLin   , 94  Say "³"
@ nLin   , 113 Say "³"
@ nLin   , 129 Say "³"
FonteNegrito( nLin )
@ nLin   , 7   Say "CLIENTE : "
@ nLin   , 71  Say "C.N.P.J.: "
@ nLin   , 101 Say "Data : "
@ nLin   , 120 Say "N.F.: "
@ nLin   , 136 Say "Pedido : "
FonteClara( nLin )
@ nLin   , 17  Say aCQC[1][3]
@ nLin   , 81  Say aCQC[1][4]
@ nLin   , 108 Say aCQC[1][5]
@ nLin   , 120 Say aCQC[1][6]
@ nLin   , 145 Say aCQC[1][7]
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",63) + "Ï" + Replicate("Í",29) + "Ï" + ;
                   Replicate("Í",18) + "Ï" + Replicate("Í",15) + "Ï" + ;
                   Replicate("Í",29) + "¼"
nLin++

FontePequena( nLin )
@ nLin++ , 0   Say "É" + Replicate("Í",14) + "Ñ" + Replicate("Í",9) + ;
                   "Ñ" + Replicate("Í",49) + "Ñ" + Replicate("Í",14) + ;
                   "Ñ" + Replicate("Í",11) + "Ñ" + Replicate("Í",17) + ;
                   "Ñ" + Replicate("Í",13) + "Ñ" + Replicate("Í",24) + "»"
@ nLin   , 0   Say "º"
@ nLin   , 15  Say "³"
@ nLin   , 25  Say "³"
@ nLin   , 75  Say "³"
@ nLin   , 90  Say "³"
@ nLin   , 102 Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 134 Say "³"
FonteNegrito( nLin )
@ nLin  , 4   Say "Quantidade"
@ nLin  , 17  Say "Figura"
@ nLin  , 29  Say "Descri‡ao do Material"
@ nLin  , 78  Say "Internos"
@ nLin  , 93  Say "Classe"
@ nLin  , 106 Say "Extremidade"
@ nLin  , 124 Say "Bitola"
@ nLin  , 138 Say "Material"
FonteClara( nLin )
@ nLin++, 164 Say "º"
@ nLin++ , 0   Say CHR(199) + Replicate("Ä",14) + "Å" + Replicate("Ä",9) + ;
                   "Å" + Replicate("Ä",49) + "Å" + Replicate("Ä",14) + ;
                   "Å" + Replicate("Ä",11) + "Å" + Replicate("Ä",17) + ;
                   "Å" + Replicate("Ä",13) + "Å" + Replicate("Ä",24) + ;
                   CHR(182)
@ nLin   , 0   Say "º"
@ nLin   , 15  Say "³"
@ nLin   , 25  Say "³"
@ nLin   , 75  Say "³"
@ nLin   , 90  Say "³"
@ nLin   , 102 Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 134 Say "³"
If aCQC[2][1] = 1
   cPecas := transform( aCQC[2][1] , "99999" ) + " p‡."
Else
   cPecas := transform( aCQC[2][1] , "99999" ) + " p‡s."
EndIf
@ nLin  , 4   Say cPecas
@ nLin  , 17  Say aCQC[2][2]
@ nLin  , 29  Say aCQC[2][5]
@ nLin  , 78  Say aCQC[2][6]
@ nLin  , 93  Say aCQC[2][7]
@ nLin  , 106 Say aCQC[2][8]
@ nLin  , 124 Say aCQC[2][3]
@ nLin  , 138 Say aCQC[2][4]
@ nLin++ ,159 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",14) + "Ï" + Replicate("Í",9) + ;
                   "Ï" + Replicate("Í",49) + "Ï" + Replicate("Í",14) + ;
                   "Ï" + Replicate("Í",11) + "Ï" + Replicate("Í",17) + ;
                   "Ï" + Replicate("Í",13) + "Ï" + Replicate("Í",24) + "¼"

@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 20  Say "C O M P O N E N T E S     D A     V A L V U L A"
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "Ì" + Replicate("Í",39) + "Ñ" + Replicate("Í",39) + "Ñ" + ;
                   Replicate("Í",39) + "Ñ" + Replicate("Í",38) + "¹"
@ nLin   , 0   Say "º"
@ nLin   , 40  Say "³"
@ nLin   , 80  Say "³"
@ nLin   , 120 Say "³"
FonteNegrito( nLin )
@ nLin   , 2   Say "Item"
@ nLin   , 8   Say "Componente"
@ nLin   , 24  Say "Material"
@ nLin   , 42  Say "Item"
@ nLin   , 48  Say "Componente"
@ nLin   , 64  Say "Material"
@ nLin   , 82  Say "Item"
@ nLin   , 88  Say "Componente"
@ nLin   , 104 Say "Material"
@ nLin   , 122 Say "Item"
@ nLin   , 128 Say "Componente"
@ nLin   , 144 Say "Material"
FonteClara( nLin )
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "Ç" + Replicate("Ä",39) + "Å" + Replicate("Ä",39) + "Å" + ;
                   Replicate("Ä",39) + "Å" + Replicate("Ä",38) + "¶"
@ nLin   , 0   Say "º"
@ nLin   , 40  Say "³"
@ nLin   , 80  Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 3   Say "01"
@ nLin   , 8   Say aCQC[3][2]
@ nLin   , 24  Say aCQC[3][5]
@ nLin   , 43  Say "05"
@ nLin   , 48  Say aCQC[7][2]
@ nLin   , 64  Say aCQC[7][5]
@ nLin   , 83  Say "09"
@ nLin   , 88  Say aCQC[11][2]
@ nLin   , 104 Say aCQC[11][3]
@ nLin   , 123 Say "13"
@ nLin   , 128 Say aCQC[15][2]
@ nLin   , 144 Say aCQC[15][3]
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 40  Say "³"
@ nLin   , 80  Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 3   Say "02"
@ nLin   , 8   Say aCQC[4][2]
@ nLin   , 24  Say aCQC[4][5]
@ nLin   , 43  Say "06"
@ nLin   , 48  Say aCQC[8][2]
@ nLin   , 64  Say aCQC[8][5]
@ nLin   , 83  Say "10"
@ nLin   , 88  Say aCQC[12][2]
@ nLin   , 104 Say aCQC[12][3]
@ nLin   , 123 Say "14"
@ nLin   , 128 Say aCQC[16][2]
@ nLin   , 144 Say aCQC[16][3]
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 40  Say "³"
@ nLin   , 80  Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 3   Say "03"
@ nLin   , 8   Say aCQC[5][2]
@ nLin   , 24  Say aCQC[5][5]
@ nLin   , 43  Say "07"
@ nLin   , 48  Say aCQC[9][2]
@ nLin   , 64  Say aCQC[9][5]
@ nLin   , 83  Say "11"
@ nLin   , 88  Say aCQC[13][2]
@ nLin   , 104 Say aCQC[13][3]
@ nLin   , 123 Say "15"
@ nLin   , 128 Say aCQC[17][2]
@ nLin   , 144 Say aCQC[17][3]
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 40  Say "³"
@ nLin   , 80  Say "³"
@ nLin   , 120 Say "³"
@ nLin   , 3   Say "04"
@ nLin   , 8   Say aCQC[6][2]
@ nLin   , 24  Say aCQC[6][5]
@ nLin   , 43  Say "08"
@ nLin   , 48  Say aCQC[10][2]
@ nLin   , 64  Say aCQC[10][3]
@ nLin   , 83  Say "12"
@ nLin   , 88  Say aCQC[14][2]
@ nLin   , 104 Say aCQC[14][3]
@ nLin   , 123 Say "16"
@ nLin   , 128 Say aCQC[18][2]
@ nLin   , 144 Say aCQC[18][3]
@ nLin++ , 159 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",39) + "Ï" + Replicate("Í",39) + "Ï" + ;
                   Replicate("Í",39) + "Ï" + Replicate("Í",38) + "¼"

@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 28  Say "C O M P O S I € A O    Q U I M I C A"
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "Ì" + Replicate("Í",6) + "Ñ" + Replicate("Í",151) + "¹"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
FonteNegrito( nLin )
@ nLin   , 2   Say "Item"
@ nLin   , 11  Say "C"
@ nLin   , 22  Say "Si"
@ nLin   , 33  Say "Mn"
@ nLin   , 44  Say "P"
@ nLin   , 55  Say "S"
@ nLin   , 66  Say "Cr"
@ nLin   , 77  Say "Ni"
@ nLin   , 88  Say "Mo"
@ nLin   , 99  Say "Cu"
@ nLin   , 110 Say "V"
@ nLin   , 121 Say "Nb"
@ nLin   , 132 Say "Al"
@ nLin   , 143 Say "Ti"
@ nLin   , 154 Say "N2"
FonteClara( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 159 Say "º"
@ nLin++ , 0   Say "Ç" + Replicate("Ä",6) + "Å" + Replicate("Ä",151) + "¶"
nF := 3
While nF <= 9
      @ nLin   , 0   Say "º"
      @ nLin   , 7   Say "³"
      @ nLin   , 3   Say aCQC[nF][1]
      If aCQC[nF][7 ] = 00.000
         @ nLin   , 10   Say "0.000"
      Else
         @ nLin   , 9   Say aCQC[nF][7 ]
      EndIf
      If aCQC[nF][8 ] = 00.000
         @ nLin   , 21   Say "0.000"
      Else
         @ nLin   , 20  Say aCQC[nF][8 ]
      EndIf
      If aCQC[nF][9 ] = 00.000
         @ nLin   , 32   Say "0.000"
      Else
         @ nLin   , 31  Say aCQC[nF][9 ]
      EndIf
      If aCQC[nF][10] = 00.000
         @ nLin   , 43   Say "0.000"
      Else
         @ nLin   , 42  Say aCQC[nF][10]
      EndIf
      If aCQC[nF][11] = 00.000
         @ nLin   , 54   Say "0.000"
      Else
         @ nLin   , 53  Say aCQC[nF][11]
      EndIf
      If aCQC[nF][12] = 00.000
         @ nLin   , 65   Say "0.000"
      Else
         @ nLin   , 64  Say aCQC[nF][12]
      EndIf
      If aCQC[nF][13] = 00.000
         @ nLin   , 76   Say "0.000"
      Else
         @ nLin   , 75  Say aCQC[nF][13]
      EndIf
      If aCQC[nF][14] = 00.000
         @ nLin   , 87   Say "0.000"
      Else
         @ nLin   , 86  Say aCQC[nF][14]
      EndIf
      If aCQC[nF][15] = 00.000
         @ nLin   , 98   Say "0.000"
      Else
         @ nLin   , 97  Say aCQC[nF][15]
      EndIf
      If aCQC[nF][16] = 00.000
         @ nLin   , 109 Say "0.000"
      Else
         @ nLin   , 108 Say aCQC[nF][16]
      EndIf
      If aCQC[nF][17] = 00.000
         @ nLin   , 120 Say "0.000"
      Else
         @ nLin   , 119 Say aCQC[nF][17]
      EndIf
      If aCQC[nF][18] = 00.000
         @ nLin   , 131 Say "0.000"
      Else
         @ nLin   , 130 Say aCQC[nF][18]
      EndIf
      If aCQC[nF][19] = 00.000
         @ nLin   , 142 Say "0.000"
      Else
         @ nLin   , 141 Say aCQC[nF][19]
      EndIf
      If aCQC[nF][20] = 00.000
         @ nLin   , 153 Say "0.000"
      Else
         @ nLin   , 152 Say aCQC[nF][20]
      EndIf
      @ nLin++ , 159 Say "º"
      nF++
End
@ nLin++ , 0   Say "È" + Replicate("Í",6) + "Ï" + Replicate("Í",151) + "¼"

@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 13  Say "P R O P R I E D A D E S    F I S I C A S   /   M E C A N I C A S"
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "Ì" + Replicate("Í",6) + "Ñ" + Replicate("Í",91) + ;
                   "Ñ" + Replicate("Í",24) + "Ñ" + Replicate("Í",13) + ;
                   "Ñ" + Replicate("Í",20) + "¹"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
@ nLin   , 99  Say "³"
@ nLin   , 124 Say "³"
@ nLin   , 138 Say "³"
FonteNegrito( nLin )
@ nLin   , 2   Say "Item"
@ nLin   , 10  Say "Limite de Escoamento"
@ nLin   , 33  Say "Limite de Resistˆncia"
@ nLin   , 57  Say "Estric‡ao"
@ nLin   , 69  Say "Alongamento"
@ nLin   , 83  Say "Dureza Brinell"
@ nLin   , 103 Say "Corrida"
@ nLin   , 114 Say "Corrida"
@ nLin   , 126 Say "Certificado"
@ nLin   , 140 Say "Observa‡oes"
FonteClara( nLin )
@ nLin++ , 164 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
@ nLin   , 99  Say "³"
@ nLin   , 124 Say "³"
@ nLin   , 138 Say "³"
FonteNegrito( nLin )
@ nLin   , 1   Say " "
@ nLin   , 16  Say "(kgf/mmý)"
@ nLin   , 39  Say "(kgf/mmý)"
@ nLin   , 60  Say "(%)"
@ nLin   , 73  Say "(%)"
@ nLin   , 88  Say "(HB)"
@ nLin   , 102 Say "Conesteel"
@ nLin   , 113 Say "Fornecedor"
@ nLin   , 126 Say "Fornecedor"
FonteClara( nLin )
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "Ç" + Replicate("Ä",6) + "Å" + Replicate("Ä",91) + ;
                   "Å" + Replicate("Ä",24) + "Å" + Replicate("Ä",13) + ;
                   "Å" + Replicate("Ä",20) + "¶"
nF := 3
While nF <= 9
      @ nLin   , 0   Say "º"
      @ nLin   , 7   Say "³"
      @ nLin   , 99  Say "³"
      @ nLin   , 124 Say "³"
      @ nLin   , 138 Say "³"
      @ nLin   , 3   Say aCQC[nF][1 ]
      If aCQC[nF][21] = 00.00
         @ nLin   , 18  Say "00.00"
      Else
         @ nLin   , 18  Say aCQC[nF][21]
      EndIf
      If aCQC[nF][22] = 00.00
         @ nLin   , 41  Say "00.00"
      Else
         @ nLin   , 41  Say aCQC[nF][22]
      EndIf
      If aCQC[nF][23] = 00.00
         @ nLin   , 59  Say "00.00"
      Else
         @ nLin   , 59  Say aCQC[nF][23]
      EndIf
      If aCQC[nF][24] = 00.00
         @ nLin   , 72  Say "00.00"
      Else
         @ nLin   , 72  Say aCQC[nF][24]
      EndIf
      @ nLin   , 87  Say aCQC[nF][25]
      @ nLin   , 102 Say aCQC[nF][26]
      @ nLin   , 113 Say aCQC[nF][27]
      @ nLin   , 126 Say aCQC[nF][28]
      @ nLin   , 140 Say aCQC[nF][ 6]
      @ nLin++ , 159 Say "º"
      nF++
End
@ nLin++ , 0   Say "È" + Replicate("Í",6) + "Ï" + Replicate("Í",91) + ;
                   "Ï" + Replicate("Í",24) + "Ï" + Replicate("Í",13) + ;
                   "Ï" + Replicate("Í",20) + "¼"

FontePequena( nLin )
FonteNegrito( nLin )
@ nLin++, 0   Say "- Os certificados de qualidade originais encontram-se " + ;
                  "em nosso poder … sua disposi‡ao. Material normalizado " + ;
                  "dentro dos padroes."
@ nLin++  , 0   Say "- Estas v lvulas foram testadas e inspecionadas, " + ;
                    "testes visuais, dimensionais e hidr ulicos, " + ;
                    "consideradas aprovadas."
FonteClara( nLin )

@ nLin   , 0   Say "É" + Replicate("Í",54) + "»"
@ nLin++ , 56  Say "É" + Replicate("Í",54) + "»"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 56  Say "º"
@ nLin   , 111 Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 4   Say "NORMAS DE CONSTRU€AO"
@ nLin++ , 34  Say "INSPE€AO E TESTE"
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say "Ì" + Replicate("Í",54) + "¹"
@ nLin   , 56  Say "Ì" + Replicate("Í",54) + "¹"
FonteNegrito( nLin )
@ nLin   , 0   Say " "

If MONTH( DATE() ) = 1
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Janeiro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 2
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Fevereiro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 3
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Mar‡o de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 4
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Abril de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 5
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Maio de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 6
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Junho de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 7
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Julho de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 8
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Agosto de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 9
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Setembro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 10
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Outubro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 11
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Novembro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 12
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Dezembro de " + Transform( YEAR( DATE() ) , "9999" )
EndIf

@ nLin++ , 114 Say cData
FonteClara( nLin )
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 56  Say "º"
@ nLin   , 111 Say "º"
@ nLin   , 2   Say "Fabrica‡ao conforme normas API 602 e BS 5352."
@ nLin++ , 58  Say "V lvulas testadas conforme norma API 598."
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 56  Say "º"
@ nLin   , 111 Say "º"
@ nLin   , 2   Say "Extremidades roscadas: ANSI/ASME B1.10.1"
@ nLin++ , 58  Say "CORPO E CONTRA-VEDA€AO : " + Trim(aCQC[2][9]) + " - Aprovado"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 56  Say "º"
@ nLin   , 111 Say "º"
@ nLin   , 2   Say "Extremidades encaixe p/solda: ANSI/ASME B16.11"
@ nLin++ , 58  Say "VEDA€AO LADO A         : " + Trim(aCQC[2][10]) + " - Aprovado"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 56  Say "º"
@ nLin   , 111 Say "º"
@ nLin   , 2   Say "Extremidades flanges adap.: ANSI/ASME B16.5 e B16.10"
@ nLin   , 58  Say "VEDA€AO LADO B         : " + Trim(aCQC[2][10]) + " - Aprovado"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 114 Say "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
FonteClara( nLin )
@ nLin   , 0   Say "È" + Replicate("Í",54) + "¼"
@ nLin   , 56  Say "È" + Replicate("Í",54) + "¼"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 114 Say "C O N T R O L E     D E     Q U A L I D A D E"
@ nLin   , 0   Say " "
FonteNormal( nLin )
// estas linhas aqui sao para resetar a impressora com fontes normais
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(048)+CHR(065)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(080)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(069)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(070)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(107)+CHR(053)+CHR(087)

Eject

Set Device To Screen

Return NIL



**********************
Function CQCON( aCQC )
**********************

/****************************************************************************
aCQC := { { cCQ , cCliApelido , cEmpresa , cCGC , dData , nNF , cPedido } , ;
      |   { 1 , nQt1 , cFig1 , cDesc1 , cCla1 , cExt1 , cBit1 , cMat1 , ;
   12 |     cObs1 , cC1 , cSI1 , cMN1 , cP1 , cS1 , cCR1 , cNI1 , cMO1 ,;
   X's|     cCU1 , cV1 , cNB1 , cAL1 , cTI1 , cN21 , cLE1 , cLR1 , cEst1,;
      |     cAlong1 , cDur1 , cCorCon1 , cCorFor1 , cCerFor1 } , ;
****************************************************************************/

Local nF, nG, nI, cCQ, cPecas, cData, xFig , nLin := 0

nF := nG := 1
nLin := 0
cCQ := space(10)

Set Date To British
Set Device To Print

@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(050)+CHR(054)+CHR(065)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(054)+CHR(080)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(054)+CHR(069)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(054)+CHR(070)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(107)+CHR(054)+CHR(087)

FontePequena( nLin )
@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteGrande( nLin )
FonteNegrito( nLin )
@ nLin   , 4   Say "CONESTEEL CONEXOES DE A€O LTDA."
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 8   Say "C.N.P.J. 55.783.427/0001-03   -   Avenida Montemagno, 2.454 - Vila Formosa - Sao Paulo - (SP) - Fone: (011) 6910-1444 - Fax: (011) 6910-5701"
@ nLin++ , 159 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",158) + "¼"
nLin++

nF := Len( LTRIM( aCQC[1][1] ) )
nG := 10 - nF
cCQ := LTRIM( aCQC[1][1] )
For nI = 1 To nG
    cCQ := "0" + cCQ
Next

FonteGrande( nLin )
FonteNegrito( nLin )
@ nLin++ , 1   Say "CERTIFICADO DE QUALIDADE n§ " + cCQ
FonteClara( nLin )
FontePequena( nLin )
nLin++

@ nLin++ , 0   Say "É" + Replicate("Í",63) + "Ñ" + Replicate("Í",29) + "Ñ" + ;
                   Replicate("Í",18) + "Ñ" + Replicate("Í",15) + "Ñ" + ;
                   Replicate("Í",29) + "»"
@ nLin   , 0   Say "º"
@ nLin   , 64  Say "³"
@ nLin   , 94  Say "³"
@ nLin   , 113 Say "³"
@ nLin   , 129 Say "³"
FonteNegrito( nLin )
@ nLin   , 7   Say "CLIENTE : "
@ nLin   , 71  Say "C.N.P.J.: "
@ nLin   , 101 Say "DATA : "
@ nLin   , 120 Say "N.F.: "
@ nLin   , 136 Say "PEDIDO : "
FonteClara( nLin )
@ nLin   , 17  Say aCQC[1][3]
@ nLin   , 81  Say aCQC[1][4]
@ nLin   , 108 Say aCQC[1][5]
@ nLin   , 120 Say aCQC[1][6]
@ nLin   , 145 Say aCQC[1][7]
@ nLin++ , 164 Say "º"
@ nLin++ , 0   Say "È" + Replicate("Í",63) + "Ï" + Replicate("Í",29) + "Ï" + ;
                   Replicate("Í",18) + "Ï" + Replicate("Í",15) + "Ï" + ;
                   Replicate("Í",29) + "¼"
nLin++

FontePequena( nLin )
@ nLin++ , 0   Say "É" + Replicate("Í",158) + "»"
@ nLin   , 0   Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 30  Say "DISCRIMINA€AO   DOS   PRODUTOS"
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 159 Say "º"
@ nLin++ , 0   Say "Ì" + Replicate("Í",6) + "Ñ" + Replicate("Í",12) + ;
                   "Ñ" + Replicate("Í",9) + "Ñ" + Replicate("Í",84) + ;
                   "Ñ" + Replicate("Í",22) + "Ñ" + Replicate("Í",20) + "¹"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
@ nLin   , 20  Say "³"
@ nLin   , 30  Say "³"
@ nLin   , 115 Say "³"
@ nLin   , 138 Say "³"
FonteNegrito( nLin )
@ nLin  , 2   Say "Item"
@ nLin  , 9   Say "Quantidade"
@ nLin  , 22  Say "Figura"
@ nLin  , 32  Say "Descri‡ao do Material"
@ nLin  , 61  Say "Classe"
@ nLin  , 69  Say "Extremidade"
@ nLin  , 82  Say "Bitola"
@ nLin  , 99  Say "Material"
@ nLin  , 118 Say "Corrida Conesteel"
@ nLin  , 140 Say "Observa‡oes"
FonteClara( nLin )
@ nLin++, 164 Say "º"
@ nLin++ , 0  Say CHR(199) + Replicate("Ä",6) + "Å" + Replicate("Ä",12) + ;
                   "Å" + Replicate("Ä",9) + "Å" + Replicate("Ä",84) + ;
                   "Å" + Replicate("Ä",22) + "Å" + Replicate("Ä",20) + CHR(182)

nF := 2
While nF <= 13
      @ nLin   , 0   Say "º"
      @ nLin   , 7   Say "³"
      @ nLin   , 20  Say "³"
      @ nLin   , 30  Say "³"
      @ nLin   , 115 Say "³"
      @ nLin   , 138 Say "³"
      If aCQC[nF][3] = "17-BT-PM" .or. ;
         aCQC[nF][3] = "17-BT-PC" .or. ;
         aCQC[nF][3] = "17-BT-PF"
         xFig := ""
      Else
         If aCQC[nF][2] = 0
            @ nLin++ ,159 Say "º"
            nF++
            Loop
         EndIf
         xFig := aCQC[nF][3]
      EndIf

      @ nLin  , 3   Say aCQC[nF][1]
      If aCQC[nF][2] = 1
         cPecas := transform( aCQC[nF][2] , "9999" ) +  " p‡."
      ElseIf aCQC[nF][2] > 1
         cPecas := transform( aCQC[nF][2] , "9999" ) +  " p‡s."
      ElseIf aCQC[nF][2] = 0
         cPecas := ""
      EndIf
      @ nLin  , 9   Say cPecas
      @ nLin  , 22  Say xFig
      @ nLin  , 32  Say aCQC[nF][4]
      @ nLin  , 61  Say aCQC[nF][5]
      @ nLin  , 69  Say aCQC[nF][6]
      @ nLin  , 82  Say aCQC[nF][7]
      @ nLin  , 99  Say aCQC[nF][8]
      @ nLin  , 125 Say aCQC[nF][29]
      @ nLin  , 140 Say aCQC[nF][9]
      @ nLin++ ,159 Say "º"
      nF++
End
@ nLin++ , 0   Say "È" + Replicate("Í",6) + "Ï" + Replicate("Í",12) + ;
                   "Ï" + Replicate("Í",9) + "Ï" + Replicate("Í",84) + ;
                   "Ï" + Replicate("Í",22) + "Ï" + Replicate("Í",20) + "¼"
nLin++

@ nLin   , 0   Say "É" + Replicate("Í",103) + "»"
@ nLin++ , 105 Say "É" + Replicate("Í",53) + "»"
@ nLin   , 0   Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 23  Say "COMPOSI€AO QUIMICA"
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say " "
@ nLin   , 104 Say "º"
@ nLin   , 105 Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 61  Say "PROPRIEDADES FISICAS"
FonteClara( nLin )
FontePequena( nLin )
@ nLin++ , 164 Say "º"
@ nLin   , 0   Say "Ì" + Replicate("Í",6) + "Ñ" + Replicate("Í",96) + "¹"
@ nLin++ , 105 Say "Ì" + Replicate("Í",53) + "¹"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
@ nLin   , 104 Say "º"
@ nLin   , 105 Say "º"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 109 Say "Limite"
@ nLin   , 120 Say "Limite"
@ nLin   , 130 Say "Estric‡ao"
@ nLin   , 140 Say "Alongamento"
@ nLin   , 152 Say "Dureza"
FonteClara( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 2   Say "Item"
@ nLin   , 11  Say "C"
@ nLin   , 19  Say "Si"
@ nLin   , 27  Say "Mn"
@ nLin   , 35  Say "P"
@ nLin   , 43  Say "S"
@ nLin   , 51  Say "Cr"
@ nLin   , 59  Say "Ni"
@ nLin   , 67  Say "Mo"
@ nLin   , 75  Say "Cu"
@ nLin   , 83  Say "V"
@ nLin   , 91  Say "Nb"
@ nLin   , 99  Say "Al"
FonteClara( nLin )
@ nLin   , 0   Say " "
@ nLin   , 104 Say "º"
@ nLin   , 105 Say "º"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 107 Say "Escoamento"
@ nLin   , 118 Say "Resistˆncia"
@ nLin   , 124 Say " "
@ nLin   , 135 Say " "
@ nLin   , 152 Say "Brinell"
FonteClara( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "º"
@ nLin   , 7   Say "³"
@ nLin   , 104 Say "º"
@ nLin   , 105 Say "º"
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 108 Say "(kgf/mmý)"
@ nLin   , 119 Say "(kgf/mmý)"
@ nLin   , 133 Say "(%)"
@ nLin   , 144 Say "(%)"
@ nLin   , 153 Say "(HB)"
FonteClara( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 159 Say "º"
@ nLin   , 0   Say "Ç" + Replicate("Ä",6) + "Å" + Replicate("Ä",96) + "¶"
@ nLin++ , 105 Say "Ç" + Replicate("Ä",53) + "¶"

nF := 2
While nF <= 13
      @ nLin   , 0   Say "º"
      @ nLin   , 7   Say "³"
      @ nLin   , 104 Say "º"
      @ nLin   , 105 Say "º"
      If aCQC[nF][10] <> 00.000 .and. aCQC[nF][11] <> 00.000 .and. ;
         aCQC[nF][12] <> 00.000 .and. aCQC[nF][13] <> 00.000 
         // Este if s¢ imprime se o C, Si, Mn e P forem <> de 0
         // SUBSTITUI O "  -  " POR "0.000"

            @ nLin   , 3   Say aCQC[nF][1 ]
            If aCQC[nF][10] = 00.000
               @ nLin   , 10   Say "0.000"
            Else
               @ nLin   , 9   Say aCQC[nF][10]
            EndIf
            If aCQC[nF][11] = 00.000
               @ nLin   , 18  Say "0.000"
            Else
               @ nLin   , 17  Say aCQC[nF][11]
            EndIf
            If aCQC[nF][12] = 00.000
               @ nLin   , 26  Say "0.000"
            Else
               @ nLin   , 25  Say aCQC[nF][12]
            EndIf
            If aCQC[nF][13] = 00.000
               @ nLin   , 34  Say "0.000"
            Else
               @ nLin   , 33  Say aCQC[nF][13]
            EndIf
            If aCQC[nF][14] = 00.000
               @ nLin   , 42  Say "0.000"
            Else
               @ nLin   , 41  Say aCQC[nF][14]
            EndIf
            If aCQC[nF][15] = 00.000
               @ nLin   , 50  Say "0.000"
            Else
               @ nLin   , 49  Say aCQC[nF][15]
            EndIf
            If aCQC[nF][16] = 00.000
               @ nLin   , 58  Say "0.000"
            Else
               @ nLin   , 57  Say aCQC[nF][16]
            EndIf
            If aCQC[nF][17] = 00.000
               @ nLin   , 66  Say "0.000"
            Else
               @ nLin   , 65  Say aCQC[nF][17]
            EndIf
            If aCQC[nF][18] = 00.000
               @ nLin   , 74  Say "0.000"
            Else
               @ nLin   , 73  Say aCQC[nF][18]
            EndIf
            If aCQC[nF][19] = 00.000
               @ nLin   , 82  Say "0.000"
            Else
               @ nLin   , 81  Say aCQC[nF][19]
            EndIf
            If aCQC[nF][20] = 00.000
               @ nLin   , 90  Say "0.000"
            Else
               @ nLin   , 89  Say aCQC[nF][20]
            EndIf
            If aCQC[nF][21] = 00.000
               @ nLin   , 98  Say "0.000"
            Else
               @ nLin   , 97  Say aCQC[nF][21]
            EndIf
            If aCQC[nF][24] = 00.00
               @ nLin   , 111 Say "00.00"
            Else
               @ nLin   , 110 Say aCQC[nF][24]
            EndIf
            If aCQC[nF][25] = 00.00
               @ nLin   , 120 Say "00.00"
            Else
               @ nLin   , 121 Say aCQC[nF][25]
            EndIf
            If aCQC[nF][26] = 00.00
               @ nLin   , 131 Say "00.00"
            Else
               @ nLin   , 132 Say aCQC[nF][26]
            EndIf
            If aCQC[nF][27] = 00.00
               @ nLin   , 143 Say "00.00"
            Else
               @ nLin   , 143 Say aCQC[nF][27]
            EndIf
            @ nLin   , 152 Say aCQC[nF][28]
      EndIf
      If SUBSTR( aCQC[nF][3] , 1 , 2 ) <> "17" .or. ;
         SUBSTR( aCQC[nF][3] , 1 , 2 ) <> "18" .or. ;
         SUBSTR( aCQC[nF][3] , 1 , 2 ) <> "19" 
         @ nLin++ , 159 Say "º"
      EndIf
      nF++
End
@ nLin   , 0   Say "È" + Replicate("Í",6) + "Ï" + Replicate("Í",96) + "¼"
@ nLin++ , 105 Say "È" + Replicate("Í",53) + "¼"
nLin++

FontePequena( nLin )
FonteNegrito( nLin )
@ nLin++, 0   Say "- Os certificados de qualidade originais encontram-se " + ;
                  "em nosso poder … sua disposi‡ao. Material normalizado " + ;
                  "dentro dos padroes."
@ nLin++  , 0   Say "- Estas conexoes foram submetidas … testes visuais/" + ;
                    "dimensionais, nas quais foram consideradas aprovadas."
FonteClara( nLin )

@ nLin++ , 0   Say "É" + Replicate("Í",54) + "»"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin++ , 4   Say "NORMAS DE FABRICA€AO"
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say "Ì" + Replicate("Í",54) + "¹"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 0   Say " "

If MONTH( DATE() ) = 1
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Janeiro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 2
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Fevereiro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 3
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Mar‡o de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 4
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Abril de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 5
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Maio de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 6
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Junho de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 7
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Julho de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 8
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Agosto de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 9
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Setembro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 10
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Outubro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 11
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Novembro de " + Transform( YEAR( DATE() ) , "9999" )
ElseIf MONTH( DATE() ) = 12
   cData := "Sao Paulo, " + Transform( DAY( DATE() ) , "99" ) + ;
            " de Dezembro de " + Transform( YEAR( DATE() ) , "9999" )
EndIf

@ nLin++ , 47  Say cData
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say " "
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin++ , 2   Say "Fabrica‡ao conforme normas ANSI/ASME B16.11 - 1991"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin++ , 2   Say "Extremidades roscadas: ANSI/ASME B1.20.1 - 1983"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin++ , 2   Say "Extremidades encaixe p/solda: ANSI/ASME B16.11 -1991"
@ nLin   , 0   Say "º"
@ nLin   , 55  Say "º"
@ nLin   , 2   Say "Extremidades biseladas: ANSI/ASME B16.9 - 1986"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin++ , 47  Say "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
FonteClara( nLin )
FontePequena( nLin )
@ nLin   , 0   Say " "
@ nLin   , 0   Say "È" + Replicate("Í",54) + "¼"
FonteNormal( nLin )
FonteNegrito( nLin )
@ nLin   , 0   Say " "
@ nLin   , 47  Say "DEPTO. DE CONTROLE DE QUALIDADE"
@ nLin   , 0   Say " "
FonteClara( nLin )
FonteNormal( nLin )
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(048)+CHR(065)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(080)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(069)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(108)+CHR(054)+CHR(048)+CHR(070)
@ nLin   , 0   Say CHR(027)+CHR(038)+CHR(107)+CHR(053)+CHR(087)

Eject

Set Device To Screen

Return NIL

          
 
*****************************************************************************
// FUN€OES AUXILIARES DAS FUNCOES CQVAL() E CQCON()
*****************************************************************************

*****************************
Function FontePequena( nLin )
*****************************
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(050)+CHR(048)+CHR(072)
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(084)
Return NIL

*****************************
Function FonteGrande( nLin )
*****************************
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(053)+CHR(072)
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(084)
Return NIL

*****************************
Function FonteNormal( nLin )
*****************************
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(049)+CHR(048)+CHR(072)
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(084)
Return NIL

*****************************
Function FonteNegrito( nLin )
*****************************
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(051)+CHR(066)
Return NIL

***************************
Function FonteClara( nLin )
***************************
@ nLin,0 Say CHR(027)+CHR(040)+CHR(115)+CHR(048)+CHR(066)
Return NIL


