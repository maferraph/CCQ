/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur°cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de Aáo Ltda.                        *
*                             CQ_CONEX.PRG                                  *
****************************************************************************/

/****************************************************************************
aCQC := { { cCQ , cCliApelido , cEmpresa , cCGC , dData , nNF , cPedido } , ;
      |   { 1 , nQt1 , cFig1 , cDesc1 , cCla1 , cExt1 , cBit1 , cMat1 , ;
   12 |     cObs1 , cC1 , cSI1 , cMN1 , cP1 , cS1 , cCR1 , cNI1 , cMO1 ,;
  X's |     cCU1 , cV1 , cNB1 , cAL1 , cTI1 , cN21 , cLE1 , cLR1 , cEst1,;
      |     cAlong1 , cDur1 , cCorCon1 , cCorFor1 , cCerFor1 } }
****************************************************************************/

Local nLin, cCQ, cCliApelido, cEmpresa, cCGC, cPedido, nNF , cEmp1 , cEmp2
Local dData, nCQ , aCQC, nOp , nLI , nLF, cItem, cFig , cBit, cMat, xBit, nN
Local nQuant, cCorCon, aVet , nMenu , cTela, nI , nJ, lTeste, nO, cPecas, aV1
Local nRec , cTipo , aUNIAO , cA , cB , cC , nItem , cBitTeste , xN
Local GetList := {}

cCQ := space(10)
cCliApelido := space(12)
cCGC := space(18)
cPedido := space(15)
cEmpresa := space(60)
nLin := nNF := nQuant := nMenu := 0
dData := CtoD("")
aVet := {}

cFig := space(10)
cBit := xBit := space(16)
cMat := space(10)
cCorCon := space(5)

Use CQ 
Use FORNE New 

