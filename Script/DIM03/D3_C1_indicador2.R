## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho
# Indicador: 3.1.2. Mais da metade dos membros em idade ativa encontra-se ocupados na semana anterior a pesquisa


D3_C1_I2 <- function(base) {
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
  source("Script/AUXILIARES/auxiliar_idade_ativa.R") 
  

  if (("aux_idade_ativa" %in% colnames(base)) == TRUE) {
    
    
    if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
      
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
      
    } else {
      
      dado <- auxiliar_pessoa_ocupada(base)
      
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
    }
    
  } else {
    
    if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
      
      dado <- auxiliar_idade_ativa(base)
      
      dado <- dado[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
      
    } else {
      
      dado <- auxiliar_idade_ativa(base)
      dado <- auxiliar_pessoa_ocupada(dado)
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)] 
    }
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


  # calculando o indicador --------------------------------------------------

  dado[, d3_c1_i2 := fifelse(total_pess_idade_ativa_trab > (total_pess_idade_ativa / 2), 1, 0)]


  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d3_c1_i2)]

  return(saida)

}
