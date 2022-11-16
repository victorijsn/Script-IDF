## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho
# Indicador: 3.1.2. Mais da metade dos membros em idade ativa encontrase ocupados na semana anterior a pesquisa

D3_C1_I2 <- function(base) {
  
  require(data.table)
  dado <- base

  # marcando pessoa em idade ativa ------------------------------------------
  
  if ("aux_idade_ativa" %in% colnames(dado)) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_idade_ativa.R", encoding = "UTF-8")
    dado <- auxiliar_idade_ativa(dado)
  }
 

  # marcando se a pessoa estava ocupada -------------------------------------
  
  if ("aux_pessoa_ocupada" %in% colnames(dado)) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R", encoding = "UTF-8")
    dado <- auxiliar_pessoa_ocupada(dado)
  }
  

  # retirando os na's da variável auxiliar pessoa ocupada -------------------

  dado[, marca_pessoa_ocupada := fifelse(is.na(aux_pessoa_ocupada), 0, aux_pessoa_ocupada)]
  
  

  # marcando se a pessoa ativa estava trabalhando ---------------------------

  dado[, marca_pess_ativa_trabalhando := fifelse(marca_pessoa_ocupada == 1 & 
                                                   aux_idade_ativa == 1, 1, 0)]
  

  # calculando o total de pessoas com idade ativa e total de pessoas ativas trabalhando --------

  dado <- dado[, .(total_pess_idade_ativa = sum(aux_idade_ativa, na.rm = TRUE),
                   total_pess_idade_ativa_trab = sum(marca_pess_ativa_trabalhando, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  

  # calculando indicador ----------------------------------------------------

  dado[, d3_c1_i2 := fifelse(total_pess_idade_ativa_trab > (total_pess_idade_ativa / 2), 1, 0)]


  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d3_c1_i2)]

  return(saida)

}
