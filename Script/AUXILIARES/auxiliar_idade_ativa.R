## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Pessoa em Idade Ativa

auxiliar_idade_ativa <- function(base) {
  
  require(data.table)
  dado <- base

  # chamando função auxiliar idade ------------------------------------------
  if ("aux_idade" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R", encoding = "UTF-8")
    dado <- auxiliar_idade(dado)
  }
  

  # marcando quem tem idade ativa ou não ------------------------------------
  
  dado[, aux_idade_ativa := fifelse(aux_idade >= 16 & aux_idade < 65, 1, 0)]
  

  # saida -------------------------------------------------------------------
  
  saida <- dado
  
  return(saida)
  
}
