/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur°cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de Aáo Ltda.                        *
*                              CQ_VALV.PRG                                  *
****************************************************************************/

/****************************************************************************
Vetor aCQC: { {cCQ ,cCliApelido ,cEmpresa ,cCGC ,dData ,nNF ,cPedido }  , ;
              { nQuant , VALVULA->FIGURA , VALVULA->BITOLA , ;
                VALVULA->MATERIAL , VALVULA->DESCRICAO , ;
                VALVULA->INTERNOS , VALVULA->CLASSE , VALVULA->EXTRE , ;
                VALVULA->TESTECORPO , VALVULA->TESTEVEDA } ) , ;
         |     { "01" , VALVULA->COMP1 , VALVULA->MP1 , ;
     8   |       VALVULA->BITMP1 , VALVULA->MATMP1, NIL, NIL, NIL, ;
    X's  |       NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
         |       NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL } )  }
****************************************************************************/

Local nLin, cCQ, cCliApelido, cEmpresa, cCGC, cPedido, nNF , cEmp1 , cEmp2
Local dData, nCQ , aCQC, nOp , nLI , nLF, cItem, cFig , cBit, cMat , aItem
Local nQuant, cCorCon, aVet , nMenu , cTela, nI , nJ, lTeste, nO, cPecas
Local cCorrCorpo , cCorrCastelo , cCorrPreme , cCorrTampa , cCorrFlange
Local cCorrAnel , cCorrSede , cCorrHTGAV , cCorrHTGLOBO, cCorrPistao, cMaterial
Local nN, aVet1 , aVet2, nRec , cCorrCunha , cCorrContraSede , nV , cVar, aCQS
Local GetList := {}

Local aCQC1 , aCQC2 , aCQC3 , aCQC4 , aCQC5 , aCQC6 , aCQC7 , aCQC8
Local aCQC9 , aCQC10 , aCQC11 , aCQC12 , aCQC13 , aCQC14 , aCQC15 , aCQC16 

cCQ := space(10)
cCliApelido := space(12)
cCGC := space(18)
cPedido := space(15)
cEmpresa := space(60)
nLin := nNF := nQuant := nMenu := 0
dData := CtoD("")
aVet := aItem := aCQS := {}

cFig := space(6)
cBit := space(6)
cMat := cCorrFlange := cCorrPistao := cCorrCunha := cCorrContraSede := space(10)
cCorrAnel := cCorrSede := cCorrHTGAV := cCorrHTGLOBO := space(10)
cCorCon := cCorrCorpo := cCorrCastelo := cCorrPreme := cCorrTampa := space(5)


