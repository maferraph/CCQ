

Local cFig , a1 , a2 , a3 , a4 , a5 , a6 , b1 , b2 , b3 , b4 , b5 , b6 , nNum , oP
Local A , B , C , D , E , F , G , H , I , J , K , L , M , N , O , P , Q , R
Local ZZ , Zica , cBit

a1 := a2 := a3 := a4 := a5 := a6 := {}
b1 := b2 := b3 := b4 := b5 := b6 := 1
nNum := 0

Use VAL 

a1 := {"10","11","12","13","14","15","16","40","41","42","43","44","45", ;
      "46","60","61","62","63","64","65","66"}
a2 := {"0","1","2","4","5","6","7","8","9"}
a3 := {"N","B","S","1","3","6","5"}

a6 := { "1/4" + CHR(34) , "3/8" + CHR(34) , "1/2" + CHR(34) ,;
        "3/4" + CHR(34) , "1" + CHR(34) , "1.1/4" + CHR(34) ,;
        "1.1/2" + CHR(34) , "2" + CHR(34) }

cls

nNum := 0

For b1 = 1 to len( a1 )
    For b2 = 1 to len( a2 )
        For b3 = 1 to len( a3 )
            For b6 = 1 to len( a6 )

                If SUBSTR( a1[b1] , 1 , 1 ) == "1"
                   A := "ASTM A-105/95b"
                ElseIf SUBSTR( a1[b1] , 1 , 1 ) == "4"
                   A := "ASTM A-182 Gr.F304"
                ElseIf SUBSTR( a1[b1] , 1 , 1 ) == "6"
                   A := "ASTM A-182 Gr.F316"
                EndIf

                If SUBSTR( a1[b1] , 2 , 2 ) == "0"
                   B := "Valvula Gaveta Castelo Aparafusado (OS&Y)"
                   D := "800œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "1"
                   B := "Valvula Gaveta Castelo Aparafusado (OS&Y)"
                   D := "1500œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "2"
                   B := "Valvula Globo Castelo Aparafusado (OS&Y)"
                   D := "800œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "3"
                   B := "Valvula Globo Castelo Aparafusado (OS&Y)"
                   D := "1500œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "4"
                   B := "Valvula Reten‡ao Pistao Tampa Aparafusada"
                   D := "800œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "5"
                   B := "Valvula Reten‡ao Pistao Tampa Aparafusada"
                   D := "1500œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "6"
                   B := "Valvula Tarugo Ponta de Agulha Porca-Uniao"
                   D := "3000œ"
                ElseIf SUBSTR( a1[b1] , 2 , 2 ) == "7"
                   B := "Valvula Tarugo Ponta de Agulha Porca-Uniao"
                   D := "6000œ"
                EndIf

                If SUBSTR( a2[b2] , 1 , 1 ) == "0"
                   C := "F6"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "1"
                   C := "F6 / XU"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "2"
                   C := "F6 / U"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "4"
                   C := "F304"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "5"
                   C := "F304 / XU"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "6"
                   C := "F316"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "7"
                   C := "F316 / XU"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "8"
                   C := "F304 / U"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "9"
                   C := "F316 / U"
                EndIf

                If SUBSTR( a2[b2] , 1 , 1 ) == "N"
                   E := "NPT"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "B"
                   E := "BSP"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "S"
                   E := "SW"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "1"
                   E := "Flangeada"
                   D := "ASA 150œ"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "3"
                   E := "Flangeada"
                   D := "ASA 300œ"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "6"
                   E := "Flangeada"
                   D := "ASA 600œ"
                ElseIf SUBSTR( a2[b2] , 1 , 1 ) == "5"
                   E := "Flangeada"
                   D := "ASA 1500œ"
                EndIf

                cFig := a1[b1] + a2[b2] + "-" + a3[b3]
                            
                dbAppend()
                VAL->FIGURA := cFig
                VAL->BITOLA := a6[b6]
                VAL->DESCRICAO := B
                VAL->INTERNOS := C
                VAL->MATERIAL := A
                VAL->CLASSE := D

                nNum++
            Next
        Next
    Next
Next




?
? nNum
return






            
        



         
        
