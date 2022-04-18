/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               CQ_VAL.PRG                                  *
****************************************************************************/

Local nLin,aFor,nN,aFor2,cTela,nRec,cFig,cBit,aCor,aFig,cMat,nM,nTam,cCor
Local cCor2,aTab,aVaz,nOp,aFor3,cLetra,nNum,cLet,aMenu,aDisp,aDados,aPecas
Local xCOMPONENTE,xMat,xCor,xFor,xCO,xData,xC,xSi,xMn,xP,xS,xCr,xNi,xMo,xCu,xV
Local xNb,xAl,xTi,xN2,xLIMESC,xLIMRES,xESTRI,xALONG,xDur,xObs,xBit,aFor4,aLet
Local lTeste , nMenu
Local GetList := {}

nLin := nN := nTam := nRec := nM := nOp := 0
xC := xSi := xMn := xP := xS := xCr := xNi := xMo := xCu := xV := 0
xNb := xAl := xTi := xN2 := xLIMESC := xLIMRES := xESTRI := xALONG := 0
aFor := aFor2 := aCor := aFig := aFor3 := aFor4 := aLet := {}
xCOMPONENTE := xMat := xCor := xCO := cFig := cBit := cMat := space(10)
cCor := cCor2 := xBit := space(10)
xFor := space(15)
xDur := space(12)
xObs := space(30)
cLetra := cLet := space(2)
xData := CtoD("")

Use VAL_COMP 

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
      @  6,24 Say "CERTIFICADOS QUALIDADE VALVULAS"
      While xCOMPONENTE = space(10) .or. LastKey() = 27
            @  8,5  Say "Comp. :" 
            xCOMPONENTE := Menu( "VV" , 10 , 14 , 14 , 25 )
            @  8,13 Say xCOMPONENTE picture "@!" color "B/W+"
      End
      While xBit = space(10) .or. LastKey() = 27
            @  8,24 Say "í"
            xBit := Menu( "BV" , 10 , 26 , 14 , 35 )
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
      If xCOMPONENTE <> space(10) .and. xBit <> space(10) .and. ;
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
dbSelectArea("VAL_COMP")
dbGoTop()
// Inserir no vetor aFor todos COMPONENTEs dessa figura
aFor := {}
While .not. EOF()
      If RTRIM( VAL_COMP->COMPONENTE ) == RTRIM( xCOMPONENTE )
         Aadd(aFor, { VAL_COMP->COMPONENTE , VAL_COMP->BITOLA_VAL ,;
               VAL_COMP->MATERIAL , VAL_COMP->CORR_FORN , RecNo() } )
      EndIf
      dbSkip(1)
