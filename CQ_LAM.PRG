/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               CQ_LAM.PRG                                  *
****************************************************************************/

Local nLin,aFor,nN,aFor2,cTela,nRec,cFig,cBit,aCor,aFig,cMat,nM,nTam,cCor
Local cCor2,aTab,aVaz,nOp,aFor3,cLetra,nNum,cLet,aMenu,aDisp,aDados,aPecas
Local xLaminado,xMat,xCor,xFor,xCO,xData,xC,xSi,xMn,xP,xS,xCr,xNi,xMo,xCu,xV
Local xNb,xAl,xTi,xN2,xLIMESC,xLIMRES,xESTRI,xALONG,xDur,xObs,xBit,aFor4,aLet
Local lTeste , nMenu
Local GetList := {}

nLin := nN := nTam := nRec := nM := nOp := 0
xC := xSi := xMn := xP := xS := xCr := xNi := xMo := xCu := xV := 0
xNb := xAl := xTi := xN2 := xLIMESC := xLIMRES := xESTRI := xALONG := 0
aFor := aFor2 := aCor := aFig := aFor3 := aFor4 := aLet := {}
xLaminado := xMat := xCor := xCO := cFig := cBit := cMat := space(10)
cCor := cCor2 := xBit := space(10)
xFor := space(15)
xDur := space(12)
xObs := space(30)
cLetra := cLet := space(2)
xData := CtoD("")

Use CON_COMP 
Use CF_CORR New 
Use CORRIDA New 

While .T. .or. LastKey() = 27
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
      @  6,24 Say "CERTIFICADOS QUALIDADE LAMINADOS"
      While xLaminado = space(10) .or. LastKey() = 27
            @  8,5  Say "Laminado" 
            xLaminado := Menu( "LL" , 10 , 14 , 14 , 21 )
            @  8,13 Say xLaminado picture "@!" color "B/W+"
      End
      While xBit = space(10) .or. LastKey() = 27
            @  8,24 Say "í"
            xBit := Menu( "BL" , 10 , 26 , 14 , 33 )
            @  8,26 Say xBit picture "@!" color "B/W+"
      End
      While xMat = space(10) .or. LastKey() = 27
            @  8,37 Say "Material"
            xMat := Menu( "MT" , 10 , 47 , 14 , 57 )
            @  8,46 Say xMat picture "@!" color "B/W+"
      End
      While xCor = space(10) .or. LastKey() = 27
            @  8,57 Say "Corrida" Get xCor picture "@!"
            Read
      End
      If xLaminado <> space(10) .and. xBit <> space(10) .and. ;
         xMat <> space(10) .and. xCor <> space(10)
         exit
      EndIf
End

If LastKey() = 27
   Cls
   Clear Typeahead
   dbCloseAll()
   Return
EndIf

// Procurar se existe esse certificado
dbSelectArea("CON_COMP")
dbGoTop()
// Inserir no vetor aFor todos forjados dessa figura
aFor := {}
While .not. EOF()
      If RTRIM( CON_COMP->MP ) == RTRIM( xLaminado )
         Aadd(aFor, { CON_COMP->MP , CON_COMP->BITOLA_MP ,;
               CON_COMP->MATERIAL , CON_COMP->CORR_FORN , RecNo() } )
      EndIf
      dbSkip(1)
End
// Inseri no vetor aFor2 s¢ os forjados com respectiva bitola
If Len( aFor ) <> 0
   nN := 1
   aFor2 := {}
   While nN <= Len( aFor )
         If RTRIM( aFor[nN][2] ) == RTRIM( xBit )
            Aadd(aFor2, { aFor[nN][3] , aFor[nN][4] , aFor[nN][5] } )
         EndIf
         nN++
   End
EndIf
// Inseri no vetor aFor3 s¢ os forjados com respectiva material
If Len( aFor2 ) <> 0
   nN := 1
   aFor3 := {}
   While nN <= Len( aFor2 )
         If RTRIM( aFor2[nN][1] ) == RTRIM( xMat )
            Aadd(aFor3, { aFor2[nN][2] , aFor2[nN][3] } )
         EndIf
         nN++
   End
EndIf
// Inseri no vetor aFor2 s¢ o forjado com respectiva corrida
If Len( aFor3 ) <> 0
   nN := 1
   While nN <= Len( aFor3 )
         If RTRIM( aFor3[nN][1] ) == RTRIM( xCor )
            nRec := aFor3[nN][2]
         EndIf
         nN++
   End
EndIf

aDados := aPecas := {}

Begin Sequence

