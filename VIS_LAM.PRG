/***************************************************************************\
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                                VIS_LAM.PRG                                *
****************************************************************************/

Local nLin,aLam,nN,aLam2,cTela,nRec,cFig,cBit,aCor,aFig,cMat,nM,nTam,cCor
Local cCor2,aTab,aVaz,nOp,aLam3,cLetra,nNum,cLet,aMenu,aDisp,aDados,aPecas
Local xLam,xMat,xCor,xFor,xCO,xData,xC,xSi,xMn,xP,xS,xCr,xNi,xMo,xCu,xV
Local xNb,xAl,xTi,xW,xLIMESC,xLIMRES,xESTRI,xALONG,xDur,xObs
Local GetList := {}

nLin := nN := nTam := 1
aLam := aLam2 := aCor := aFig := aLam3 := {}
xLam := xMat := xCor := xCO := cFig := cBit := cMat:= cCor:= cCor2:= space(10)
xFor := space(15)
xDur := space(12)
xObs := space(30)
cLetra := cLet := space(2)
xData := CtoD("")
nRec := nM := nOp := 0
xC := xSi := xMn := xP := xS := xCr := xNi := xMo := xCu := xV := 0
xNb := xAl := xTi := xW := xLIMESC := xLIMRES := xESTRI := xALONG := 0

Use LAM_COMP 
Use BIT_LAM New 
Use LAMINADO New 

