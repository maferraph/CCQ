/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maurício Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexões de Aço Ltda.                        *
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
      @ 7,34 Say "MENU PRINCIPAL"
      @  9,26 Prompt "Emitir Certificados de Conexoes" message "Imprime Certificado de Qualidade de conexoes"
      @ 11,26 Prompt "Emitir Certificados de V lvulas" message "Imprime Certificado de Qualidade de v lvulas"
      @ 13,26 Prompt "Emitir Certificados Manualmente" message "Imprime CQ v lvulas ou conexäes manualmente"
      @ 15,26 Prompt "     Certificados Emitidos     " message "Consulta um Certificado de Qualidade emitido"
      @ 17,26 Prompt "            Diversos           " message "Abre Banco de Dados das Pe‡as"
      @ 19,26 Prompt "         Configura‡äes         " message "Consultar configura‡oes de corridas"
      @ 21,26 Prompt "        Sair do Sistema        " message "Sai do sistema"
      Menu To nMenu
      If nMenu = 1
         cq_conex()
      ElseIf nMenu = 2
         cq_valv()
      ElseIf nMenu = 3
         cq_manu()
      ElseIf nMenu = 4
         cq_emit()
      ElseIf nMenu = 5
         diversos()
         //menubd()
      ElseIf nMenu = 6
         conf()
         //corridas()
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return

