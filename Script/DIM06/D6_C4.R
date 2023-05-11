## NAGI - SETADES / 2022
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.4. Acesso adquado à água

D6_C4 <- function(base, com_comp=F){
  
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  dado <- base
  
  # função indicador 6.4.1
  source("Script/DIM06/D6_C4_indicador1.R",
         encoding = "UTF-8")
  # função indicador 6.4.2 
  source("Script/DIM06/D6_C4_indicador2.R",
         encoding = "UTF-8")

  dado1 <- D6_C4_I1(dado); setkey(dado1, d.cod_familiar_fam) # indicador 6.4.1
  dado2 <- D6_C4_I2(dado); setkey(dado2, d.cod_familiar_fam) # indicador 6.4.2
 
  lista_indicadores <- list(dado1, dado2)
  
  
  # juntando os indicadores -------------------------------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # calculando o componente -------------------------------------------------
  dado[, d6_c4 := rowMeans(as.data.table(.(d6_c4_i1,
                                           d6_c4_i2)), 
                           na.rm = TRUE )]
  
  
  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d6_c4)]
  } else {
    saida <- dado
  }
  
  return(saida)
}