/*

a5 := { { { "8" , "800œ" } ,;
          { "5" , "1500œ" } } ,;
        { { "2" , "2000œ" } ,;
          { "T" , "3000œ" } ,;
          { "S" , "6000œ" } } ,;
        { { "1" , "150œ" } , ;
          { "3" , "300œ" } ,;
          { "6" , "600œ" } ,;
          { "9" , "900œ" } ,;
          { "5" , "1500œ" } } }


a1 := { { "10" , "Gaveta" } , ;
        { "12" , "Globo" } , ;
        { "14" , "Reten‡ao Pistao" } ,;
        { "16" , "Tarugo Ponta de Agulha" } ,;
        { "18" , "Reten‡ao Portinhola" } }



a3 := { { "N" , "NPT" } ,     ;
        { "B" , "BSP" } ,;
        { "T" , "BSPT" } ,;
        { "W" , "BW" } ,;
        { "1" , "WN-RF sch.40" } ,;
        { "2" , "WN-RF sch.80" } , ;
        { "3" , "WN-RF sch.160" } ,;
        { "4" , "WN-FJA sch.40" } , ;
        { "5" , "WN-FJA sch.80" } ,;
        { "6" , "WN-FJA sch.160" } ,;
        { "7" , "WN-RTJ sch.40" } ,;
        { "8" , "WN-RTJ sch.80" } ,;
        { "9" , "WN-RTJ sch.160" } }

a3 := { { "N" , "NPT" } ,     ;
        { "B" , "BSP" } ,;
        { "T" , "BSPT" } ,;
        { "1" , "Flangeada" } ,;
        { "3" , "WN-RF sch.160" } ,;
        { "6" , "WN-FJA sch.160" } }


cFig := space(7)
@ 1,1 Say "Digite a Figura: " Get cFig picture "@! 999-XXX"
read

? cFig
If SUBSTR( cFig , 1 , 2 ) = "10"
   ? "Valvula: " + a1[1][2]
ElseIf SUBSTR( cFig , 1 , 2 ) = "12"
   ? "Valvula: " + a1[2][2]
ElseIf SUBSTR( cFig , 1 , 2 ) = "14"
   ? "Valvula: " + a1[3][2]
ElseIf SUBSTR( cFig , 1 , 2 ) = "16"
   ? "Valvula: " + a1[4][2]
ElseIf SUBSTR( cFig , 1 , 2 ) = "18"
   ? "Valvula: " + a1[5][2]
EndIf

 
If SUBSTR( cFig , 3 , 3 ) = "0"
   ? "Internos: " + a2[1][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "1"
   ? "Internos: " + a2[2][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "2"
   ? "Internos: " + a2[3][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "4"
   ? "Internos: " + a2[4][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "5"
   ? "Internos: " + a2[5][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "6"
   ? "Internos: " + a2[6][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "7"
   ? "Internos: " + a2[7][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "8"
   ? "Internos: " + a2[8][2]
ElseIf SUBSTR( cFig , 3 , 3 ) = "9"
   ? "Internos: " + a2[9][2]
EndIf

If SUBSTR( cFig , 5 , 5 ) = "N"
   ? "Extremidade: " + a3[1][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "B"
   ? "Extremidade: " + a3[2][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "T"
   ? "Extremidade: " + a3[3][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "W"
   ? "Extremidade: " + a3[4][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "1"
   ? "Extremidade: " + a3[5][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "2"
   ? "Extremidade: " + a3[6][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "3"
   ? "Extremidade: " + a3[7][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "4"
   ? "Extremidade: " + a3[8][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "5"
   ? "Extremidade: " + a3[9][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "6"
   ? "Extremidade: " + a3[10][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "7"
   ? "Extremidade: " + a3[11][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "8"
   ? "Extremidade: " + a3[12][2]
ElseIf SUBSTR( cFig , 5 , 5 ) = "9"
   ? "Extremidade: " + a3[11][2]
EndIf

If SUBSTR( cFig , 6 , 6 ) = "C"
   ? "Material: " + a4[1][2]
ElseIf SUBSTR( cFig , 6 , 6 ) = "4"
   ? "Material: " + a4[2][2]
ElseIf SUBSTR( cFig , 6 , 6 ) = "L"
   ? "Material: " + a4[3][2]
ElseIf SUBSTR( cFig , 6 , 6 ) = "6"
   ? "Material: " + a4[4][2]
ElseIf SUBSTR( cFig , 6 , 6 ) = "K"
   ? "Material: " + a4[5][2]
EndIf

If SUBSTR( cFig , 7 , 7 ) = "8"
   ? "Classe: " + a5[1][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "5"
   ? "Classe: " + a5[2][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "2"
   ? "Classe: " + a5[3][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "T"
   ? "Classe: " + a5[4][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "S"
   ? "Classe: " + a5[5][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "1"
   ? "Classe: " + a5[6][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "3"
   ? "Classe: " + a5[5][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "6"
   ? "Classe: " + a5[7][2]
ElseIf SUBSTR( cFig , 7 , 7 ) = "9"
   ? "Classe: " + a5[9][2]
EndIf

*/
                                



        