End
// Inseri no vetor aFor2 s¢ os componente-v lvulas com respectiva bitola
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
// Inseri no vetor aFor3 s¢ os componente-v lvulas com respectiva material
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
// Inseri no vetor aFor2 s¢ o componente-v lvula com respectiva corrida
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
   xCOMPONENTE:= VAL_COMP->COMPONENTE
   Aadd(aDados, xCOMPONENTE)
   xBit    := VAL_COMP->BITOLA_VAL
   Aadd(aDados, xBit)
   xMat    := VAL_COMP->MATERIAL
   Aadd(aDados, xMat)
   xCor    := VAL_COMP->CORR_FORN
   Aadd(aDados, xCor)
   xFor    := VAL_COMP->FORNECEDOR
   Aadd(aDados, xFor)
   xCO     := VAL_COMP->CO
   Aadd(aDados, xCO)
   xData   := VAL_COMP->DATACOMPRA
   Aadd(aDados, xData)
   xC      := VAL_COMP->C
   Aadd(aDados, xC)
   xSi     := VAL_COMP->SI
   Aadd(aDados, xSi)
   xMn     := VAL_COMP->MN
   Aadd(aDados, xMn)
   xP      := VAL_COMP->P
   Aadd(aDados, xP)
   xS      := VAL_COMP->S
   Aadd(aDados, xS)
   xCr     := VAL_COMP->CR
   Aadd(aDados, xCr)
   xNi     := VAL_COMP->NI
   Aadd(aDados, xNi)
   xMo     := VAL_COMP->MO
   Aadd(aDados, xMo)
   xCu     := VAL_COMP->CU
   Aadd(aDados, xCu)
   xV      := VAL_COMP->V
   Aadd(aDados, xV)
   xNb     := VAL_COMP->NB
   Aadd(aDados, xNb)
   xAl     := VAL_COMP->AL
   Aadd(aDados, xAl)
   xTi     := VAL_COMP->TI
   Aadd(aDados, xTi)
   xN2      := VAL_COMP->N2
   Aadd(aDados, xN2)
   xLIMESC := VAL_COMP->LIM_ESCO
   Aadd(aDados, xLIMESC)
   xLIMRES := VAL_COMP->LIM_RESIS
   Aadd(aDados, xLIMRES)
   xESTRI  := VAL_COMP->ESTRI
   Aadd(aDados, xESTRI)
   xALONG  := VAL_COMP->ALONGA
   Aadd(aDados, xALONG)
   xDur    := VAL_COMP->DUREZA
   Aadd(aDados, xDur)
   xObs    := VAL_COMP->OBS
   Aadd(aDados, xObs)
   cCor    := VAL_COMP->CORRIDA
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
   If xFor     <> VAL_COMP->FORNECEDOR .or. ;
      xCO      <> VAL_COMP->CO         .or. ;
      xData    <> VAL_COMP->DATACOMPRA .or. ;
      xC       <> VAL_COMP->C          .or. ;
      xSi      <> VAL_COMP->SI         .or. ;
      xMn      <> VAL_COMP->MN         .or. ;
      xP       <> VAL_COMP->P          .or. ;
      xS       <> VAL_COMP->S          .or. ;
      xCr      <> VAL_COMP->CR         .or. ;
      xNi      <> VAL_COMP->NI         .or. ;
      xMo      <> VAL_COMP->MO         .or. ;
      xCu      <> VAL_COMP->CU         .or. ;
      xV       <> VAL_COMP->V          .or. ;
      xNb      <> VAL_COMP->NB         .or. ;
      xAl      <> VAL_COMP->AL         .or. ;
      xTi      <> VAL_COMP->TI         .or. ;
      xN2       <> VAL_COMP->N2          .or. ;
      xLIMESC  <> VAL_COMP->LIM_ESCO   .or. ;
      xLIMRES  <> VAL_COMP->LIM_RESIS  .or. ;
      xESTRI   <> VAL_COMP->ESTRI      .or. ;
      xALONG   <> VAL_COMP->ALONGA     .or. ;
      xDur     <> VAL_COMP->DUREZA     .or. ;
      xObs     <> VAL_COMP->OBS

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
         VAL_COMP->COMPONENTE   := xCOMPONENTE
         Aadd(aDados, xCOMPONENTE)
         VAL_COMP->BITOLA_VAL:= xBit
         Aadd(aDados, xBit)
         VAL_COMP->MATERIAL   := xMat
         Aadd(aDados, xMat)
         VAL_COMP->CORR_FORN  := xCor
         Aadd(aDados, xCor)
         VAL_COMP->FORNECEDOR := xFor
         Aadd(aDados, xFor)
         VAL_COMP->CO         := xCO
         Aadd(aDados, xCO)
         VAL_COMP->DATACOMPRA := xData
         Aadd(aDados, xData)
         VAL_COMP->C          := xC
         Aadd(aDados, xC)
         VAL_COMP->SI         := xSi
         Aadd(aDados, xSi)
         VAL_COMP->MN         := xMn
         Aadd(aDados, xMn)
         VAL_COMP->P          := xP
         Aadd(aDados, xP)
         VAL_COMP->S          := xS
         Aadd(aDados, xS)
         VAL_COMP->CR         := xCr
         Aadd(aDados, xCr)
         VAL_COMP->NI         := xNi
         Aadd(aDados, xNi)
         VAL_COMP->MO         := xMo
         Aadd(aDados, xMo)
         VAL_COMP->CU         := xCu
         Aadd(aDados, xCu)
         VAL_COMP->V          := xV
         Aadd(aDados, xV)
         VAL_COMP->NB         := xNb
         Aadd(aDados, xNb)
         VAL_COMP->AL         := xAl
         Aadd(aDados, xAl)
         VAL_COMP->TI         := xTi
         Aadd(aDados, xTi)
         VAL_COMP->N2          := xN2
         Aadd(aDados, xN2)
         VAL_COMP->LIM_ESCO   := xLIMESC
         Aadd(aDados, xLIMESC)
         VAL_COMP->LIM_RESIS  := xLIMRES
         Aadd(aDados, xLIMRES)
         VAL_COMP->ESTRI      := xESTRI
         Aadd(aDados, xESTRI)
         VAL_COMP->ALONGA     := xALONG
         Aadd(aDados, xALONG)
         VAL_COMP->DUREZA     := xDur
         Aadd(aDados, xDur)
         VAL_COMP->OBS        := xObs
         Aadd(aDados, xObs)
         VAL_COMP->CORRIDA    := cCor
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
   @ 16,65 Say "W :" Get xN2  picture "99.999"
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
   cCor := xCor
   @ 22,5  Say "Corrida da Conesteel :" Get cCor picture "@!"
   Read
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
      dbSelectArea("VAL_COMP")
      dbAppend()
      aDados := aPecas := {}
      VAL_COMP->COMPONENTE   := xCOMPONENTE
      Aadd(aDados, xCOMPONENTE)
      VAL_COMP->BITOLA_VAL:= xBit
      Aadd(aDados, xBit)
      VAL_COMP->MATERIAL   := xMat
      Aadd(aDados, xMat)
      VAL_COMP->CORR_FORN  := xCor
      Aadd(aDados, xCor)
      VAL_COMP->FORNECEDOR := xFor
      Aadd(aDados, xFor)
      VAL_COMP->CO         := xCO
      Aadd(aDados, xCO)
      VAL_COMP->DATACOMPRA := xData
      Aadd(aDados, xData)
      VAL_COMP->C          := xC
      Aadd(aDados, xC)
      VAL_COMP->SI         := xSi
      Aadd(aDados, xSi)
      VAL_COMP->MN         := xMn
      Aadd(aDados, xMn)
      VAL_COMP->P          := xP
      Aadd(aDados, xP)
      VAL_COMP->S          := xS
      Aadd(aDados, xS)
      VAL_COMP->CR         := xCr
      Aadd(aDados, xCr)
      VAL_COMP->NI         := xNi
      Aadd(aDados, xNi)
      VAL_COMP->MO         := xMo
      Aadd(aDados, xMo)
      VAL_COMP->CU         := xCu
      Aadd(aDados, xCu)
      VAL_COMP->V          := xV
      Aadd(aDados, xV)
      VAL_COMP->NB         := xNb
      Aadd(aDados, xNb)
      VAL_COMP->AL         := xAl
      Aadd(aDados, xAl)
      VAL_COMP->TI         := xTi
      Aadd(aDados, xTi)
      VAL_COMP->N2          := xN2
      Aadd(aDados, xN2)
      VAL_COMP->LIM_ESCO   := xLIMESC
      Aadd(aDados, xLIMESC)
      VAL_COMP->LIM_RESIS  := xLIMRES
      Aadd(aDados, xLIMRES)
      VAL_COMP->ESTRI      := xESTRI
      Aadd(aDados, xESTRI)
      VAL_COMP->ALONGA     := xALONG
      Aadd(aDados, xALONG)
      VAL_COMP->DUREZA     := xDur
      Aadd(aDados, xDur)
      VAL_COMP->OBS        := xObs
      Aadd(aDados, xObs)
      VAL_COMP->CORRIDA    := cCor
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
   CQMP( aDados , "COMPONENTE" ) 
