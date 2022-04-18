/****************************************************************************
*          SISCOVAL - CCQ - Controle de Certificados de Qualidade           *
*        Programa feito por Maur¡cio Fernandes Raphael em 02/04/98          *
*                    Conesteel Conexoes de A‡o Ltda.                        *
*                               MENUBD.PRG                                  *
****************************************************************************/

Local nLin,nMenu_Conex

While .T.
      MontaTela()
      SetColor("GR+/B,B/W+")
      @ 7,33 Say "MENU MATERIA-PRIMA"
      @ 10,26 Prompt "  Inserir/Alterar CQ Laminado  " message "Abre BD Laminados para consultar, inserir, alterar dados"
      @ 12,26 Prompt "  Inserir/Alterar CQ Forjados  " message "Abre BD Forjados para consultar, inserir, alterar dados"
      @ 14,26 Prompt "  Inserir/Alterar CQ V lvulas  " message "Abre BD V lvulas para consultar, inserir, alterar dados"
      @ 16,26 Prompt "  Inserir/Alterar CQ Internos  " message "Abre BD Internos para consultar, inserir, alterar dados"
      @ 20,26 Prompt "    Voltar ao Menu Diversos    " message "Voltar ao Menu Diversos"
      Menu To nMenu_Conex
      If nMenu_Conex = 1
         cq_lam()
      ElseIf nMenu_Conex = 2
         cq_forj()
      ElseIf nMenu_Conex = 3
         cq_val()
      ElseIf nMenu_Conex = 4
         cq_int()
      Else
         SetColor("W/N")
         Cls         
         Exit
      EndIf
End 

Cls
Clear Typeahead
Return
