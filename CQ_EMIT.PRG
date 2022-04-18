/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur°cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de Aáo Ltda.                        *
*                              CQ_EMIT.PRG                                  *
****************************************************************************/
                            
Local nMenu , nCQ , nNF , dData , cCliApelido , cTipo , nRec , nLin, cUniao
Local cCQ , cCliente , cPedido , aPecas , nN , nOp , aCQC , aVet , nO , nJ
Local lTeste , cCorCon , cItem , cMat , cPecas , cEmpresa , cCGC, cNome, cFig
Local cCorrCorpo , cCorrCastelo , cCorrPreme , cCorrTampa , cCorrFlange
Local cCorrAnel , cCorrSede , cCorrHTGAV , cCorrHTGLOBO, cCorrPistao, cMaterial
Local aVet1 , aVet2, cCorrCunha , cCorrContraSede , cVar, cBit, nQuant, nI,a
Local GetList := {}

dData := CtoD("")
nCQ := nMenu := nNF := nRec := 0
cCliente := space(12)
cCQ := space(10)
cPedido := space(15)
cTipo := space(1)
aPecas := aCQC := aVet := {}

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @  7,25 Say "CERTIFICADOS QUALIDADE EMITIDOS"
      @ 10,22 Prompt "       Certificados por N£meros       " message "Procura pelo n£mero do CQ"
      @ 12,22 Prompt "Certificados por N£mero da Nota Fiscal" message "Procura pelo n£mero da NF da Conesteel"
      @ 14,22 Prompt "        Certificados por Data         " message "Procura pela data do CQ"
      @ 16,22 Prompt "       Certificados por Cliente       " message "Procura pelo nome do cliente do CQ"
      @ 18,22 Prompt "        Certificados por Tipo         " message "Procura CQ por tipo"
      @ 20,22 Prompt "       Voltar ao Menu Principal       " message "Voltar ao Menu Principal"
      Menu To nMenu
      MontaTela()
      SetColor("GR+/B,B/W+")
      @  7,25 Say "CERTIFICADOS QUALIDADE EMITIDOS"
      If nMenu = 1
         @ 14,25 Say "Digite o n£mero do CQ :" Get nCQ
         Read
         nRec := ProcCQEmit( nCQ , "N" )
      ElseIf nMenu = 2              
         @ 14,25 Say "Digite a n£mero da NF :" Get nNF 
         Read
         nRec := ProcCQEmit( nNF , "F" )
      ElseIf nMenu = 3
         @ 14,25 Say "Digite a data do CQ :" Get dData
         Read
         nRec := ProcCQEmit( dData , "D" )
      ElseIf nMenu = 4
         @ 14,25 Say "Digite o nome do cliente do CQ :"
         @ 15,34 Get cCliente picture "@!"
         Read
         nRec := ProcCQEmit( cCliente , "C" )
      ElseIf nMenu = 5
         @ 14,30 Say "C - Conexao"
         @ 15,30 Say "V - V†lvula"
         @ 16,30 Say "Digite o tipo do CQ :" Get cTipo picture "@!" valid cTipo $ "CV"
         Read
         nRec := ProcCQEmit( cTipo , "T" )
      Else
         Cls
         Clear Typeahead
         dbCloseAll()
         Return
      EndIf

      If nRec = 0
         @ 24,15 Say "Nao existe esse registro gravado no Banco de Dados !!!"
         tone(200,3)
         inkey(00)
         Clear Typeahead
         GetList := {}
         Loop
      EndIf

      Use CQ 
      dbGoTo( nRec )
      cTipo := CQ->TIPO

      Cls
      SetColor("GR+/B,B/W+")
      @ 0,0 clear to 0,80
      @ 0,24 Say "Conesteel Conexoes de Aáo Ltda."
      @ 24,0 clear to 24,80
      @ 24,0 Say "Mensagem :"
      SetColor("B/W+")
      @ 2,0 CLEAR TO 2,80
      DispBox(1,0,3,79,2)
      @ 2,18 Say "CCQ - Controle de Certificados de Qualidade"
      SetColor("B/N")
      nLin := 1
      For nLin = 4 To 23
          @ nLin,0 Say Replicate ("≤±",40)
      Next
      SetColor("GR+/B,B/W+")
      DispBox(5,4,23,75,2)
      @  6,5  CLEAR TO 22,74
      @  7,4  Say "Ã"
      @  7,5  Say Replicate("Õ",70)
      @  7,75 Say "π"
      @  6,24 Say "CERTIFICADO QUALIDADE EMITIDO nß " + transform( CQ->NUMERO , "99999" )

      dbCloseArea()
      Use CQ
      dbGoTo( nRec )

      a := Len( LTRIM( RTRIM( CQ->CERQUA ) ) )
      cCQ := LTRIM( RTRIM( CQ->CERQUA ) )
      For nI = a To 9
          cCq := "0" + cCQ
      Next
      cCQ      := transform( cCQ , "AAAAAAAAAA" )

      cCliente := CQ->CLIENTE
      dData    := CQ->DATA
      cPedido  := CQ->PEDIDO
      nNF      := CQ->NF
      @  8,7  Say "Certificado de Qualidade nß :" Get cCQ
      @  8,55 Say "Data :" Get dData
      @  9,7  Say "Cliente :" Get cCliente
      @  9,31 Say "Pedido :" Get cPedido
      @  9,57 Say "nß N.F.:" Get nNF

      If cTipo = "C"
         aPecas := {}
         aPecas := { { "01" , CQ->QUANT1 , CQ->FIG1 , CQ->BIT1 , CQ->MAT1 , CQ->CC1 , CQ->CF1 } , ;
                     { "02" , CQ->QUANT2 , CQ->FIG2 , CQ->BIT2 , CQ->MAT2 , CQ->CC2 , CQ->CF2 } , ;
                     { "03" , CQ->QUANT3 , CQ->FIG3 , CQ->BIT3 , CQ->MAT3 , CQ->CC3 , CQ->CF3 } , ;
                     { "04" , CQ->QUANT4 , CQ->FIG4 , CQ->BIT4 , CQ->MAT4 , CQ->CC4 , CQ->CF4 } , ;
                     { "05" , CQ->QUANT5 , CQ->FIG5 , CQ->BIT5 , CQ->MAT5 , CQ->CC5 , CQ->CF5 } , ;
                     { "06" , CQ->QUANT6 , CQ->FIG6 , CQ->BIT6 , CQ->MAT6 , CQ->CC6 , CQ->CF6 } , ;
                     { "07" , CQ->QUANT7 , CQ->FIG7 , CQ->BIT7 , CQ->MAT7 , CQ->CC7 , CQ->CF7 } , ;
                     { "08" , CQ->QUANT8 , CQ->FIG8 , CQ->BIT8 , CQ->MAT8 , CQ->CC8 , CQ->CF8 } , ;
                     { "09" , CQ->QUANT9 , CQ->FIG9 , CQ->BIT9 , CQ->MAT9 , CQ->CC9 , CQ->CF9 } , ;
                     { "10" , CQ->QUANT10 , CQ->FIG10 , CQ->BIT10 , CQ->MAT10 , CQ->CC10 , CQ->CF10 } , ;
                     { "11" , CQ->QUANT11 , CQ->FIG11 , CQ->BIT11 , CQ->MAT11 , CQ->CC11 , CQ->CF11 } , ;
                     { "12" , CQ->QUANT12 , CQ->FIG12 , CQ->BIT12 , CQ->MAT12 , CQ->CC12 , CQ->CF12 } }
         @ 10,5   Say "Item"
         @ 10,10  Say "Quant"
         @ 10,17  Say "Figura"
         @ 10,30  Say "Bitola"
         @ 10,47  Say "Material"
         @ 10,58  Say "C.Con."
         @ 10,65  Say "Cor.Forn."
         nN := 1
         nLin := 11
         While nN <= 12
               @ nLin , 6  Say aPecas[nN][1]
               @ nLin , 10 Get aPecas[nN][2]
               @ nLin , 17 Get aPecas[nN][3]
               @ nLin , 30 Get aPecas[nN][4]
               @ nLin , 47 Get aPecas[nN][5]
               @ nLin , 58 Get aPecas[nN][6]
               @ nLin , 65 Get aPecas[nN][7]
               nLin++
               nN++
         End
         Tone(300,2) ; Tone(300,2)
         @ 24 , 11 Say "Pressione qualquer tecla para continuar..."
         INKEY(00)
         dbCloseArea()
         Use FORNE
         dbGoTop()
         While .not. EOF() .and. LastKey() <> 27
                     If RTRIM( FORNE->CLIENTE ) = RTRIM( cCliente )
                        cEmpresa := FORNE->EMPRESA
                        cCGC := FORNE->CGC
                        exit
                     EndIf
                     dbSkip(1)
         End
         aCQC := {}
         Aadd( aCQC , { cCQ , cCliente , cEmpresa , cCGC , dData , nNF , cPedido } )
         nN := 1
         dbCloseArea()
         While nN <= 12
               aVet := {}
               aVet := ProcuraCQ( aPecas[nN][3] , aPecas[nN][4] , aPecas[nN][5] , aPecas[nN][6] )
               aVet[1][1 ] := aPecas[nN][1]
               aVet[1][2 ] := aPecas[nN][2]
               aVet[1][3 ] := aPecas[nN][3]
               aVet[1][7 ] := aPecas[nN][4]
               aVet[1][8 ] := aPecas[nN][5]
               aVet[1][29] := aPecas[nN][6]
               aVet[1][30] := aPecas[nN][7]
               Aadd( aCQC ,  aVet[1] )
               nN++
         End

         // Se for CQ de Uniao
         nN := 2
         While nN <= 13
               If RTRIM( SUBSTR( aCQC[nN][3] , 1 , 2 ) ) == "17" .and. ;
                         SUBSTR( aCQC[nN][3] , 4 , 5 ) <> "BT" .or. ;
                  RTRIM( SUBSTR( aCQC[nN][3] , 1 , 2 ) ) == "18" .and. ;
                         SUBSTR( aCQC[nN][3] , 4 , 5 ) <> "BT" .or. ;
                  RTRIM( SUBSTR( aCQC[nN][3] , 1 , 2 ) ) == "19" .and. ;
                         SUBSTR( aCQC[nN][3] , 4 , 5 ) <> "BT"
                  Use UNIAO 
                  dbGoTop()
                  aVet := {}
                  While .not. EOF()
                        If RTRIM( UNIAO->FIGURA ) = RTRIM( aCQC[nN][3] )
                           Aadd( aVet , { UNIAO->BITOLA , RecNo() } )
                        EndIf
                        dbSkip( 1 )
                  End
                  nO := 1
                  While nO <= Len( aVet )
                        If RTRIM( aVet[nO][1] ) = RTRIM( aCQC[nN][7] )
                           nRec := aVet[nO][2]
                        EndIf
                        nO++
                  End
                  dbGoTo( nRec )

                  cNome := { UNIAO->PM , UNIAO->PF , UNIAO->PC }
                  aCQC[nN] := { aCQC[nN][1] , aCQC[nN][2] , aCQC[nN][3] , ;
                            UNIAO->DESCRICAO , UNIAO->CLASSE , UNIAO->EXTRE , ;
                            aCQC[nN][7] , "" , "" , 0 , 0 , 0 , ;
                            0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , ;
                            0 , 0 , 0 , 0 , "" , "" , "" }

                  nOp := 1
                  While nOp <= 3
                        If nOp = 1
                           cUniao := "17-BT-PM"
                        ElseIf nOp = 2
                           cUniao := "17-BT-PF"
                        Else
                           cUniao := "17-BT-PC"
                        EndIf
                        nO := nN + nOp
                        aVet := {}

                        aVet := ProcuraCQUniao( aCQC[nN][3] , aCQC[nN][7] , aCQC[nO][8] , aCQC[nO][29] , cUniao )
                        aVet[1][1 ] := aCQC[nO][1]
                        aVet[1][2 ] := 0
                        aVet[1][3 ] := cUniao
                        aVet[1][4 ] := cNome[nOp]
                        aVet[1][8 ] := aCQC[nO][8]
                        aVet[1][29] := aCQC[nO][29]
                        aVet[1][30] := aCQC[nO][30]
                        aCQC[ nO ] := aVet[1]
                        nOp++
                  End
                  nN := nO
               EndIf
               nN++
         End
      ElseIf cTipo = "V"
         aPecas := {}
         aPecas := { { "01" , CQ->QUANT1 , CQ->FIG1 , CQ->BIT1 , CQ->MAT1 , CQ->CC1 , CQ->CF1 } , ;
                     { "02" , CQ->QUANT2 , CQ->FIG2 , CQ->BIT2 , CQ->MAT2 , CQ->CC2 , CQ->CF2 } , ;
                     { "03" , CQ->QUANT3 , CQ->FIG3 , CQ->BIT3 , CQ->MAT3 , CQ->CC3 , CQ->CF3 } , ;
                     { "04" , CQ->QUANT4 , CQ->FIG4 , CQ->BIT4 , CQ->MAT4 , CQ->CC4 , CQ->CF4 } , ;
                     { "05" , CQ->QUANT5 , CQ->FIG5 , CQ->BIT5 , CQ->MAT5 , CQ->CC5 , CQ->CF5 } , ;
                     { "06" , CQ->QUANT6 , CQ->FIG6 , CQ->BIT6 , CQ->MAT6 , CQ->CC6 , CQ->CF6 } , ;
                     { "07" , CQ->QUANT7 , CQ->FIG7 , CQ->BIT7 , CQ->MAT7 , CQ->CC7 , CQ->CF7 } , ;
                     { "08" , CQ->QUANT8 , CQ->FIG8 , CQ->BIT8 , CQ->MAT8 , CQ->CC8 , CQ->CF8 } , ;
                     { "09" , CQ->QUANT9 , CQ->FIG9 , CQ->BIT9 , CQ->MAT9 , CQ->CC9 , CQ->CF9 } , ;
                     { "10" , CQ->QUANT10 , CQ->FIG10 , CQ->BIT10 , CQ->MAT10 , CQ->CC10 , CQ->CF10 } , ;
                     { "11" , CQ->QUANT11 , CQ->FIG11 , CQ->BIT11 , CQ->MAT11 , CQ->CC11 , CQ->CF11 } , ;
                     { "12" , CQ->QUANT12 , CQ->FIG12 , CQ->BIT12 , CQ->MAT12 , CQ->CC12 , CQ->CF12 } }
         @ 10,5   Say "Item"
         @ 10,10  Say "Quant"
         @ 10,17  Say "Figura"
         @ 10,30  Say "Bitola"
         @ 10,47  Say "Material"
         @ 10,58  Say "C.Con."
         @ 10,65  Say "Cor.Forn."
         nN := 1
         nLin := 11
         While nN <= 12
               @ nLin , 6  Say aPecas[nN][1]
               @ nLin , 10 Get aPecas[nN][2]
               @ nLin , 17 Get aPecas[nN][3]
               @ nLin , 30 Get aPecas[nN][4]
               @ nLin , 47 Get aPecas[nN][5]
               @ nLin , 58 Get aPecas[nN][6]
               @ nLin , 65 Get aPecas[nN][7]
               nLin++
               nN++
         End
         Tone(300,2) ; Tone(300,2)
         @ 24 , 11 Say "Pressione qualquer tecla para continuar..."
         INKEY(00)
         Use FORNE 
         dbGoTop()
         While .not. EOF() .and. LastKey() <> 27
                     If RTRIM( FORNE->CLIENTE ) = RTRIM( cCliente )
                        cEmpresa := FORNE->EMPRESA
                        cCGC := FORNE->CGC
                        exit
                     EndIf
                     dbSkip(1)
         End
         aCQC := {}
         Aadd( aCQC , {cCQ ,cCliente ,cEmpresa ,cCGC ,dData ,nNF ,cPedido } )

         Use VALVULA 
         dbGoTop()
         nN := 1
         aVet := {}
         cFig := aPecas[1][3]
         cBit := aPecas[1][4]
         cMat := aPecas[1][5]
         nQuant := aPecas[1][2]

         While .not. EOF()
               If RTRIM( cFig ) == RTRIM( VALVULA->FIGURA )
                  Aadd( aVet, { RTRIM( VALVULA->BITOLA ) , RTRIM( VALVULA->MATERIAL ) , RecNo() } )
               EndIf
               dbSkip(1)
         End
         nN := 1
         aVet1 := {}
         While nN <= Len( aVet )
               If RTRIM( cBit ) == RTRIM( aVet[nN][1] )
                  Aadd( aVet1, { aVet[nN][2] , aVet[nN][3] } )
               EndIf
               nN++
         End
         nN := 1
         nRec := 0
         While nN <= Len( aVet1 )
               If RTRIM( cMat ) == RTRIM( aVet1[nN][1] )
                  nRec := aVet1[nN][2]
                  exit
               EndIf
               nN++
         End
         dbGoTo( nRec )
                                                               
         Aadd( aCQC , { nQuant , VALVULA->FIGURA , VALVULA->BITOLA , ;
                        VALVULA->MATERIAL , VALVULA->DESCRICAO , ;
                        VALVULA->INTERNOS , VALVULA->CLASSE , VALVULA->EXTRE , ;
                        VALVULA->TESTECORPO , VALVULA->TESTEVEDA } )

         cVar := {}
         If RTRIM( VALVULA->COMP1 ) <> space(14)
            Aadd( cVar , { "01" , VALVULA->COMP1 , VALVULA->MP1 , ;
                           VALVULA->BITMP1 , VALVULA->MATMP1, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP2 ) <> space(14)
            Aadd( cVar , { "02" , VALVULA->COMP2 , VALVULA->MP2 , ;
                           VALVULA->BITMP2 , VALVULA->MATMP2, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP3 ) <> space(14)
            Aadd( cVar , { "03" , VALVULA->COMP3 , VALVULA->MP3 , ;
                           VALVULA->BITMP3 , VALVULA->MATMP3, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP4 ) <> space(14)
            Aadd( cVar , { "04" , VALVULA->COMP4 , VALVULA->MP4 , ;
                           VALVULA->BITMP4 , VALVULA->MATMP4, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP5 ) <> space(14)
            Aadd( cVar , { "05" , VALVULA->COMP5 , VALVULA->MP5 , ;
                           VALVULA->BITMP5 , VALVULA->MATMP5, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP6 ) <> space(14)
            Aadd( cVar , { "06" , VALVULA->COMP6 , VALVULA->MP6 , ;
                           VALVULA->BITMP6 , VALVULA->MATMP6, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP7 ) <> space(14)
            Aadd( cVar , { "07" , VALVULA->COMP7 , VALVULA->MP7 , ;
                           VALVULA->BITMP7 , VALVULA->MATMP7, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                           NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP8 ) <> space(14)
            Aadd( cVar , { "08" , VALVULA->COMP8 , VALVULA->MATMP8 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP9 ) <> space(14)
            Aadd( cVar , { "09" , VALVULA->COMP9 , VALVULA->MATMP9 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP10 ) <> space(14)
            Aadd( cVar , { "10" , VALVULA->COMP10 , VALVULA->MATMP10 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP11 ) <> space(14)
            Aadd( cVar , { "11" , VALVULA->COMP11 , VALVULA->MATMP11 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP12 ) <> space(14)
            Aadd( cVar , { "12" , VALVULA->COMP12 , VALVULA->MATMP12 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP13 ) <> space(14)
            Aadd( cVar , { "13" , VALVULA->COMP13 , VALVULA->MATMP13 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP14 ) <> space(14)
            Aadd( cVar , { "14" , VALVULA->COMP14 , VALVULA->MATMP14 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP15 ) <> space(14)
            Aadd( cVar , { "15" , VALVULA->COMP15 , VALVULA->MATMP15 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf
         If RTRIM( VALVULA->COMP16 ) <> space(14)
            Aadd( cVar , { "16" , VALVULA->COMP16 , VALVULA->MATMP16 } )
         Else
            Aadd( cVar , { "  " , "              " , "            " } )
         EndIf

         If SUBSTR( cFig , 2 , 2 ) = "0"
            cCorrCorpo   := aPecas[2][6]
            cCorrCastelo := aPecas[3][6]
            cCorrPreme   := aPecas[4][6]
            cCorrCunha   := aPecas[5][6]
            cCorrAnel    := aPecas[6][6]
            cCorrHTGAV   := aPecas[7][6]
            If SUBSTR( cFig , 5 , 5 ) = "1" .or. SUBSTR( cFig , 2 , 2 ) = "3" .or. ;
               SUBSTR( cFig , 5 , 5 ) = "6" .or. SUBSTR( cFig , 2 , 2 ) = "9" .or. ;
               SUBSTR( cFig , 2 , 2 ) = "15"
               cCorrFlange := aPecas[8][6]
            EndIf
         ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
            cCorrCorpo      := aPecas[2][6]
            cCorrCastelo    := aPecas[3][6]
            cCorrPreme      := aPecas[4][6]
            cCorrContraSede := aPecas[5][6]
            cCorrSede       := aPecas[6][6]
            cCorrHTGLOBO    := aPecas[7][6]
            If SUBSTR( cFig , 5 , 5 ) = "1" .or. SUBSTR( cFig , 2 , 2 ) = "3" .or. ;
               SUBSTR( cFig , 5 , 5 ) = "6" .or. SUBSTR( cFig , 2 , 2 ) = "9" .or. ;
               SUBSTR( cFig , 2 , 2 ) = "15"
               cCorrFlange := aPecas[8][6]
            EndIf
         ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
            cCorrCorpo  := aPecas[2][6]
            cCorrTampa  := aPecas[3][6]
            cCorrPistao := aPecas[4][6]
            cCorrSede   := aPecas[5][6]
            If SUBSTR( cFig , 5 , 5 ) = "1" .or. SUBSTR( cFig , 2 , 2 ) = "3" .or. ;
               SUBSTR( cFig , 5 , 5 ) = "6" .or. SUBSTR( cFig , 2 , 2 ) = "9" .or. ;
               SUBSTR( cFig , 2 , 2 ) = "15"
               cCorrFlange := aPecas[6][6]
            EndIf
         EndIf

         Use VAL_COMP 

         nI := 7
         nJ := 1
         While nJ <= nI
               dbGoTop()
               nN := 1
               aVet := {}
               While .not. EOF()
                     If RTRIM( cVar[nJ][3] ) == RTRIM( VAL_COMP->COMPONENTE )
                        Aadd( aVet, { VAL_COMP->BITOLA_VAL , VAL_COMP->MATERIAL ,; 
                                      VAL_COMP->CORR_FORN , RecNo() } )
                     EndIf
                     dbSkip(1)
               End
               nN := 1
               aVet1 := {}
               While nN <= Len( aVet )
                     If RTRIM( cVar[nJ][4] ) == RTRIM( aVet[nN][1] )
                        Aadd( aVet1, { aVet[nN][2] , aVet[nN][3] , aVet[nN][4] } )
                     EndIf
                     nN++
               End 
               nN := 1
               aVet2 := {}
               While nN <= Len( aVet1 )
                     If RTRIM( cVar[nJ][5] ) == RTRIM( aVet1[nN][1] )
                        Aadd( aVet2, { aVet1[nN][2] , aVet1[nN][3] } )
                     EndIf
                     nN++
               End
               nRec := 0
               nN := 1
               While nN <= Len( aVet2 )
                     If nJ = 1
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrCorpo ) == RTRIM( aVet2[nN][1] )
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrCorpo ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
                           If RTRIM( cCorrCorpo ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 2
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrCastelo ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrCastelo ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
                           If RTRIM( cCorrTampa ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 3
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrPreme ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrPreme ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
                           If RTRIM( cCorrPistao ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 4
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrCunha ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrContraSede ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
                           If RTRIM( cCorrSede ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 5
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrAnel ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrSede ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "4"
                           If RTRIM( cCorrFlange ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 6
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrHTGAV ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrHTGLOBO ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     ElseIf nJ = 7
                        If SUBSTR( cFig , 2 , 2 ) = "0"
                           If RTRIM( cCorrFlange ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        ElseIf SUBSTR( cFig , 2 , 2 ) = "2"
                           If RTRIM( cCorrFlange ) == RTRIM( aVet2[nN][1] ) 
                              nRec := aVet2[nN][2]
                              exit
                           EndIf
                        EndIf
                     EndIf
                     nN++
                     nRec := 0
               End
               dbGoTo( nRec )
               cVar[nJ][6 ] := VAL_COMP->OBS
               cVar[nJ][7 ] := VAL_COMP->C
               cVar[nJ][8 ] := VAL_COMP->SI
               cVar[nJ][9 ] := VAL_COMP->MN
               cVar[nJ][10] := VAL_COMP->P
               cVar[nJ][11] := VAL_COMP->S
               cVar[nJ][12] := VAL_COMP->CR
               cVar[nJ][13] := VAL_COMP->NI
               cVar[nJ][14] := VAL_COMP->MO
               cVar[nJ][15] := VAL_COMP->CU
               cVar[nJ][16] := VAL_COMP->V
               cVar[nJ][17] := VAL_COMP->NB
               cVar[nJ][18] := VAL_COMP->AL
               cVar[nJ][19] := VAL_COMP->TI
               cVar[nJ][20] := VAL_COMP->N2
               cVar[nJ][21] := VAL_COMP->LIM_ESCO
               cVar[nJ][22] := VAL_COMP->LIM_RESIS
               cVar[nJ][23] := VAL_COMP->ESTRI
               cVar[nJ][24] := VAL_COMP->ALONGA
               cVar[nJ][25] := VAL_COMP->DUREZA
               cVar[nJ][26] := VAL_COMP->CORRIDA
               cVar[nJ][27] := VAL_COMP->CORR_FORN
               cVar[nJ][28] := VAL_COMP->CO
               nJ++
         End
         nI := 1
         While nI <= Len( cVar )
               Aadd( aCQC , cVar[nI] )
               nI++
         End
      EndIf

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
            If cTipo = "C"
               CQCON( aCQC )
            ElseIf cTipo = "V"
               CQVAL( aCQC )
            EndIf
            exit
      End
      Exit
End

Cls
Clear Typeahead
dbCloseAll()
Return