While .T. .and. LastKey() <> 27
      MontaTelaGrande()
      @  6,24 Say "CERTIFICADOS QUALIDADE CONEXÂES"
      dbSelectArea("CQ")
      dbGoBottom()
      nCQ := CQ->NUMERO
      cCQ := transform( nCQ + 1 , "99999" ) + "/" + transform( Year(Date()) , "9999")
      @  8,8  Say "Certificado de Qualidade nß :" Get cCQ
      dData := Date()
      @  8,50 Say "Data :" Get dData
      Read

      If LastKey() = 27
         exit
      EndIf

      @ 10,8  Say "Cliente :" 
      While cCliApelido = space(12) .or. LastKey() = 27
            cCliApelido := Menu( "CL" , 11 , 18 , 16 , 31 )
      End
      @ 10,8  Say "Cliente :" Get cCliApelido
      dbSelectArea("FORNE")
      dbGoTop()
      While .not. EOF() .and. LastKey() <> 27
            If RTRIM( FORNE->CLIENTE ) = RTRIM(cCliApelido)
               cEmpresa := FORNE->EMPRESA
               exit
            EndIf
            dbSkip(1)
      End
      @ 12,8  Say "Raz∆o Social :"
      @ 14,8  Get cEmpresa
      cCGC := FORNE->CGC
      @ 16,8  Say "C.G.C. (M.F.) :" Get cCGC 
      @ 18,8  Say "N£mero do Pedido :" Get cPedido
      @ 20,8  Say "N£mero da Nota Fiscal :" Get nNF valid nNF <> 0
      Read
      aCQC := {}
      Aadd(aCQC , {cCQ ,cCliApelido ,cEmpresa ,cCGC ,dData ,nNF ,cPedido } )

      DispBox(5,4,23,75,2)
      @  6,5  CLEAR TO 22,74
      @  7,4  Say "Ã"
      @  7,5  Say Replicate("Õ",70)
      @  7,75 Say "π"
      @  6,6  Say "Item"
      @  6,11  Say "Quant"
      @  6,17  Say "Figura"
      @  6,28  Say "Bitola"
      @  6,45  Say "Material"
      @  6,57  Say "Corrida Conesteel"

      nOp := 1
      nItem := 1
      While nOp <= 12 .and. LastKey() <> 27
            If nOp = 1
               nLin := 8 ; nLI := 9 ; nLF := 13 
            ElseIf nOp = 2
               nLin := 9 ; nLI := 10 ; nLF := 14
            ElseIf nOp = 3
               nLin := 10 ; nLI := 11 ; nLF := 15
            ElseIf nOp = 4
               nLin := 11 ; nLI := 12 ; nLF := 15
            ElseIf nOp = 5
               nLin := 12 ; nLI := 13 ; nLF := 16
            ElseIf nOp = 6
               nLin := 13 ; nLI := 14 ; nLF := 17
            ElseIf nOp = 7
               nLin := 14 ; nLI := 15 ; nLF := 18
            ElseIf nOp = 8
               nLin := 15 ; nLI := 16 ; nLF := 19
            ElseIf nOp = 9
               nLin := 16 ; nLI := 17 ; nLF := 20
            ElseIf nOp = 10
               nLin := 17 ; nLI := 18 ; nLF := 21
            ElseIf nOp = 11
               nLin := 18 ; nLI := 19 ; nLF := 22
            ElseIf nOp = 12
               nLin := 19 ; nLI := 20 ; nLF := 23
            EndIf

            If nItem = 1
               cItem := "01"
            ElseIf nItem = 2
               cItem := "02"
            ElseIf nItem = 3
               cItem := "03"
            ElseIf nItem = 4
               cItem := "04"
            ElseIf nItem = 5
               cItem := "05"
            ElseIf nItem = 6
               cItem := "06"
            ElseIf nItem = 7
               cItem := "07"
            ElseIf nItem = 8
               cItem := "08"
            ElseIf nItem = 9
               cItem := "09"
            ElseIf nItem = 10
               cItem := "10"
            ElseIf nItem = 11
               cItem := "11"
            ElseIf nItem = 12
               cItem := "12"
            EndIf
                 
            @  nLin,7  Say cItem
            @  nLin,11 Get nQuant picture "@9 99999"
            Read
            If nQuant <> 0
               While .T.
                     lTeste := .f.
                     While lTeste = .f.
                           @ nLin,17 Get cFig picture "@!" valid cFig <> space(10)
                           Read
                           lTeste := Teste( "CX" , cFig )
                     End
                     lTeste := .f.
                     While lTeste = .f.
                           @ nLin,28 Get xBit picture "@!" valid xBit <> space(16)
                           Read
                           lTeste := Teste( "BC" , xBit )
                     End
                     lTeste := .f.
                     While lTeste = .f.
                           @ nLin,45 Get cMat picture "@!" valid cMat <> space(10)
                           Read
                           lTeste := Teste( "MT" , cMat )
                     End
                     exit
               End

               nN := AT( "X" , xBit )
               If nN = 0
                  cBit := RTRIM( xBit )
               Else
                  nN--
                  cBit := SUBSTR( xBit , 1 , nN )
               EndIf

               If nOp > 9 .and. RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "17" .or. ;
                  nOp > 9 .and. RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "18" .or. ;
                  nOp > 9 .and. RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "19" 
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "Nao Ç poss°vel incluir Uni‰es !!!" color "R+*/N"
                  @ 12,25 Say "Faáa outro C.Q. para essas uni‰es"
                  @ 13,25 Say "  pois n∆o h† espaáo nesse CQ.   "
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3)
                  Tone(10,0.5)
                  Tone(200,3)
                  Tone(10,0.5)
                  Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
                  Loop
               EndIf

               // Se for CQ de Uniao
               If RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "17" .or. ;
                  RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "18" .or. ;
                  RTRIM( SUBSTR( cFig , 1 , 2 ) ) = "19"
                  Use UNIAO 
                  dbGoTop()
                  aVet := {}
                  While .not. EOF()
                        If RTRIM( UNIAO->FIGURA ) = RTRIM( cFig )
                           Aadd( aVet , { UNIAO->BITOLA , RecNo() } )
                        EndIf
                        dbSkip( 1 )
                  End
                  nN := 1
                  While nN <= Len( aVet )
                        If RTRIM( aVet[nN][1] ) = RTRIM( cBit )
                           nRec := aVet[nN][2]
                        EndIf
                        nN++
                  End
                  dbGoTo( nRec )
                  aUNIAO := {}
                  aUNIAO := { { cItem , nQuant , cFig , UNIAO->DESCRICAO , ;
                              UNIAO->CLASSE , UNIAO->EXTRE , xBit , cMat } , ;
                            { cItem + "A" , UNIAO->MP_PM , UNIAO->BIT_PM , ;
                              UNIAO->PM , cMat } , ;
                            { cItem + "B" , UNIAO->MP_PF , UNIAO->BIT_PF , ;
                              UNIAO->PF , cMat } , ;
                            { cItem + "C" , UNIAO->MP_PC , UNIAO->BIT_PC , ;
                              UNIAO->PC, cMat } }

                  aVet := { aUNIAO[1][1] , aUNIAO[1][2] , aUNIAO[1][3] , ;
                            aUNIAO[1][4] , aUNIAO[1][5] , aUNIAO[1][6] , ;
                            aUNIAO[1][7] , "" , "" , 0 , 0 , 0 , ;
                            0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , ;
                            0 , 0 , 0 , 0 , "" , "" , "" }
                  Aadd(aCQC , aVet )

                  nN := 2
                  nOp++
                  While nN <= 4
                        nLin++ ; nLI++ ; nLF++ ; nOp++
                        @ nLin,7  Say aUNIAO[nN][1]
                        @ nLin,11 Say "1 pá."
                        cA := RTRIM( aUNIAO[nN][2] )
                        cB := RTRIM( aUNIAO[nN][3] )
                        cC := RTRIM( aUNIAO[nN][5] ) 
                        @ nLin,17 Get cA
                        @ nLin,28 Get cB
                        @ nLin,45 Get cC
                        Read
                        If nN = 2
                           cTipo := "17-BT-PM"
                        ElseIf nN = 3
                           cTipo := "17-BT-PF"
                        Else
                           cTipo := "17-BT-PC"
                        EndIf
                        cCorCon := CorridaUniao( cFig , cBit , cMat , nLI , ;
                                                 63 , nLF , 68 , cTipo )

                        If cCorCon = "vazio"
                           cTela := SaveScreen( 10 , 23 , 18 , 61 )
                           Tela("R+/N,GR+/B",11,24,17,60)
                           SetColor("R+/N,GR+/B")
                           @ 11,25 Say " Nao existe numero de corrida !! " color "R+*/N"
                           @ 12,25 Say "Verifique se existe MatÇria-Prima"
                           @ 13,25 Say " no Banco de Dados de conexoes.  "
                           @ 15,39 Say "Ok" color "GR+/B"
                           Tone(200,3)
                           Tone(10,0.5)
                           Tone(200,3)
                           Tone(10,0.5)
                           Tone(200,3)
                           Inkey(00)
                           RestScreen( 10 , 23 , 18 , 61 , cTela )
                           SetColor("GR+/B,B/W+")
                           Loop
                        EndIf

                        aVet := {}
                        aVet := ProcuraCQUniao( cFig , cBit , cMat , cCorCon , cTipo )
                        aVet[1][1 ] := aUNIAO[nN][1]
                        aVet[1][2 ] := 0
                        aVet[1][4 ] := aUNIAO[nN][4]
                        aVet[1][29] := cCorCon
                        Aadd(aCQC , aVet[1] )
                        @  nLin,61 Get cCorCon picture "@!"
                        Read
                        nN++
                  End
                  nQuant := 0 ; cFig := space(10) ; cBit := space(16)
                  cMat := space(10) ; cCorCon := space(5)
                  nItem++
                  Loop
               EndIf

               xN := AT( CHR(34) , cBit )
               cBitTeste := LEFT( cBit , xN )
               cCorCon := Corrida( cFig , cBitTeste , cMat , nLI , 63 , nLF , 68 )

               If cCorCon = "vazio"
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say " Nao existe numero de corrida !! " color "R+*/N"
                  @ 12,25 Say "Verifique se existe MatÇria-Prima"
                  @ 13,25 Say " no Banco de Dados de conexoes.  "
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3)
                  Tone(10,0.5)
                  Tone(200,3)
                  Tone(10,0.5)
                  Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
                  nQuant := 0
                  cFig := space(10)
                  cBit := space(16)
                  cMat := space(10)
                  Loop
               EndIf

               aVet := {}
               aVet := ProcuraCQ( cFig , cBitTeste , cMat , cCorCon )

               aVet[1][1] := cItem
               aVet[1][2] := nQuant
               aVet[1][7] := xBit
               aVet[1][29] := cCorCon
               Aadd(aCQC , aVet[1] )
               @  nLin,61 Get cCorCon picture "@!"
               Read
            EndIf
            If cFig = space(10) .and. cBit = space(16) .and. cMat = space(10)
               cCorCon := space(5)
               aVet := { cItem , 0 , "" , "" , "" , "" , "" , "" , "" , ;
                         0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , ;
                         0 , 0 , 0 , 0 , 0 , "" , cCorCon , "" , "" }
               Aadd(aCQC , aVet )
            EndIf
            nQuant := 0 ; cFig := space(10) ; cBit := space(16)
            cMat := space(10) ; cCorCon := space(5)
            nItem++
            nOp++
      End

      If LastKey() = 27
         exit
      EndIf

      Tone(500,1) ; Tone(300,1) ; Tone(800,2)
      cTela := SaveScreen( 10 , 22 , 18 , 62 )
      Tela("R+/N,GR+/B",11,23,17,61) 
      SetColor("R+/N,GR+/B")
      @ 12,24 Say "Certificado de Qualidade Pronto !!!"
      @ 13,28 Say "Deseja salvar esses dados ?"
      @ 15,33 Prompt "Sim"
      @ 15,46 Prompt "Nao"
      SetColor("GR+/B,B/W+")
      Menu To nMenu
      If nMenu = 1
         RestScreen( 10 , 22 , 18 , 62 , cTela )
         Use CQ 
         dbGoBottom()
         nCQ := CQ->NUMERO + 1
         dbAppend()
         CQ->TIPO    := "C"
         CQ->NUMERO  := nCQ
         CQ->CERQUA  := aCQC[1][1]
         CQ->CLIENTE := aCQC[1][2]
         CQ->DATA    := aCQC[1][5]
         CQ->NF      := aCQC[1][6]
         CQ->PEDIDO  := aCQC[1][7]

         CQ->QUANT1 := aCQC[2][2]
         CQ->FIG1   := aCQC[2][3]
         CQ->BIT1   := aCQC[2][7]
         CQ->MAT1   := aCQC[2][8]
         CQ->CC1    := aCQC[2][29]
         CQ->CF1    := aCQC[2][30]
         If aCQC[3][2] <> 0
            CQ->QUANT2 := aCQC[3][2]
         EndIf
         CQ->FIG2   := aCQC[3][3]
         CQ->BIT2   := aCQC[3][7]
         CQ->MAT2   := aCQC[3][8]
         CQ->CC2    := aCQC[3][29]
         CQ->CF2    := aCQC[3][30]
         If aCQC[4][2] <> 0
            CQ->QUANT3 := aCQC[4][2]
         EndIf
         CQ->FIG3   := aCQC[4][3]
         CQ->BIT3   := aCQC[4][7]
         CQ->MAT3   := aCQC[4][8]
         CQ->CC3    := aCQC[4][29]
         CQ->CF3    := aCQC[4][30]
         If aCQC[5][2] <> 0
            CQ->QUANT4 := aCQC[5][2]
         EndIf
         CQ->FIG4   := aCQC[5][3]
         CQ->BIT4   := aCQC[5][7]
         CQ->MAT4   := aCQC[5][8]
         CQ->CC4    := aCQC[5][29]
         CQ->CF4    := aCQC[5][30]
         If aCQC[6][2] <> 0
            CQ->QUANT5 := aCQC[6][2]
         EndIf
         CQ->FIG5   := aCQC[6][3]
         CQ->BIT5   := aCQC[6][7]
         CQ->MAT5   := aCQC[6][8]
         CQ->CC5    := aCQC[6][29]
         CQ->CF5    := aCQC[6][30]
         If aCQC[7][2] <> 0
            CQ->QUANT6 := aCQC[7][2]
         EndIf
         CQ->FIG6   := aCQC[7][3]
         CQ->BIT6   := aCQC[7][7]
         CQ->MAT6   := aCQC[7][8]
         CQ->CC6    := aCQC[7][29]
         CQ->CF6    := aCQC[7][30]
         If aCQC[8][2] <> 0
            CQ->QUANT7 := aCQC[8][2]
         EndIf
         CQ->FIG7   := aCQC[8][3]
         CQ->BIT7   := aCQC[8][7]
         CQ->MAT7   := aCQC[8][8]
         CQ->CC7    := aCQC[8][29]
         CQ->CF7    := aCQC[8][30]
         If aCQC[9][2] <> 0
            CQ->QUANT8 := aCQC[9][2]
         EndIf
         CQ->FIG8   := aCQC[9][3]
         CQ->BIT8   := aCQC[9][7]
         CQ->MAT8   := aCQC[9][8]
         CQ->CC8    := aCQC[9][29]
         CQ->CF8    := aCQC[9][30]
         If aCQC[10][2] <> 0
            CQ->QUANT9 := aCQC[10][2]
         EndIf
         CQ->FIG9   := aCQC[10][3]
         CQ->BIT9   := aCQC[10][7]
         CQ->MAT9   := aCQC[10][8]
         CQ->CC9    := aCQC[10][29]
         CQ->CF9    := aCQC[10][30]
         If aCQC[11][2] <> 0
            CQ->QUANT10:= aCQC[11][2]
         EndIf
         CQ->FIG10  := aCQC[11][3]
         CQ->BIT10  := aCQC[11][7]
         CQ->MAT10  := aCQC[11][8]
         CQ->CC10   := aCQC[11][29]
         CQ->CF10   := aCQC[11][30]
         If aCQC[12][2] <> 0
            CQ->QUANT11:= aCQC[12][2]
         EndIf
         CQ->FIG11  := aCQC[12][3]
         CQ->BIT11  := aCQC[12][7]
         CQ->MAT11  := aCQC[12][8]
         CQ->CC11   := aCQC[12][29]
         CQ->CF11   := aCQC[12][30]
         If aCQC[13][2] <> 0
            CQ->QUANT12:= aCQC[13][2]
         EndIf
         CQ->FIG12  := aCQC[13][3]
         CQ->BIT12  := aCQC[13][7]
         CQ->MAT12  := aCQC[13][8]
         CQ->CC12   := aCQC[13][29]
         CQ->CF12   := aCQC[13][30]
         Exit
      Else
         Exit
      EndIf
End



While .T. .and. LastKey() <> 27
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
      Else
         Exit
      EndIf

      // AQUI ê O RELAT‡RIO DO CERTIFICADO.




      CQCON( aCQC )
      exit
End

If LastKey() = 27
   Cls
   Clear Typeahead
   dbCloseAll()
   Return
EndIf

Cls
Clear Typeahead
dbCloseAll()
Return
