## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Rendas

# aux_alguma_renda
# aux_renda_trabalho
# aux_renda_transferencia
# aux_renda_sem_transferencia
# aux_renda_deflacionada

auxiliar_rendas <- function(base) {

  require(data.table)
  dado <- base

  # retirando na's ----------------------------------------------------------
  dado[, aux_renda_trabalho := fifelse(is.na(p.val_remuner_emprego_memb), 0, as.numeric(p.val_remuner_emprego_memb))]


  # calculando alguma renda da pessoa ---------------------------------------
  dado[, aux_alguma_renda := rowSums(as.data.frame(.(p.val_renda_bruta_12_meses_memb,
                                                     p.val_renda_doacao_memb,
                                                     p.val_renda_aposent_memb,
                                                     p.val_renda_seguro_desemp_memb,
                                                     p.val_renda_pensao_alimen_memb,
                                                     p.val_outras_rendas_memb)),
                                     na.rm = TRUE)]


  # renda de transferência --------------------------------------------------
  dado[, aux_renda_transferencia := rowSums(as.data.frame(.(p.val_renda_doacao_memb,
                                                          p.val_renda_aposent_memb,
                                                          p.val_renda_seguro_desemp_memb,
                                                          p.val_renda_pensao_alimen_memb)),
                                            na.rm=TRUE)]


  # renda que não provém de transferências ----------------------------------
  dado[, aux_renda_sem_transferencia := aux_alguma_renda - aux_renda_transferencia]
  dado[, aux_renda_sem_transferencia := fifelse(aux_renda_sem_transferencia < 0,
                                                0,
                                                aux_renda_sem_transferencia)]
  saida <- dado
  return(saida)
  }


