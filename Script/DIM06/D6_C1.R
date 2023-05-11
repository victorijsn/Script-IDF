## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.1. Propriedade do domicílio 

D6_C1 <- function(base, com_comp=F){
  
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  dado <- base
  
  # função indicador 6.1.1
  source("Script/DIM06/D6_C1_indicador1.R",
         encoding = "UTF-8")
  # função indicador 6.1.2 
  source("Script/DIM06/D6_C1_indicador2.R",
         encoding = "UTF-8")
  # função indicador 6.1.3 
  source("Script/DIM06/D6_C1_indicador3.R",
         encoding = "UTF-8")
  
  dado1 <- D6_C1_I1(dado); setkey(dado1, d.cod_familiar_fam) # indicador 6.1.1
  dado2 <- D6_C1_I2(dado); setkey(dado2, d.cod_familiar_fam) # indicador 6.1.2
  dado3 <- D6_C1_I3(dado); setkey(dado3, d.cod_familiar_fam) # indicador 6.1.3
  
  lista_indicadores <- list(dado1, dado2, dado3)
  
  
  # juntando os indicadores -------------------------------------------------

  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)

  # calculando o componente -------------------------------------------------
  dado[, d6_c1 := rowMeans(as.data.table(.(d6_c1_i1,
                                           d6_c1_i2, 
                                           d6_c1_i3)), 
                           na.rm = TRUE )]
  
  
  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d6_c1)]
  } else {
    saida <- dado
  }
  
  return(saida)
}


