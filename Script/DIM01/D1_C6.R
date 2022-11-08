## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração

D1_C6 <- function(base) {
  

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
  

  # chamando as funções dos indicadores -------------------------------------
  source("Script/DIM01/D1_C6_indicadora1.R", encoding = "UTF-8")
  source("Script/DIM01/D1_C6_indicadora2.R", encoding = "UTF-8")
  

  # calculando os indicadores do componente ---------------------------------
  dado1 <- D1_C6_I1(base)
  dado2 <- D1_C6_I2(base)
  

  # juntando as bases -------------------------------------------------------
  dado <- dado1[dado2, on= "d.cod_familiar_fam"]
  

  # calculando o componente -------------------------------------------------
  dado[, d1_c6 := rowMeans(as.data.table(.(d1_c6_i1,
                                           d1_c6_i2)))]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                  d1_c6)]
  return(saida)
}
