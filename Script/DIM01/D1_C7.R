## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.7. Comunidades tradicionais


D1_C7 <- function(base) {
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  dado <- base[, .(d.cod_familiar_fam,
                   d.cod_familia_indigena_fam,
                   d.ind_familia_quilombola_fam)]
  
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM01/D1_C7_indicador1.R", encoding = "UTF-8")

  
  # calculando o indicador do componente ------------------------------------
  
  dado <- D1_C7_I1(dado)

  
  # modificando apenas o nome -----------------------------------------------
  
  saida <- setnames(dado, "d1_c7_i1", "d1_c7")
  
  return(saida)
}