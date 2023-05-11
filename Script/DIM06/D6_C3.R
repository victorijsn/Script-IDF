## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.2. Abrigabilidade 

D6_C3 <- function(base, com_comp=F){
  
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  dado <- base
  
  # função indicador 6.2.1
  source("Script/DIM06/D6_C3_indicador1.R",
         encoding = "UTF-8")
  
  dado1 <- D6_C3_I1(dado) # indicador 6.2.1
  
  # juntando os indicadores -------------------------------------------------
  
  dado <- dado1
  
  # calculando o componente -------------------------------------------------
  dado[, d6_c3 := rowMeans(as.data.table(.(d6_c3_i1)), 
                           na.rm = TRUE )]
  
  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d6_c3)]
  } else {
    saida <- dado
  }
  
  return(saida)
}


