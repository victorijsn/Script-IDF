## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.5. Convivência familiar

D1_C5 <- function(base) {
  
  # calculando a variável idade caso ela não exista -------------------------
  
  if ("aux_idade" %in% colnames(base)) {
    base <- base
  } else {
    if ("auxiliar_idade" %in% ls()){
      base <- auxiliar_idade(base)
    } else {
      source("Script/AUXILIARES/auxiliar_idade.R")
      base <- auxiliar_idade(base)
    }
  }
  

  # chamando as funções dos indicadores da componente 5 ---------------------
  source("Script/DIM01/D1_C5_indicadora1.R", encoding = "UTF-8")
  source("Script/DIM01/D1_C5_indicadora2.R", encoding = "UTF-8")
  

 # calculando os indicadores -----------------------------------------------
  dado1 <- D1_C5_I1(base)
  dado2 <- D1_C5_I2(base)
  

  # juntando as bases -------------------------------------------------------
  dado <- dado1[dado2, on= "d.cod_familiar_fam"]
  

  # calculando o componente -------------------------------------------------
  dado[, d1_c5 := rowMeans(as.data.table(.(d1_c5_i1,
                                           d1_c5_i2)))]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                  d1_c5)]
  return(saida)
}
