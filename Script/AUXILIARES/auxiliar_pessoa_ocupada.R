## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Pessoas Ocupada até uma semana da data de referência ou afastadas

auxiliar_pessoa_ocupada <- function(base) {
  
  require(data.table)
  
  dado <- base

  # marcando se a pessoa estava trabalhando ou afastada ---------------------
  dado[, aux_pessoa_ocupada:= fifelse((p.cod_trabalhou_memb==1) | (p.cod_trabalhou_memb==2 & p.cod_afastado_trab_memb==1),1,
                         fifelse((p.cod_trabalhou_memb==2) | (p.cod_afastado_trab_memb!=1 & p.cod_afastado_trab_memb!=2), 0, NA_real_))]
  

  # validação ---------------------------------------------------------------

  
  
  # saida -------------------------------------------------------------------
  saida <- dado
  
  return(saida)
  
}