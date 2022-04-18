/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               CONFIG.PRG                                  *
****************************************************************************/

Local nLin,nVisu

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @ 7,33 Say "MENU CONFIGURA€AO"
      @ 12,26 Prompt "           Abrir BD            " message "Abre Banco de Dados dos Laminados"
      @ 14,26 Prompt "     Abrir BD de Forjados      " message "Abre Banco de Dados dos Forjados"
      @ 16,26 Prompt "     Abrir BD das V lvulas     " message "Abre Banco de Dados das V lvulas"
      @ 18,26 Prompt "   Voltar ao Menu Principal    " message "Volta ao Menu Principal"
      Menu To nVisu
      If nVisu = 1
         bd()
      ElseIf nVisu = 2
      
      ElseIf nVisu = 3
      
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return
