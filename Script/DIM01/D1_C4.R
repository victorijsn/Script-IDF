## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.4. Presença de jovem ou adulto 


D1_C4 <- function(base){
    
  # chamando os indicadores -------------------------------------------------
  require(data.table)
  dado <- base
  
  # função indicadora 1.4.1
  source("Script/DIM01/D1_C4_indicadora1.R",
         encoding = "UTF-8")
  # função indicadora 1.4.2 
  source("Script/DIM01/D1_C4_indicadora2.R",
         encoding = "UTF-8")
  # função indicadora 1.4.3 
  source("Script/DIM01/D1_C4_indicadora3.R",
         encoding = "UTF-8")
  
  dado1 <- D1_C4_I1(dado) # indicador 1.4.1
  dado2 <- D1_C4_I2(dado) # indicador 1.4.2
  dado3 <- D1_C4_I3(dado) # indicador 1.4.3
  
  
  # juntando os indicadores -------------------------------------------------
  dado <- 
    dado1[dado2, on=c("d.cod_familiar_fam")][
      dado3, on=c("d.cod_familiar_fam")]
  
  
  # calculando o componente -------------------------------------------------
  dado[, d1_c4 := rowMeans(as.data.table(.(d1_c4_i1,
                                           d1_c4_i2, 
                                           d1_c4_i3)), 
                           na.rm = TRUE )]
  
  
  # validacao ---------------------------------------------------------------
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c4)]
  
  return(saida)
}