// Se nRec for diferente de zero, entao o registro existe !!!
If nRec <> 0
   dbGoTo( nRec )
   xLaminado:= CON_COMP->MP
   Aadd(aDados, xLaminado)
   xBit    := CON_COMP->BITOLA_MP
   Aadd(aDados, xBit)
   xMat    := CON_COMP->MATERIAL
   Aadd(aDados, xMat)
   xCor    := CON_COMP->CORR_FORN
   Aadd(aDados, xCor)
   xFor    := CON_COMP->FORNECEDOR
   Aadd(aDados, xFor)
   xCO     := CON_COMP->CO
   Aadd(aDados, xCO)
   xData   := CON_COMP->DATACOMPRA
   Aadd(aDados, xData)
   xC      := CON_COMP->C
   Aadd(aDados, xC)
   xSi     := CON_COMP->SI
   Aadd(aDados, xSi)
   xMn     := CON_COMP->MN
   Aadd(aDados, xMn)
   xP      := CON_COMP->P
   Aadd(aDados, xP)
   xS      := CON_COMP->S
   Aadd(aDados, xS)
   xCr     := CON_COMP->CR
   Aadd(aDados, xCr)
   xNi     := CON_COMP->NI
   Aadd(aDados, xNi)
   xMo     := CON_COMP->MO
   Aadd(aDados, xMo)
   xCu     := CON_COMP->CU
   Aadd(aDados, xCu)
   xV      := CON_COMP->V
   Aadd(aDados, xV)
   xNb     := CON_COMP->NB
   Aadd(aDados, xNb)
   xAl     := CON_COMP->AL
   Aadd(aDados, xAl)
   xTi     := CON_COMP->TI
   Aadd(aDados, xTi)
   xN2      := CON_COMP->N2
   Aadd(aDados, xN2)
   xLIMESC := CON_COMP->LIM_ESCO
   Aadd(aDados, xLIMESC)
   xLIMRES := CON_COMP->LIM_RESIS
   Aadd(aDados, xLIMRES)
   xESTRI  := CON_COMP->ESTRI
   Aadd(aDados, xESTRI)
   xALONG  := CON_COMP->ALONGA
   Aadd(aDados, xALONG)
   xDur    := CON_COMP->DUREZA
   Aadd(aDados, xDur)
   xObs    := CON_COMP->OBS
   Aadd(aDados, xObs)
   cCor    := CON_COMP->CORRIDA
   Aadd(aDados, cCor)
   @ 13,18 clear to 17,70
   @ 10,5  Say "Data Compra:" Get xData
   @ 10,29 Say "Fornecedor:" Get xFor picture "@!"
   @ 10,57 Say "N§ CO :" Get xCO picture "@!" 
   @ 11,4  Say "Ì"
   @ 11,5  Say Replicate("Í",70)
   @ 11,75 Say "¹"
   @ 12,27 Say "% DAS COMPOSI€OES QUIMICAS"
   @ 13,4  Say "Ì"
   @ 13,5  Say Replicate("Í",70)
   @ 13,75 Say "¹"
   @ 14,5  Say "C :" Get xC  picture "99.999"
   @ 14,15 Say "Si:" Get xSi picture "99.999"
   @ 14,25 Say "Mn:" Get xMn picture "99.999"
   @ 14,35 Say "P :" Get xP  picture "99.999"
   @ 14,45 Say "S :" Get xS  picture "99.999"
   @ 14,55 Say "Cr:" Get xCr picture "99.999"
   @ 14,65 Say "Ni:" Get xNi picture "99.999"
   @ 16,5  Say "Mo:" Get xMo picture "99.999"
   @ 16,15 Say "Cu:" Get xCu picture "99.999"
   @ 16,25 Say "V :" Get xV  picture "99.999"
   @ 16,35 Say "Nb:" Get xNb picture "99.999"
   @ 16,45 Say "Al:" Get xAl picture "99.999"
   @ 16,55 Say "Ti:" Get xTi picture "99.999"
   @ 16,65 Say "N2 :" Get xN2  picture "99.999"
   @ 17,4  Say "Ì"
   @ 17,5  Say Replicate("Í",70)
   @ 17,75 Say "¹"
   @ 18,27 Say "% DAS COMPOSI€OES MECANICAS"
   @ 19,4  Say "Ì"
   @ 19,5  Say Replicate("Í",70)
   @ 19,75 Say "¹"
   @ 20,5  Say "Lim.Esc.:" Get xLIMESC picture "99.99"
   @ 20,22 Say "Lim.Res.:" Get xLIMRES picture "99.99"
   @ 20,39 Say "Estric‡ao:" Get xESTRI picture "99.99"
   @ 20,57 Say "Alongamento:" Get xALONG picture "99.99"
   @ 21,5  Say "Dureza :" Get xDur picture "@!"
   @ 21,31 Say "Observa‡oes :" Get xObs picture "@!"
   @ 22,5  Say "Corrida da Conesteel :" Get cCor
   Read
   // Aqui se fizer alguma altera‡ao, pergunta se deseja salvar
   If xFor     <> CON_COMP->FORNECEDOR .or. ;
      xCO      <> CON_COMP->CO         .or. ;
      xData    <> CON_COMP->DATACOMPRA .or. ;
      xC       <> CON_COMP->C          .or. ;
      xSi      <> CON_COMP->SI         .or. ;
      xMn      <> CON_COMP->MN         .or. ;
      xP       <> CON_COMP->P          .or. ;
      xS       <> CON_COMP->S          .or. ;
      xCr      <> CON_COMP->CR         .or. ;
      xNi      <> CON_COMP->NI         .or. ;
      xMo      <> CON_COMP->MO         .or. ;
      xCu      <> CON_COMP->CU         .or. ;
      xV       <> CON_COMP->V          .or. ;
      xNb      <> CON_COMP->NB         .or. ;
      xAl      <> CON_COMP->AL         .or. ;
      xTi      <> CON_COMP->TI         .or. ;
      xN2       <> CON_COMP->N2          .or. ;
      xLIMESC  <> CON_COMP->LIM_ESCO   .or. ;
      xLIMRES  <> CON_COMP->LIM_RESIS  .or. ;
      xESTRI   <> CON_COMP->ESTRI      .or. ;
      xALONG   <> CON_COMP->ALONGA     .or. ;
      xDur     <> CON_COMP->DUREZA     .or. ;
      xObs     <> CON_COMP->OBS

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
      If nN = 1
         dbGoTo( nRec )
         aDados := {}
         CON_COMP->MP   := xLaminado
         Aadd(aDados, xLaminado)
         CON_COMP->BITOLA_MP:= xBit
         Aadd(aDados, xBit)
         CON_COMP->MATERIAL   := xMat
         Aadd(aDados, xMat)
         CON_COMP->CORR_FORN  := xCor
         Aadd(aDados, xCor)
         CON_COMP->FORNECEDOR := xFor
         Aadd(aDados, xFor)
         CON_COMP->CO         := xCO
         Aadd(aDados, xCO)
         CON_COMP->DATACOMPRA := xData
         Aadd(aDados, xData)
         CON_COMP->C          := xC
         Aadd(aDados, xC)
         CON_COMP->SI         := xSi
         Aadd(aDados, xSi)
         CON_COMP->MN         := xMn
         Aadd(aDados, xMn)
         CON_COMP->P          := xP
         Aadd(aDados, xP)
         CON_COMP->S          := xS
         Aadd(aDados, xS)
         CON_COMP->CR         := xCr
         Aadd(aDados, xCr)
         CON_COMP->NI         := xNi
         Aadd(aDados, xNi)
         CON_COMP->MO         := xMo
         Aadd(aDados, xMo)
         CON_COMP->CU         := xCu
         Aadd(aDados, xCu)
         CON_COMP->V          := xV
         Aadd(aDados, xV)
         CON_COMP->NB         := xNb
         Aadd(aDados, xNb)
         CON_COMP->AL         := xAl
         Aadd(aDados, xAl)
         CON_COMP->TI         := xTi
         Aadd(aDados, xTi)
         CON_COMP->N2          := xN2
         Aadd(aDados, xN2)
         CON_COMP->LIM_ESCO   := xLIMESC
         Aadd(aDados, xLIMESC)
         CON_COMP->LIM_RESIS  := xLIMRES
         Aadd(aDados, xLIMRES)
         CON_COMP->ESTRI      := xESTRI
         Aadd(aDados, xESTRI)
         CON_COMP->ALONGA     := xALONG
         Aadd(aDados, xALONG)
         CON_COMP->DUREZA     := xDur
         Aadd(aDados, xDur)
         CON_COMP->OBS        := xObs
         Aadd(aDados, xObs)
         CON_COMP->CORRIDA    := cCor
         Aadd(aDados, cCor)
      EndIf
      RestScreen(10,23,18,61,cTela)
   EndIf
   Tone(500,2)
   @ 24,15 Say "Pressione qualquer tecla para continuar..."
   Inkey(00)

