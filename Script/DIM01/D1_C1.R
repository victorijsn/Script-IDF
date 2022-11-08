## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 

D1_C1 <- function(base){
  
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  
  # função indicadora 1.1.1
  source("Script/DIM01/D1_C1_indicadora1.R",
         encoding = "UTF-8")
  # função indicadora 1.1.2 
  source("Script/DIM01/D1_C1_indicadora2.R",
         encoding = "UTF-8")
  # função indicadora 1.1.3 
  source("Script/DIM01/D1_C1_indicadora3.R",
         encoding = "UTF-8")
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    base <- base
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") # auxiliar idade
    base <- auxiliar_idade(base)
  }
  
  dado1 <- D1_C1_I1(base) # indicador 1.1.1
  dado2 <- D1_C1_I2(base) # indicador 1.1.2
  dado3 <- D1_C1_I3(base) # indicador 1.1.3
  

  # juntando os indicadores -------------------------------------------------
  dado <- dado1[dado2, on=c("d.cod_familiar_fam")
                ][dado3, on=c("d.cod_familiar_fam")]

    
  # calculando o componente -------------------------------------------------
  dado[, d1_c1 := rowMeans(as.data.table(.(d1_c1_i1,
                                           d1_c1_i2, 
                                           d1_c1_i3)), 
                          na.rm = TRUE )]
  

  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c1)]
  
  return(saida)
}


