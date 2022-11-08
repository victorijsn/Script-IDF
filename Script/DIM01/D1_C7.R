## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.7. Comunidades tradicionais


D1_C7 <- function(base) {
  
  # chamando o indicador do componente --------------------------------------
  source("Script/DIM01/D1_C7_indicadora1.R", encoding = "UTF-8")
  

  # calculando o indicador --------------------------------------------------
  dado <- D1_C7_I1(base)

  # modificando apenas o nome -----------------------------------------------
  saida <- setnames(dado, "d1_c7_i1", "d1_c7")
  
  return(saida)
}