While .T.
      dbSelectArea("LAM_COMP")
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
      DispBox(5,4,23,75,2)
      @  6,5  CLEAR TO 22,74
      @  7,4  Say "Ì"
      @  7,5  Say Replicate("Í",70)
      @  7,75 Say "¹"
      @  6,24 Say "CERTIFICADOS QUALIDADE LAMINADOS"
      @  8,5  Say "Laminado :" Get xLam picture "@!" 
      @  8,31 Say "Material :" Get xMat picture "@!"
      @  8,55 Say "Corrida :" Get xCor picture "@!"
      Read
      dbGoTop()
      aLam := {}
      // Inserir no vetor aLam todos Laminados dessa bitola
      While .not. EOF()
            If RTRIM( CON_COMP->MP ) = RTRIM( xLam )
               Aadd(aLam, { CON_COMP->MP , LAM_COMP->MATERIAL ,;
                    LAM_COMP->CORR_FORN , RecNo() } )
            EndIf
            dbSkip(1)
      End
      // Inseri no vetor aLam2 s¢ so Laminados com respectiva material
      If Len( aLam ) <> 0
         nN := 1
         aLam2 := {}
         While nN <= Len( aLam )
               If RTRIM( aLam[nN][2] ) = RTRIM( xMat )
                  Aadd(aLam2, { aLam[nN][3] , aLam[nN][4] } )
               EndIf
               nN++
         End
         If Len( aLam2 ) <> 0
            nN := 1
            // Inseri no vetor aLam2 s¢ o Laminado com respectiva corrida
            While nN <= Len( aLam2 )
                  If RTRIM( aLam2[nN][1] ) = RTRIM( xCor )
                     // SE ENTRAR AQUI, ELE ACHOU O REGISTRO
                     nRec := aLam2[nN][2]
                     dbGoTo( nRec )
                     aDados := aPecas := {}
                     xLam    := CON_COMP->MP
                     Aadd(aDados, xLam)
                     xMat    := LAM_COMP->MATERIAL
                     Aadd(aDados, xMat)
                     xCor    := LAM_COMP->CORR_FORN
                     Aadd(aDados, xCor)
                     xFor    := LAM_COMP->FORNECEDOR
                     Aadd(aDados, xFor)
                     xCO     := LAM_COMP->CO
                     Aadd(aDados, xCO)
                     xData   := LAM_COMP->DATACOMPRA
                     Aadd(aDados, xData)
                     xC      := LAM_COMP->C
                     Aadd(aDados, xC)
                     xSi     := LAM_COMP->SI
                     Aadd(aDados, xSi)
                     xMn     := LAM_COMP->MN
                     Aadd(aDados, xMn)
                     xP      := LAM_COMP->P
                     Aadd(aDados, xP)
                     xS      := LAM_COMP->S
                     Aadd(aDados, xS)
                     xCr     := LAM_COMP->CR
                     Aadd(aDados, xCr)
                     xNi     := LAM_COMP->NI
                     Aadd(aDados, xNi)
                     xMo     := LAM_COMP->MO
                     Aadd(aDados, xMo)
                     xCu     := LAM_COMP->CU
                     Aadd(aDados, xCu)
                     xV      := LAM_COMP->V
                     Aadd(aDados, xV)
                     xNb     := LAM_COMP->NB
                     Aadd(aDados, xNb)
                     xAl     := LAM_COMP->AL
                     Aadd(aDados, xAl)
                     xTi     := LAM_COMP->TI
                     Aadd(aDados, xTi)
                     xW      := LAM_COMP->W
                     Aadd(aDados, xW)
                     xLIMESC := LAM_COMP->LIM_ESCO
                     Aadd(aDados, xLIMESC)
                     xLIMRES := LAM_COMP->LIM_RESIS
                     Aadd(aDados, xLIMRES)
                     xESTRI  := LAM_COMP->ESTRI
                     Aadd(aDados, xESTRI)
                     xALONG  := LAM_COMP->ALONGA
                     Aadd(aDados, xALONG)
                     xDur    := LAM_COMP->DUREZA
                     Aadd(aDados, xDur)
                     xObs    := LAM_COMP->OBS
                     Aadd(aDados, xObs)
                     @ 13,18 clear to 17,70
                     @ 10,5  Say "Data Compra:" Get xData
                     @ 10,29  Say "Fornecedor:" Get xFor picture "@!"
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
                     @ 16,65 Say "W :" Get xW  picture "99.999"
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
                     @ 22,5  Say "Dureza :" Get xDur picture "@!"
                     @ 22,31 Say "Observa‡oes :" Get xObs picture "@!"
                     Tone(500,2)
                     @ 24,15 Say "Tecla qualquer tecla para continuar..."
                     Inkey(00)
                     // Aqui mostra as pe‡as com o determinado laminado
                     DispBox(5,4,23,75,2)
                     @  6,5  CLEAR TO 22,74
                     @  7,4  Say "Ì"
                     @  7,5  Say Replicate("Í",70)
                     @  7,75 Say "¹"
                     @  6,18 Say "CERTIFICADO DE QUALIDADE DO LAMINADO: "+xLam
                     dbSelectArea("LAMINADO")
                     dbGoTop()
                     aLam := {}
                     While .not. EOF()
                           If RTRIM( xLam ) = RTRIM( LAMINADO->LAMINADO )
                              Aadd(aLam, { LAMINADO->FIGURA ,;
                                           LAMINADO->BITOLA ,;
                                           LAMINADO->MATERIAL ,;
                                           LAMINADO->CORRIDA ,;
                                           LAMINADO->CORRIDAFOR } )
                           EndIf
                           dbSkip(1)
                     End
                     aLam2 := {}
                     nN := 1
                     While nN <= Len( aLam )
                           If RTRIM( aLam[nN][3] ) = RTRIM( xMat )
                              Aadd(aLam2, { aLam[nN][1] ,;
                                            aLam[nN][2] ,;
                                            aLam[nN][3] ,;
                                            aLam[nN][4] ,;
                                            aLam[nN][5] } )
                           EndIf
                           nN++
                     End
                     aLam3 := {}
                     nN := 1
                     While nN <= Len( aLam2 )
                           If RTRIM( aLam2[nN][5] ) = RTRIM( xCor )
                              Aadd(aLam3, { aLam2[nN][1] ,;
                                            aLam2[nN][2] ,;
                                            aLam2[nN][3] ,;
                                            aLam2[nN][4] } )
                           EndIf
                           nN++
                     End
                     If Len(aLam3) = 0
                        @ 24,15 Say "Nao existe pe‡as com esse laminado !!!"
                        Tone(200,3)
                        inkey(00)
                     EndIf
                     nLin := 8
                     nN := 1
                     @ nLin,11 Say "Figura :" 
                     @ nLin,27 Say "Bitola :" 
                     @ nLin,46 Say "Material :"
                     @ nLin,60 Say "Corrida :"
                     nLin := 10
                     While nN <= Len( aLam3 )
                              cFig := aLam3[nN][1]
                              cBit := aLam3[nN][2]
                              cMat := aLam3[nN][3]
                              cCor := aLam3[nN][4]
                              @ nLin,11 Get cFig Picture "@!"
                              @ nLin,27 Get cBit Picture "@!"
                              @ nLin,46 Get cMat Picture "@!"
                              @ nLin,60 Get cCor Picture "@!"
                              nLin := nLin + 2
                              nN++
                     End
                     Tone(500,2)
                     @ 24,15 Say "Tecla qualquer tecla para continuar..."
                     Inkey(00)
                     aPecas := aLam3

                     // Aqui pergunta se deseja imprimir os dados

                     Tone(500,1) ; Tone(300,1) ; Tone(800,2)
                     Tela("R+/N,GR+/B",11,24,17,60) 
                     SetColor("R+/N,GR+/B")
                     @ 12,27 Say "Deseja imprimir esses dados ?"
                     @ 14,33 Prompt "Sim"
                     @ 14,46 Prompt "Nao"
                     SetColor("GR+/B,B/W+")
                     Menu to nN
                     If nN = 1
                        CQMP( aDados , "LAMINADO" )
                        Cls
                        Clear Typeahead
                        dbCloseAll()
                        Return
                     Else
                        Cls
                        Clear Typeahead
                        dbCloseAll()
                        Return
                     EndIf
                  EndIf
                  nN++
            End
         Else
            Tone(200,3)
            @ 24,15 Say "Nao existe esse laminado !!!"
            inkey(00)
            Exit
         EndIf
         Tone(200,3)
         @ 24,15 Say "Nao existe esse laminado !!!"
         inkey(00)
         Exit
      EndIf
End

Cls
Clear Typeahead
dbCloseAll()
Return
                     

//  Lembrando:
//
//  aDados := { CON_COMP->MP , LAM_COMP->MATERIAL , LAM_COMP->CORR_FORN,
//              LAM_COMP->FORNECEDOR , LAM_COMP->CO , LAM_COMP->DATACOMPRA,
//              LAM_COMP->C , LAM_COMP->SI , LAM_COMP->MN , LAM_COMP->P ,
//              LAM_COMP->S , LAM_COMP->S , LAM_COMP->CR , LAM_COMP-> NI ,
//              LAM_COMP->MO , LAM_COMP->CU , LAM_COMP->V , LAM_COMP->NB ,
//              LAM_COMP->AL , LAM_COMP->TI , LAM_COMP->W , LAM_COMP->LIM_ESCO,
//              LAM_COMP->RESIS , LAM_COMP->ESTRI , LAM_COMP->ALONGA ,
//              LAM_COMP->DUREZA , LAM_COMP->OBS }
//
//  aPecas := { BIT_LAM->FIGURA , BIT_LAM->BITOLA , BIT_LAM->MATERIAL ,;
//              BIT_LAM->CORRIDA, RecNo() } 
  
