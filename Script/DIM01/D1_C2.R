## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 

D1_C2 <- function(base){
  
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  dado <- base
  
  # função indicadora 1.1.1
  source("Script/DIM01/D1_C2_indicadora1.R",
         encoding = "UTF-8")
  # função indicadora 1.1.2 
  source("Script/DIM01/D1_C2_indicadora2.R",
         encoding = "UTF-8")
  # função indicadora 1.1.3 
  source("Script/DIM01/D1_C2_indicadora3.R",
         encoding = "UTF-8")
  
  if (("aux_idade" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") # auxiliar idade
    dado <- auxiliar_idade(dado)
  }
  
  dado1 <- D1_C2_I1(dado) # indicador 1.2.1
  dado2 <- D1_C2_I2(dado) # indicador 1.2.2
  dado3 <- D1_C2_I3(dado) # indicador 1.2.3
  
  
  # juntando os indicadores -------------------------------------------------
  dado <- 
    dado1[dado2, on=c("d.cod_familiar_fam")][
      dado3, on=c("d.cod_familiar_fam")]
  
  
  # calculando o componente -------------------------------------------------
  dado[, d1_c2 := rowMeans(as.data.table(.(d1_c2_i1,
                                           d1_c2_i2, 
                                           d1_c2_i3)), 
                           na.rm = TRUE )]
  
  
  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c2)]
  
  return(saida)
}