EndIf

End Sequence

Cls
Clear Typeahead
dbCloseAll()
Return



//  Lembrando:
//
//  aDados := { VAL_COMP->COMPONENTE , VAL_COMP->MATERIAL , VAL_COMP->CORR_FORN,
//              VAL_COMP->FORNECEDOR , VAL_COMP->CO , VAL_COMP->DATACOMPRA,
//              VAL_COMP->C , VAL_COMP->SI , VAL_COMP->MN , VAL_COMP->P ,
//              VAL_COMP->S , VAL_COMP->S , VAL_COMP->CR , VAL_COMP-> NI ,
//              VAL_COMP->MO , VAL_COMP->CU , VAL_COMP->V , VAL_COMP->NB ,
//              VAL_COMP->AL , VAL_COMP->TI , VAL_COMP->N2 , VAL_COMP->LIM_ESCO,
//              VAL_COMP->RESIS , VAL_COMP->ESTRI , VAL_COMP->ALONGA ,
//              VAL_COMP->DUREZA , VAL_COMP->OBS , VAL_COMP->CORRIDA }
//
//  aPecas := { BIT_LAM->FIGURA , BIT_LAM->BITOLA , BIT_LAM->MATERIAL ,;
//              BIT_LAM->CORRIDA, RecNo() } 