// Se nRec = 0, entao o registro ‚ NOVO !!!
Else
   Tone(500,1) ; Tone(300,1) ; Tone(800,2)
   @ 15,20 Say "Esse registro nao existe no Banco de Dados" color "GR+*/B"
   @ 16,26 Say "Deseja incluir novo registro ?"
   @ 18,33 Prompt "Sim"
   @ 18,46 Prompt "Nao"
   Menu To nN 
   If nN = 2
      break
   EndIf
   @ 13,18 clear to 17,70
   @ 10,5  Say "Data Compra:" Get xData
   @ 10,29 Say "Fornecedor:" Get xFor picture "@!"
   @ 10,57 Say "N§ CO :" Get xCO picture "@!" 
   @ 11,4  Say "Ì"
   @ 11,5  Say Replicate("Í",70)
   @ 11,75 Say "¹"
   @ 12,27 Say "% DAS COMPOSI€OES QUIMICAS"
   @ 13,4  Say "Ì"
   @ 13,5  Say Replicate("Í",70)
   @ 13,75 Say "¹"
   @ 14,5  Say "C :" Get xC  picture "99.999"
   @ 14,15 Say "Si:" Get xSi picture "99.999"
   @ 14,25 Say "Mn:" Get xMn picture "99.999"
   @ 14,35 Say "P :" Get xP  picture "99.999"
   @ 14,45 Say "S :" Get xS  picture "99.999"
   @ 14,55 Say "Cr:" Get xCr picture "99.999"
   @ 14,65 Say "Ni:" Get xNi picture "99.999"
   @ 16,5  Say "Mo:" Get xMo picture "99.999"
   @ 16,15 Say "Cu:" Get xCu picture "99.999"
   @ 16,25 Say "V :" Get xV  picture "99.999"
   @ 16,35 Say "Nb:" Get xNb picture "99.999"
   @ 16,45 Say "Al:" Get xAl picture "99.999"
   @ 16,55 Say "Ti:" Get xTi picture "99.999"
   @ 16,65 Say "N2 :" Get xN2  picture "99.999"
   @ 17,4  Say "Ì"
   @ 17,5  Say Replicate("Í",70)
   @ 17,75 Say "¹"
   @ 18,27 Say "% DAS COMPOSI€OES MECANICAS"
   @ 19,4  Say "Ì"
   @ 19,5  Say Replicate("Í",70)
   @ 19,75 Say "¹"
   @ 20,5  Say "Lim.Esc.:" Get xLIMESC picture "99.99"
   @ 20,22 Say "Lim.Res.:" Get xLIMRES picture "99.99"
   @ 20,39 Say "Estric‡ao:" Get xESTRI picture "99.99"
   @ 20,57 Say "Alongamento:" Get xALONG picture "99.99"
   @ 21,5  Say "Dureza :" Get xDur picture "@!"
   @ 21,31 Say "Observa‡oes :" Get xObs picture "@!"
   @ 22,5  Say "Corrida da Conesteel :"
   Read
   // Aqui vai procurar numero de corrida vazio
   dbSelectArea("CORRIDA")
   dbGoTop()
   cCor := space(3)
   aTab := {}
   aVaz := {}
   While .not. EOF()
         If CORRIDA->MP = space(12)
            Aadd( aTab , RecNo() )
            Aadd( aVaz , CORRIDA->CORRIDA )
         EndIf    
         dbSkip(1)
   End
   aMenu := aVaz
   nM := 1
   aDisp := {}
   While nM <= Len( aVaz )
         Aadd( aDisp , .t. )
         nM++
   End
   cTela := SaveScreen(14,27,21,51)
   SetColor("R+/N,GR+/B")
   @ 14,27 clear to 21,51
   DispBox(14,27,21,51,2)
   nOp := Achoice ( 15, 28, 20, 32, aMenu, aDisp, 'Auxiliar_da_Achoice')
   RestScreen(14,27,21,51,cTela)
   SetColor("GR+/B,B/W+")
   nM := aTab[nOp]
   dbSelectArea("CORRIDA")
   dbGoTo( nM )
   cCor := RTRIM( CORRIDA->CORRIDA )
   CORRIDA->MP     := xLaminado
   CORRIDA->BITOLA_MP     := xBit
   CORRIDA->CORRIDAFOR := xCor
   CORRIDA->MATERIAL   := xMat
   @ 22,28 Get cCor
   Tone(500,2)
   @ 24,15 Say "Pressione qualquer tecla para continuar..."
   Inkey(00)

   // Aqui ira perguntar se deseja salvar esse registro
   Tone(500,1) ; Tone(300,1) ; Tone(800,2)
   cTela := SaveScreen(10,23,18,61)
   Tela("R+/N,GR+/B",11,24,17,60) 
   SetColor("R+/N,GR+/B")
   @ 12,27 Say "Deseja salvar esse registro ?"
   @ 14,33 Prompt "Sim"
   @ 14,46 Prompt "Nao"
   SetColor("GR+/B,B/W+")
   Menu to nN
   If nN = 1
      dbSelectArea("CON_COMP")
      dbAppend()
      aDados := aPecas := {}
      CON_COMP->MP   := xLaminado
      Aadd(aDados, xLaminado)
      CON_COMP->BITOLA_MP:= xBit
      Aadd(aDados, xBit)
      CON_COMP->MATERIAL   := xMat
      Aadd(aDados, xMat)
      CON_COMP->CORR_FORN  := xCor
      Aadd(aDados, xCor)
      CON_COMP->FORNECEDOR := xFor
      Aadd(aDados, xFor)
      CON_COMP->CO         := xCO
      Aadd(aDados, xCO)
      CON_COMP->DATACOMPRA := xData
      Aadd(aDados, xData)
      CON_COMP->C          := xC
      Aadd(aDados, xC)
      CON_COMP->SI         := xSi
      Aadd(aDados, xSi)
      CON_COMP->MN         := xMn
      Aadd(aDados, xMn)
      CON_COMP->P          := xP
      Aadd(aDados, xP)
      CON_COMP->S          := xS
      Aadd(aDados, xS)
      CON_COMP->CR         := xCr
      Aadd(aDados, xCr)
      CON_COMP->NI         := xNi
      Aadd(aDados, xNi)
      CON_COMP->MO         := xMo
      Aadd(aDados, xMo)
      CON_COMP->CU         := xCu
      Aadd(aDados, xCu)
      CON_COMP->V          := xV
      Aadd(aDados, xV)
      CON_COMP->NB         := xNb
      Aadd(aDados, xNb)
      CON_COMP->AL         := xAl
      Aadd(aDados, xAl)
      CON_COMP->TI         := xTi
      Aadd(aDados, xTi)
      CON_COMP->N2          := xN2
      Aadd(aDados, xN2)
      CON_COMP->LIM_ESCO   := xLIMESC
      Aadd(aDados, xLIMESC)
      CON_COMP->LIM_RESIS  := xLIMRES
      Aadd(aDados, xLIMRES)
      CON_COMP->ESTRI      := xESTRI
      Aadd(aDados, xESTRI)
      CON_COMP->ALONGA     := xALONG
      Aadd(aDados, xALONG)
      CON_COMP->DUREZA     := xDur
      Aadd(aDados, xDur)
      CON_COMP->OBS        := xObs
      Aadd(aDados, xObs)
      CON_COMP->CORRIDA    := cCor
      Aadd(aDados, cCor)
   Else
      break
   EndIf
   RestScreen(10,23,18,61,cTela)
