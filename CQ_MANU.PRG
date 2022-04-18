/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur°cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de Aáo Ltda.                        *
*                              CQ_MANU.PRG                                  *
****************************************************************************/

Local nLin,nMenu_Conex

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @ 7,35 Say "MENU CQ MANUAL"
      @ 12,30 Prompt "   Emitir CQ Conex‰es   " message "Fazer certificado de qualidade manual de conex∆o"
      @ 15,30 Prompt "   Emitir CQ V†lvulas   " message "Fazer certificado de qualidade manual de v†lvulas"
      @ 18,30 Prompt "Voltar ao Menu Principal" message "Voltar ao Menu Principal"
      Menu To nMenu_Conex
      If nMenu_Conex = 1
         
      ElseIf nMenu_Conex = 2
         
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return
