/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               CONFSYS.PRG                                 *
****************************************************************************/

Local nLin,nVisu

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @ 7,33 Say "MENU CONFIGURA€OES"
      @ 10,26 Prompt "  Inserir/Alterar CQ Laminado  " message "Abre BD Laminados para consultar, inserir, alterar dados"
      @ 12,26 Prompt "  Inserir/Alterar CQ Forjados  " message "Abre BD Forjados para consultar, inserir, alterar dados"
      @ 14,26 Prompt "  Inserir/Alterar CQ V lvulas  " message "Abre BD V lvulas para consultar, inserir, alterar dados"
      @ 16,26 Prompt "  Inserir/Alterar CQ Internos  " message "Abre BD Internos para consultar, inserir, alterar dados"
      @ 20,26 Prompt "    Voltar ao Menu Principal   " message "Voltar ao Menu Principal"
      Menu To nMenu_Conex
      If nMenu_Conex = 1
      ElseIf nMenu_Conex = 2
      ElseIf nMenu_Conex = 3
      ElseIf nMenu_Conex = 4
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return