While .T. .and. LastKey() <> 27
      MontaTelaGrande()
      @  6,24 Say "CERTIFICADOS QUALIDADE VALVULAS"
      Use CQ 
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
      Use FORNE
      dbGoTop()
      While .not. EOF() .and. LastKey() <> 27
            If RTRIM( FORNE->CLIENTE ) = RTRIM(cCliApelido)
               cEmpresa := FORNE->EMPRESA
               exit
            EndIf
            dbSkip(1)
      End
      @ 12,8  Say "Razao Social :"
      @ 14,8  Get cEmpresa
      cCGC := FORNE->CGC
      @ 16,8  Say "C.N.P.J. :" Get cCGC 
      @ 18,8  Say "N£mero do Pedido :" Get cPedido
      @ 20,8  Say "N£mero da Nota Fiscal :" Get nNF valid nNF <> 0
      Read


      // ESTE WHILE ê PARA IMPRIMIR + DE UM CQ DE VALVULA
      nV := 1
      While .T.
         cVar := "aCQC" + transform( nV , "99" )
         cVar := {}
         Use CQ 
         dbGoBottom()
         nCQ := CQ->NUMERO
         cCQ := transform( nCQ + 1 , "99999" ) + "/" + transform( Year(Date()) , "9999")

      Aadd(cVar , {cCQ ,cCliApelido ,cEmpresa ,cCGC ,dData ,nNF ,cPedido } )

      DispBox(5,4,23,75,2)
      @  6,5  CLEAR TO 22,74
      @  6,24 Say "CERTIFICADOS QUALIDADE VALVULA " + transform( nV , "99" )
      @  7,4  Say "Ã"
      @  7,5  Say Replicate("Õ",70)
      @  7,75 Say "π"
      @  8,18 Say "Quantidade :" Get nQuant picture "@9 99999"
      Read
      If nQuant = 0 .or. LastKey() = 27
         exit
      EndIf

      While .T.
            lTeste := .f.
            While lTeste = .f.
                  @ 10,18 Say "Figura     :" Get cFig picture "@!" valid cFig <> space(6)
                  Read
                  lTeste := Teste( "VV" , cFig )
            End
            lTeste := .f.
            While lTeste = .f.
                  @ 12,18 Say "Bitola     :" Get cBit picture "@!" valid cBit <> space(6)
                  Read
                  lTeste := Teste( "BV" , cBit )
            End
            lTeste := .f.
            While lTeste = .f.
                  @ 14,18 Say "Material   :" Get cMat picture "@!" valid cMat <> space(10)
                  Read
                  lTeste := Teste( "MT" , cMat )
            End
            exit
      End

      Use VALVULA
      dbGoTop()
      nN := 1
      aVet := {}
      While .not. EOF()
            If RTRIM( cFig ) == RTRIM( VALVULA->FIGURA )
               Aadd( aVet, { VALVULA->BITOLA , VALVULA->MATERIAL , RecNo() } )
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
            If RTRIM( cMat ) = RTRIM( aVet1[nN][1] )
               nRec := aVet1[nN][2]
               exit
            EndIf
            nN++
      End
      dbGoTo( nRec )
                                                               
      Aadd( cVar , { nQuant , VALVULA->FIGURA , VALVULA->BITOLA , ;
                     VALVULA->MATERIAL , VALVULA->DESCRICAO , ;
                     VALVULA->INTERNOS , VALVULA->CLASSE , VALVULA->EXTRE , ;
                     VALVULA->TESTECORPO , VALVULA->TESTEVEDA } )

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

      If SUBSTR( cFig , 2 , 2 ) = "0" .OR. SUBSTR( cFig , 2 , 2 ) = "1"
         cCorrCunha := CorridaInterno( cVar[6][3] , cVar[6][4] , cVar[6][5] )
         cCorrAnel := CorridaInterno( cVar[7][3] , cVar[7][4] , cVar[7][5] )
         cCorrHTGAV := CorridaInterno( cVar[8][3] , cVar[8][4] , cVar[8][5] )
         @  8,48 Say "Digite as Corridas:"
         lTeste := .f.
         While lTeste = .f.
               @ 10,48 Say "Corpo   :" Get cCorrCorpo picture "@!"
               Read
               lTeste := TestaCorrida( "CP" , cFig , cBit , cCorrCorpo )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         lTeste := .f.
         While lTeste = .f.
               @ 12,48 Say "Castelo :" Get cCorrCastelo picture "@!"
               Read
               lTeste := TestaCorrida( "CT" , cFig , cBit , cCorrCastelo )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         lTeste := .f.
         While lTeste = .f.
               @ 14,48 Say "Preme   :" Get cCorrPreme picture "@!"
               Read
               lTeste := TestaCorrida( "PR" , cFig , cBit , cCorrPreme )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         @ 16,48 Say "Cunha   :" Get cCorrCunha picture "@!"
         @ 18,48 Say "AnÇis   :" Get cCorrAnel picture "@!"
         @ 20,48 Say "Haste   :" Get cCorrHTGAV picture "@!"
         Read
      ElseIf SUBSTR( cFig , 2 , 2 ) = "2" .OR. SUBSTR( cFig , 2 , 2 ) = "3"
         cCorrContraSede := CorridaInterno( cVar[6][3] , cVar[6][4] , cVar[6][5] )
         cCorrSede := CorridaInterno( cVar[7][3] , cVar[7][4] , cVar[7][5] )
         cCorrHTGLOBO := CorridaInterno( cVar[8][3] , cVar[8][4] , cVar[8][5] )
         @  8,48 Say "Digite as Corridas:"
         lTeste := .f.
         While lTeste = .f.
               @ 10,48 Say "Corpo   :" Get cCorrCorpo picture "@!"
               Read
               lTeste := TestaCorrida( "CP" , cFig , cBit , cCorrCorpo )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         lTeste := .f.
         While lTeste = .f.
               @ 12,48 Say "Castelo :" Get cCorrCastelo picture "@!"
               Read
               lTeste := TestaCorrida( "CT" , cFig , cBit , cCorrCastelo )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         lTeste := .f.
         While lTeste = .f.
               @ 14,48 Say "Preme   :" Get cCorrPreme picture "@!"
               Read
               lTeste := TestaCorrida( "PR" , cFig , cBit , cCorrPreme )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         @ 16,48 Say "Contra-Sede :" Get cCorrContraSede picture "@!"
         @ 18,48 Say "Sede        :" Get cCorrSede picture "@!"
         @ 20,48 Say "Haste       :" Get cCorrHTGLOBO picture "@!"
         Read
      ElseIf SUBSTR( cFig , 2 , 2 ) = "4" .OR. SUBSTR( cFig , 2 , 2 ) = "5"
         cCorrPistao := CorridaInterno( cVar[5][3] , cVar[5][4] , cVar[5][5] )
         cCorrSede := CorridaInterno( cVar[6][3] , cVar[6][4] , cVar[6][5] )
         @  8,48 Say "Digite as Corridas:"
         lTeste := .f.
         While lTeste = .f.
               @ 10,48 Say "Corpo   :" Get cCorrCorpo picture "@!"
               Read
               lTeste := TestaCorrida( "CP" , cFig , cBit , cCorrCorpo )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         lTeste := .f.
         While lTeste = .f.
               @ 12,48 Say "Tampa   :" Get cCorrTampa picture "@!"
               Read
               lTeste := TestaCorrida( "TP" , cFig , cBit , cCorrTampa )
               If lTeste = .f.
                  cTela := SaveScreen( 10 , 23 , 18 , 61 )
                  Tela("R+/N,GR+/B",11,24,17,60)
                  SetColor("R+/N,GR+/B")
                  @ 11,25 Say "   N∆o existe essa corrida !!!   " color "R+*/N"
                  @ 12,25 Say "Digite outra corrida ou verifique"
                  @ 13,25 Say "no BD de v†lvulas se ela existe."
                  @ 15,39 Say "Ok" color "GR+/B"
                  Tone(200,3); Tone(10,0.5) ; Tone(200,3) ; Tone(10,0.5) ; Tone(200,3)
                  Inkey(00)
                  RestScreen( 10 , 23 , 18 , 61 , cTela )
                  SetColor("GR+/B,B/W+")
               EndIf
         End
         @ 14,48 Say "Pistao  :" Get cCorrPistao picture "@!"
         @ 16,48 Say "Sede    :" Get cCorrSede picture "@!"
         Read
      ElseIf SUBSTR( cFig , 2 , 2 ) = "6"

      EndIf

      If SUBSTR( cFig , 5 , 5 ) = "1" .or. SUBSTR( cFig , 5 , 5 ) = "3" .or. ;
         SUBSTR( cFig , 5 , 5 ) = "6" .or. SUBSTR( cFig , 5 , 5 ) = "9" .or. ;
         SUBSTR( cFig , 5 , 5 ) = "5"
         @ 21,48 Say "Flanges :" Get cCorrFlange picture "@!"
         Read
      EndIf

      Use VAL_COMP

      nI := 9
      nJ := 3
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
                  If nJ = 3
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
                  ElseIf nJ = 4
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
                  ElseIf nJ = 5
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
                  ElseIf nJ = 6
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
                  ElseIf nJ = 7
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
                  ElseIf nJ = 8
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
                  ElseIf nJ = 9
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
         nCQ := CQ->NUMERO 
         dbAppend()
         CQ->NUMERO  := nCQ + 1
         CQ->CLIENTE := cVar[1][2]
         CQ->DATA    := cVar[1][5]
         CQ->NF      := cVar[1][6]
         CQ->TIPO    := "V"
         CQ->CERQUA  := cVar[1][1]
         CQ->PEDIDO  := cVar[1][7]
         // AQUI GRAVA OS DADOS DA VALVULA
         CQ->QUANT1 := cVar[2][1]
         CQ->FIG1   := cVar[2][2]
         CQ->BIT1   := cVar[2][3]
         CQ->MAT1   := cVar[2][4]
         // AQUI GRAVA OS DADOS DOS COMPONENTES DA VALVULA
         CQ->FIG2   := cVar[3][3]
         CQ->BIT2   := cVar[3][4]
         CQ->MAT2   := cVar[3][5]
         CQ->CC2    := cVar[3][27]
         CQ->CF2    := cVar[3][28]
         CQ->FIG3   := cVar[4][3]
         CQ->BIT3   := cVar[4][4]
         CQ->MAT3   := cVar[4][5]
         CQ->CC3    := cVar[4][27]
         CQ->CF3    := cVar[4][28]
         CQ->FIG4   := cVar[5][3]
         CQ->BIT4   := cVar[5][4]
         CQ->MAT4   := cVar[5][5]
         CQ->CC4    := cVar[5][27]
         CQ->CF4    := cVar[5][28]
         CQ->FIG5   := cVar[6][3]
         CQ->BIT5   := cVar[6][4]
         CQ->MAT5   := cVar[6][5]
         CQ->CC5    := cVar[6][27]
         CQ->CF5    := cVar[6][28]
         CQ->FIG6   := cVar[7][3]
         CQ->BIT6   := cVar[7][4]
         CQ->MAT6   := cVar[7][5]
         CQ->CC6    := cVar[7][27]
         CQ->CF6    := cVar[7][28]
         CQ->FIG7   := cVar[8][3]
         CQ->BIT7   := cVar[8][4]
         CQ->MAT7   := cVar[8][5]
         CQ->CC7    := cVar[8][27]
         CQ->CF7    := cVar[8][28]
         CQ->FIG8   := cVar[9][3]
         CQ->BIT8   := cVar[9][4]
         CQ->MAT8   := cVar[9][5]
         CQ->CC8    := cVar[9][27]
         CQ->CF8    := cVar[9][28]
      Else
         Exit
      EndIf

      Aadd( aCQS , cVar )

      Tone(500,1) ; Tone(300,1) ; Tone(800,2)
      Tela("R+/N,GR+/B",11,22,17,62) 
      SetColor("R+/N,GR+/B")
      @ 12,27 Say "Deseja fazer outro CQ Valvula ?"
      @ 14,33 Prompt "Sim"
      @ 14,46 Prompt "Nao"
      SetColor("GR+/B,B/W+")
      Menu to nMenu
      If nMenu = 1
         cFig := space(6)
         cBit := space(6)
         cMat := cCorrFlange := cCorrPistao := cCorrCunha := cCorrContraSede := space(10)
         cCorrAnel := cCorrSede := cCorrHTGAV := cCorrHTGLOBO := space(10)
         cCorCon := cCorrCorpo := cCorrCastelo := cCorrPreme := cCorrTampa := space(5)
         nV++
         Loop
      Else
         Exit
      EndIf

      End

      // AQUI ê O RELAT‡RIO DO CERTIFICADO.

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

         nN := 1
         While nN <= Len( aCQS )
               CQVAL( aCQS[nN] )
               nN++
         End
      Else
         Exit
      EndIf

      exit
End

Cls
Clear Typeahead
dbCloseAll()
Return
