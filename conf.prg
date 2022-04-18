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
      @  7 , 32 Say "MENU CONFIGURACOES"
      @ 10 , 25 Prompt "       Nomes dos Clientes      " message "Edi‡Æo de dados sobre clientes"
      @ 20 , 25 Prompt "    Voltar ao Menu Principal   " message "Voltar ao Menu Principal"
      Menu To nMenu
      If nMenu = 1
         cfg_nome()
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return

