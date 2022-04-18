/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                             CORRIDAS.PRG                                  *
****************************************************************************/

Local nMenu, cFig, cBit, cMat, cCorCon, nCC, aVet1, aVet2, aVet3, cMP, cBITMP
Local nN, aDisp, nOp, cTela, cTela2, nRec , aVet4 , lTeste , nMenu2, cCliente
Local cEmpresa , cCGC , aCliente , tAchou
Local GetList := {}

cFig := cMat := space(12)
cBit := space(10)
cCorCon := space(3)
nCC := nN := nRec := 0
aVet1 := aVet2 := aVet3 := {}

While .T. .or. LastKey() <> 27
      MontaTela()
      SetColor("GR+/B,B/W+")
      @  7 , 34 Say "MENU CORRIDAS"
      @ 10 , 25 Prompt " Procurar por Figura - Conexao " message "Procura todas corridas da respectiva figura"
      @ 11 , 25 Prompt "     Procurar por Laminado     " message "Procura todas corridas desse laminado"
      @ 12 , 25 Prompt "     Procurar por Forjado      " message "Procura todas corridas desse forjado"
      @ 14 , 25 Prompt "Procurar por Componente V lvula" message "Procura todas corridas desse componente"
      @ 15 , 25 Prompt " Procurar por Internos V lvula " message "Procura todas corridas desse interno"
      @ 20 , 25 Prompt "    Voltar ao Menu Diversos    " message "Voltar ao Menu Diversos"
      Menu To nMenu
      If nMenu = 1
         cFig := cMat := space(12)
         cBit := space(10)
         @  9,21 Clear To 21,60
         lTeste := .f.
         while LastKey() <> 27
               @ 10,29 Say "Figura  :" Get cFig picture "@!" valid cFig <> " "
               Read
               if Teste( "CX" , cFig ) .and. LastKey() <> 27
                  exit
               endif
               cFig := space(12)
         end
         @ 11,29 Say "Bitola  :"
         @ 12,29 Say "Material:"
         While cBit = space(10) .or. LastKey() <> 27
               cBit := Menu( "BC" , 12 , 40 , 16 , 46 )
               If LastKey() <> 27
                  @ 11,39 Say cBit picture "@!" color "B/W+"
                  exit
               else 
                  Return
               EndIf
         End
         While cMat = space(12)
               cMat := Menu( "MT" , 13 , 40 , 17 , 50 )
               If LastKey() <> 27
                  @ 12,39 Say cMat picture "@!" color "B/W+"
               Else 
                  Return
               End
         End

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

         Use CON_COMP 
         dbGoTop()
         aVet1 := {}
         While .not. EOF()
               If RTRIM( cMP ) == RTRIM( CON_COMP->MP )
                  Aadd( aVet1, { CON_COMP->BITOLA_MP, CON_COMP->MATERIAL, ;
                                 CON_COMP->CORRIDA , RecNo() ,;
                                 CON_COMP->CORR_FORN , CON_COMP->FORNECEDOR ,;
                                 CON_COMP->DATACOMPRA } )
               EndIf
               dbSkip()
         End
         nN := 1   
         aVet2 := {}
         While nN <= Len( aVet1 )
               If RTRIM( cBITMP ) == RTRIM( aVet1[nN][1] )
                  Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] ,;
                                aVet1[nN][5] , aVet1[nN][6] , aVet1[nN][7] } )
               EndIf
               nN++
         End
         nN := 1
         aVet3 := {}
         While nN <= Len( aVet2 )
               If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
                  Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] , aVet2[nN][4] ,;
                                aVet2[nN][5] , aVet2[nN][6] } )
               EndIf
               nN++
         End
         nN := 1
         aVet4 := {}
         While nN <= Len( aVet3 )
               Aadd( aVet4 , aVet3[nN][4] + " " + aVet3[nN][3] + " " + aVet3[nN][1] )
               nN++
         End
         nN := 1
         aDisp := {}
         While nN <= Len( aVet4 )
               Aadd( aDisp , .t. )
               nN++
         End
         If Len( aVet4 ) = 0
            NTC()
            Loop
         EndIf
         cTela := SaveScreen( 15 , 24 , 21 , 57 )
         SetColor("R+/N,GR+/B")
         @ 16,24 Clear To 21,57
         DispBox( 15 , 24 , 21 , 57 )
         nOp := Achoice ( 16 , 26 , 20 , 56 , aVet4, aDisp,'Auxiliar_da_Achoice')
         RestScreen( 15 , 24 , 21 , 57 )
         SetColor("GR+/B,B/W+")
         If nOp <> 0
            cCorCon := aVet3[nOp]
            nRec := aVet3[nOp][2]
            aVet3 := aDisp := aVet1 := aVet2 := {}
            dbGoTo( nRec )
            @  13,21 Clear To 21,60
            @ 14,29 Say "Mat‚ria-Prima:" Get CON_COMP->MP picture "@!"
            @ 15,29 Say "Bitola MP    :" Get CON_COMP->BITOLA_MP picture "@!"
            @ 16,29 Say "Fornecedor   :" Get CON_COMP->FORNECEDOR picture "@!"
            @ 17,29 Say "CQ Original  :" Get CON_COMP->CO picture "@!"
            @ 18,29 Say "Data Compra  :" Get CON_COMP->DATACOMPRA
            @ 19,29 Say "Corrida Cone.:" Get CON_COMP->CORRIDA picture "@!"
            @ 20,29 Say "Corrida Forn.:" Get CON_COMP->CORR_FORN picture "@!"
            getlist := {}
            Tone(300,2)
            @ 24,20 Say "Pressione qualquer tecla para continuar...          "
            Inkey(00)
         EndIf
      ElseIf nMenu = 2
         cFig := cMat := space(12)
         cBit := space(10)
         @  9,21 Clear To 21,60
         @ 10,29 Say "Laminado:"
         @ 11,29 Say "Bitola  :"
         @ 12,29 Say "Material:"
         While cFig = space(12)
               cFig := Menu( "LL" , 11 , 40 , 15 , 54 )
               If LastKey() <> 27
                  @ 10,39 Say cFig picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cBit = space(10)
               cBit := Menu( "BL" , 12 , 40 , 16 , 48 )
               If LastKey() <> 27
                  @ 11,39 Say cBit picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cMat = space(12)
               cMat := Menu( "MT" , 13 , 40 , 17 , 50 )
               If LastKey() <> 27
                  @ 12,39 Say cMat picture "@!" color "B/W+"
               Else
                  Return
               End
         End

         Use CON_COMP 
         dbGoTop()
         aVet1 := {}
         While .not. EOF()
               If RTRIM( cFig ) == RTRIM( CON_COMP->MP )
                  Aadd( aVet1, { CON_COMP->BITOLA_MP, CON_COMP->MATERIAL, ;
                                 CON_COMP->CORRIDA , RecNo() ,;
                                 CON_COMP->CORR_FORN , CON_COMP->FORNECEDOR ,;
                                 CON_COMP->DATACOMPRA } )
               EndIf
               dbSkip()
         End
         nN := 1   
         aVet2 := {}
         While nN <= Len( aVet1 )
               If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
                  Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] ,;
                                aVet1[nN][5] , aVet1[nN][6] , aVet1[nN][7] } )
               EndIf
               nN++
         End
         nN := 1
         aVet3 := {}
         While nN <= Len( aVet2 )
               If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
                  Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] , aVet2[nN][4] ,;
                                aVet2[nN][5] , aVet2[nN][6] } )
               EndIf
               nN++
         End
         nN := 1
         aVet4 := {}
         While nN <= Len( aVet3 )
               Aadd( aVet4 , aVet3[nN][4] + " " + aVet3[nN][3] + " " + aVet3[nN][1] )
               nN++
         End
         nN := 1
         aDisp := {}
         While nN <= Len( aVet4 )
               Aadd( aDisp , .t. )
               nN++
         End
         If Len( aVet4 ) = 0
            NTC()
            Loop
         EndIf
         cTela := SaveScreen( 15 , 24 , 21 , 57 )
         SetColor("R+/N,GR+/B")
         @ 16,24 Clear To 21,57
         DispBox( 15 , 24 , 21 , 57 )
         nOp := Achoice ( 16 , 26 , 20 , 56 , aVet4, aDisp,'Auxiliar_da_Achoice')
         RestScreen( 15 , 24 , 21 , 57 )
         SetColor("GR+/B,B/W+")
         If nOp <> 0
            cCorCon := aVet3[nOp]
            nRec := aVet3[nOp][2]
            aVet3 := aDisp := aVet1 := aVet2 := {}
            dbGoTo( nRec )
            @  13,21 Clear To 21,60
            @ 14,29 Say "Mat‚ria-Prima:" Get CON_COMP->MP picture "@!"
            @ 15,29 Say "Bitola MP    :" Get CON_COMP->BITOLA_MP picture "@!"
            @ 16,29 Say "Fornecedor   :" Get CON_COMP->FORNECEDOR picture "@!"
            @ 17,29 Say "CQ Original  :" Get CON_COMP->CO picture "@!"
            @ 18,29 Say "Data Compra  :" Get CON_COMP->DATACOMPRA
            @ 19,29 Say "Corrida Cone.:" Get CON_COMP->CORRIDA picture "@!"
            @ 20,29 Say "Corrida Forn.:" Get CON_COMP->CORR_FORN picture "@!"
            Tone(300,2)
            @ 24,20 Say "Pressione qualquer tecla para continuar...          "
            Inkey(00)
         EndIf
      ElseIf nMenu = 3
         cFig := cMat := space(12)
         cBit := space(10)
         @  9,21 Clear To 21,60
         @ 10,29 Say "Forjado :"
         @ 11,29 Say "Bitola  :"
         @ 12,29 Say "Material:"
         While cFig = space(12)
               cFig := Menu( "FF" , 11 , 40 , 15 , 48 )
               If LastKey() <> 27
                  @ 10,39 Say cFig picture "@!" color "B/W+"
               else
                  Return
               EndIf
         End
         While cBit = space(10)
               cBit := Menu( "BF" , 12 , 40 , 16 , 50 )
               If LastKey() <> 27
                  @ 11,39 Say cBit picture "@!" color "B/W+"
               else
                  Return
               EndIf
         End
         While cMat = space(12)
               cMat := Menu( "MT" , 13 , 40 , 17 , 50 )
               If LastKey() <> 27
                  @ 12,39 Say cMat picture "@!" color "B/W+"
               else
                  Return
               EndIf
         End

         Use CON_COMP 
         dbGoTop()
         aVet1 := {}
         While .not. EOF()
               If RTRIM( cFig ) == RTRIM( CON_COMP->MP )
                  Aadd( aVet1, { CON_COMP->BITOLA_MP, CON_COMP->MATERIAL, ;
                                 CON_COMP->CORRIDA , RecNo() ,;
                                 CON_COMP->CORR_FORN , CON_COMP->FORNECEDOR ,;
                                 CON_COMP->DATACOMPRA } )
               EndIf
               dbSkip()
         End
         nN := 1   
         aVet2 := {}
         While nN <= Len( aVet1 )
               If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
                  Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] ,;
                                aVet1[nN][5] , aVet1[nN][6] , aVet1[nN][7] } )
               EndIf
               nN++
         End
         nN := 1
         aVet3 := {}
         While nN <= Len( aVet2 )
               If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
                  Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] , aVet2[nN][4] ,;
                                aVet2[nN][5] , aVet2[nN][6] } )
               EndIf
               nN++
         End
         nN := 1
         aVet4 := {}
         While nN <= Len( aVet3 )
               Aadd( aVet4 , aVet3[nN][4] + " " + aVet3[nN][3] + " " + aVet3[nN][1] )
               nN++
         End
         nN := 1
         aDisp := {}
         While nN <= Len( aVet4 )
               Aadd( aDisp , .t. )
               nN++
         End
         If Len( aVet4 ) = 0
            NTC()
            Loop
         EndIf
         cTela := SaveScreen( 15 , 24 , 21 , 57 )
         SetColor("R+/N,GR+/B")
         @ 16,24 Clear To 21,57
         DispBox( 15 , 24 , 21 , 57 )
         nOp := Achoice ( 16 , 26 , 20 , 56 , aVet4, aDisp,'Auxiliar_da_Achoice')
         RestScreen( 15 , 24 , 21 , 57 )
         SetColor("GR+/B,B/W+")
         If nOp <> 0
            cCorCon := aVet3[nOp]
            nRec := aVet3[nOp][2]
            aVet3 := aDisp := aVet1 := aVet2 := {}
            dbGoTo( nRec )
            @  13,21 Clear To 21,60
            @ 14,29 Say "Mat‚ria-Prima:" Get CON_COMP->MP picture "@!"
            @ 15,29 Say "Bitola MP    :" Get CON_COMP->BITOLA_MP picture "@!"
            @ 16,29 Say "Fornecedor   :" Get CON_COMP->FORNECEDOR picture "@!"
            @ 17,29 Say "CQ Original  :" Get CON_COMP->CO picture "@!"
            @ 18,29 Say "Data Compra  :" Get CON_COMP->DATACOMPRA
            @ 19,29 Say "Corrida Cone.:" Get CON_COMP->CORRIDA picture "@!"
            @ 20,29 Say "Corrida Forn.:" Get CON_COMP->CORR_FORN picture "@!"
            Tone(300,2)
            @ 24,20 Say "Pressione qualquer tecla para continuar...          "
            Inkey(00)
         EndIf
      ElseIf nMenu = 4
         cFig := cMat := space(12)
         cBit := space(10)
         @  9,21 Clear To 21,60
         @ 10,29 Say "Comp.Val:"
         @ 11,29 Say "Bitola  :"
         @ 12,29 Say "Material:"
         While cFig = space(12)
               cFig := Menu( "VV" , 11 , 40 , 15 , 53 )
               If LastKey() <> 27
                  @ 10,39 Say cFig picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cBit = space(10)
               cBit := Menu( "BV" , 12 , 40 , 16 , 50 )
               If LastKey() <> 27
                  @ 11,39 Say cBit picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cMat = space(12)
               cMat := Menu( "MT" , 13 , 40 , 17 , 50 )
               If LastKey() <> 27
                  @ 12,39 Say cMat picture "@!" color "B/W+"
               Else
                  Return
               End
         End

         Use VAL_COMP 
         dbGoTop()
         aVet1 := {}
         While .not. EOF()
               If RTRIM( cFig ) == RTRIM( VAL_COMP->COMPONENTE )
                  Aadd( aVet1, { VAL_COMP->BITOLA_VAL, VAL_COMP->MATERIAL, ;
                                 VAL_COMP->CORRIDA , RecNo() ,;
                                 VAL_COMP->CORR_FORN , VAL_COMP->FORNECEDOR ,;
                                 VAL_COMP->DATACOMPRA } )
               EndIf
               dbSkip()
         End
         nN := 1   
         aVet2 := {}
         While nN <= Len( aVet1 )
               If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
                  Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] ,;
                                aVet1[nN][5] , aVet1[nN][6] , aVet1[nN][7] } )
               EndIf
               nN++
         End
         nN := 1
         aVet3 := {}
         While nN <= Len( aVet2 )
               If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
                  Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] , aVet2[nN][4] ,;
                                aVet2[nN][5] , aVet2[nN][6] } )
               EndIf
               nN++
         End
         nN := 1
         aVet4 := {}
         While nN <= Len( aVet3 )
               Aadd( aVet4 , aVet3[nN][4] + " " + aVet3[nN][3] + " " + aVet3[nN][1] )
               nN++
         End
         nN := 1
         aDisp := {}
         While nN <= Len( aVet4 )
               Aadd( aDisp , .t. )
               nN++
         End
         If Len( aVet4 ) = 0
            NTC()
            Loop
         EndIf
         cTela := SaveScreen( 15 , 24 , 21 , 57 )
         SetColor("R+/N,GR+/B")
         @ 16,24 Clear To 21,57
         DispBox( 15 , 24 , 21 , 57 )
         nOp := Achoice ( 16 , 26 , 20 , 56 , aVet4, aDisp,'Auxiliar_da_Achoice')
         RestScreen( 15 , 24 , 21 , 57 )
         SetColor("GR+/B,B/W+")
         If nOp <> 0
            cCorCon := aVet3[nOp]
            nRec := aVet3[nOp][2]
            aVet3 := aDisp := aVet1 := aVet2 := {}
            dbGoTo( nRec )
            @  13,21 Clear To 21,60
            @ 14,29 Say "Mat‚ria-Prima:" Get VAL_COMP->COMPONENTE picture "@!"
            @ 15,29 Say "Bitola MP    :" Get VAL_COMP->BITOLA_VAL picture "@!"
            @ 16,29 Say "Fornecedor   :" Get VAL_COMP->FORNECEDOR picture "@!"
            @ 17,29 Say "CQ Original  :" Get VAL_COMP->CO picture "@!"
            @ 18,29 Say "Data Compra  :" Get VAL_COMP->DATACOMPRA
            @ 19,29 Say "Corrida Cone.:" Get VAL_COMP->CORRIDA picture "@!"
            @ 20,29 Say "Corrida Forn.:" Get VAL_COMP->CORR_FORN picture "@!"
            Tone(300,2)
            @ 24,20 Say "Pressione qualquer tecla para continuar...          "
            Inkey(00)
         EndIf
      ElseIf nMenu = 5
         cFig := cMat := space(12)
         cBit := space(10)
         @  9,21 Clear To 21,60
         @ 10,29 Say "Internos:"
         @ 11,29 Say "Bitola  :"
         @ 12,29 Say "Material:"
         While cFig = space(12)
               cFig := Menu( "IT" , 11 , 40 , 15 , 50 )
               If LastKey() <> 27
                  @ 10,39 Say cFig picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cBit = space(10)
               cBit := Menu( "IB" , 12 , 40 , 16 , 46 )
               If LastKey() <> 27
                  @ 11,39 Say cBit picture "@!" color "B/W+"
               Else
                  Return
               End
         End
         While cMat = space(12)
               cMat := Menu( "MT" , 13 , 40 , 17 , 50 )
               If LastKey() <> 27
                  @ 12,39 Say cMat picture "@!" color "B/W+"
               Else
                  Return
               End
         End

         Use VAL_COMP 
         dbGoTop()
         aVet1 := {}
         While .not. EOF()
               If RTRIM( cFig ) == RTRIM( VAL_COMP->COMPONENTE )
                  Aadd( aVet1, { VAL_COMP->BITOLA_VAL, VAL_COMP->MATERIAL, ;
                                 VAL_COMP->CORRIDA , RecNo() ,;
                                 VAL_COMP->CORR_FORN , VAL_COMP->FORNECEDOR ,;
                                 VAL_COMP->DATACOMPRA } )
               EndIf
               dbSkip()
         End
         nN := 1   
         aVet2 := {}
         While nN <= Len( aVet1 )
               If RTRIM( cBit ) == RTRIM( aVet1[nN][1] )
                  Aadd(aVet2, { aVet1[nN][2] , aVet1[nN][3] , aVet1[nN][4] ,;
                                aVet1[nN][5] , aVet1[nN][6] , aVet1[nN][7] } )
               EndIf
               nN++
         End
         nN := 1
         aVet3 := {}
         While nN <= Len( aVet2 )
               If RTRIM( cMat ) == RTRIM( aVet2[nN][1] )
                  Aadd(aVet3, { aVet2[nN][2] , aVet2[nN][3] , aVet2[nN][4] ,;
                                aVet2[nN][5] , aVet2[nN][6] } )
               EndIf
               nN++
         End
         nN := 1
         aVet4 := {}
         While nN <= Len( aVet3 )
               Aadd( aVet4 , aVet3[nN][4] + " " + aVet3[nN][3] + " " + aVet3[nN][1] )
               nN++
         End
         nN := 1
         aDisp := {}
         While nN <= Len( aVet4 )
               Aadd( aDisp , .t. )
               nN++
         End
         If Len( aVet4 ) = 0
            NTC()
            Loop
         EndIf
         cTela := SaveScreen( 15 , 24 , 21 , 57 )
         SetColor("R+/N,GR+/B")
         @ 16,24 Clear To 21,57
         DispBox( 15 , 24 , 21 , 57 )
         nOp := Achoice ( 16 , 26 , 20 , 56 , aVet4, aDisp,'Auxiliar_da_Achoice')
         RestScreen( 15 , 24 , 21 , 57 )
         SetColor("GR+/B,B/W+")
         If nOp <> 0
            cCorCon := aVet3[nOp]
            nRec := aVet3[nOp][2]
            aVet3 := aDisp := aVet1 := aVet2 := {}
            dbGoTo( nRec )
            @  13,21 Clear To 21,60
            @ 14,29 Say "Mat‚ria-Prima:" Get VAL_COMP->COMPONENTE picture "@!"
            @ 15,29 Say "Bitola MP    :" Get VAL_COMP->BITOLA_VAL picture "@!"
            @ 16,29 Say "Fornecedor   :" Get VAL_COMP->FORNECEDOR picture "@!"
            @ 17,29 Say "CQ Original  :" Get VAL_COMP->CO picture "@!"
            @ 18,29 Say "Data Compra  :" Get VAL_COMP->DATACOMPRA
            @ 19,29 Say "Corrida Cone.:" Get VAL_COMP->CORRIDA picture "@!"
            @ 20,29 Say "Corrida Forn.:" Get VAL_COMP->CORR_FORN picture "@!"
            Tone(300,2)
            @ 24,20 Say "Pressione qualquer tecla para continuar...          "
            Inkey(00)
         EndIf



         Loop
      Else      
        Exit
      EndIf

End


Return



**************
function NTC()
**************
Tone(200,3)
Tela("R+/N,GR+/B",11,24,17,60) 
SetColor("R+/N,GR+/B")
@ 12,27 Say "Nao existe numero de corrida !"
@ 14,39 Say "Ok" color "GR+/B"
inkey(00)
return NIL