End

// Aqui pergunta se deseja imprimir os dados 
Tone(500,1) ; Tone(300,1) ; Tone(800,2)
Tela("R+/N,GR+/B",11,22,17,62) 
SetColor("R+/N,GR+/B")
@ 12,27 Say "Deseja imprimir esses dados ?"
@ 14,33 Prompt "Sim"
@ 14,46 Prompt "Nao"
SetColor("GR+/B,B/W+")
Menu to nMenu
If nMenu = 1
   lTeste := .f.
   While lTeste := .f.
         lTeste := TestaImpressora()
   End
   CQMP( aDados , "LAMINADO" ) 
EndIf

End Sequence

Cls
Clear Typeahead
dbCloseAll()
Return



//  Lembrando:
//
//  aDados := { CON_COMP->MP , CON_COMP->MATERIAL , CON_COMP->CORR_FORN,
//              CON_COMP->FORNECEDOR , CON_COMP->CO , CON_COMP->DATACOMPRA,
//              CON_COMP->C , CON_COMP->SI , CON_COMP->MN , CON_COMP->P ,
//              CON_COMP->S , CON_COMP->S , CON_COMP->CR , CON_COMP-> NI ,
//              CON_COMP->MO , CON_COMP->CU , CON_COMP->V , CON_COMP->NB ,
//              CON_COMP->AL , CON_COMP->TI , CON_COMP->N2 , CON_COMP->LIM_ESCO,
//              CON_COMP->RESIS , CON_COMP->ESTRI , CON_COMP->ALONGA ,
//              CON_COMP->DUREZA , CON_COMP->OBS , CON_COMP->CORRIDA }
//
//  aPecas := { BIT_LAM->FIGURA , BIT_LAM->BITOLA , BIT_LAM->MATERIAL ,;
//              BIT_LAM->CORRIDA, RecNo() } 
