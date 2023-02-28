## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Índice de Desenvolvimento Familiar
# Função Auxiliar: valores

#base <- data.table::fread("../Base/tab_cad_13082022_32_20221004.csv")
#ano_inicial <- as.numeric("2020")
#data_referencia <- as.Date("2022-01-01")
#inpc <- auxiliar_inpc()
#deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)

auxiliar_valores <- function(base, deflatores){
  
  require(data.table)
  dado <- base

  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado[,d.dat_atual_fam := substr(as.character(d.dat_atual_fam), start = 1, stop = 7)]
  
  dado <- data.table::merge.data.table(x = dado, y = deflatores, by.x = "d.dat_atual_fam", by.y = "ano_mes")
  
  # Calculando alguma renda na família ---------------------------------------------------------------
  
  dado[, renda_alguma := rowSums(as.data.frame(.(p.val_renda_bruta_12_meses_memb, p.val_renda_doacao_memb,
                                             p.val_renda_aposent_memb, p.val_renda_seguro_desemp_memb,
                                             p.val_renda_pensao_alimen_memb, p.val_outras_rendas_memb)),
                             na.rm = TRUE)*deflatores]
  
  # Calculando alguma renda de tranferência na família -----------------------------------------------
  
  dado[, renda_tranferencia := rowSums(as.data.frame(.(p.val_renda_doacao_memb, p.val_renda_aposent_memb,
                                                p.val_renda_seguro_desemp_memb, p.val_renda_pensao_alimen_memb)),
                                na.rm = TRUE)*deflatores]
  
  # Calculando renda na família sem contar com as tranferências --------------------------------------
  
  dado[, renda_sem_tranferencia := renda_alguma - renda_tranferencia]
  
  # Calculando as despesas totais na família ---------------------------------------------------------
  
  dado[, despesa_total := rowSums(as.data.frame(.(d.val_desp_energia_fam, d.val_desp_agua_esgoto_fam,
                                                  d.val_desp_gas_fam, d.val_desp_alimentacao_fam,
                                                  d.val_desp_transpor_fam, d.val_desp_aluguel_fam,
                                                  d.val_desp_medicamentos_fam)), na.rm = TRUE) * deflatores]
  
  # Calculando a renda média da família --------------------------------------------------------------
  
  dado[, renda_media := d.vlr_renda_media_fam*deflatores]
  
  # Calculando a despesa com alimentação da família --------------------------------------------------
  
  #dado[, despesa_alimentacao := d.val_desp_alimentacao_fam*deflatores] SUGESTÂO deflacionar as despesas com alimentação
  dado[, despesa_alimentacao := d.val_desp_alimentacao_fam]
  
  # saida -----------------------------------------------------
  
  saida <- dado
  
  return(saida)
}