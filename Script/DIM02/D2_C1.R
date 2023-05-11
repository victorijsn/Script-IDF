## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.1. Analfabetismo

D2_C1 <- function(base, com_comp=F){
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & 
      "aux_educa" %in% colnames(base)) {
    
    dado <- base[,.(d.cod_familiar_fam,
                    p.cod_sabe_ler_escrever_memb,
                    p.ind_frequenta_escola_memb,
                    aux_idade,
                    aux_educa)]
  } else {
    if (!("aux_idade" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
    } 
    if (!("aux_educa" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_educacao.R")
      dado <- auxiliar_educa(base)
    }
    dado <- base[,.(d.cod_familiar_fam,
                    p.cod_sabe_ler_escrever_memb,
                    p.ind_frequenta_escola_memb,
                    aux_idade,
                    aux_educa)]
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM02/D2_C1_indicador1.R", 
         encoding = "UTF-8") 
  source("Script/DIM02/D2_C1_indicador2.R",
         encoding = "UTF-8") 
  source("Script/DIM02/D2_C1_indicador3.R",
         encoding = "UTF-8")
  source("Script/DIM02/D2_C1_indicador4.R",
         encoding = "UTF-8")
  source("Script/DIM02/D2_C1_indicador5.R",
         encoding = "UTF-8")
  
  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D2_C1_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D2_C1_I2(dado); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D2_C1_I3(dado); setkey(dado3, d.cod_familiar_fam)
  dado4 <- D2_C1_I4(dado); setkey(dado4, d.cod_familiar_fam)
  dado5 <- D2_C1_I5(dado); setkey(dado5, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2, dado3, dado4, dado5)
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d2_c1 := rowMeans(as.data.table(.(d2_c1_i1,
                                           d2_c1_i2, 
                                           d2_c1_i3,
                                           d2_c1_i4,
                                           d2_c1_i5)), 
                           na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d2_c1)]
  } else {
    saida <- dado
  }
  
  return(saida)
}