/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maurício Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexões de Aço Ltda.                      *
*                               CONF.PRG
****************************************************************************/

Local nMenu,nLin

Set Century On
Set Date To British
Set Device to Screen
Set Message To 24 Center
Set Confirm On
Set Wrap On
SetColor("GR+/B,B/W+")

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @  7,34 Say "MENU DIVERSOS"
      @ 11,26 Prompt "  Certificados Materia-Prima   " message "Abre Banco de Dados das Pe‡as"
      @ 13,26 Prompt "      Corridas das Pe‡as       " message "Consultar configura‡oes de corridas"
      @ 19,26 Prompt "    Volta ao Menu Principal    " message "Volta ao menu principal"
      Menu To nMenu
      If nMenu = 1
         menubd()
      Elseif nMenu = 2
         corridas()
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return

