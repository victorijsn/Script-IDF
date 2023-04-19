## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica
# Indicador: 1.3.2. Mais da Metade dos Membros se Encontram em Idade Ativa


D1_C3_I2 <- function(base){

  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade_ativa" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade_ativa)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade_ativa.R") 
    
    dado <- auxiliar_idade_ativa(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     aux_idade_ativa)]
  }

  # calculando se mais da metade da familia é idade ativa -------------------
  
  dado[, cadastradas := 1] # variável criada para calcular a quantidade de pessoas cadastradas
  
  dado <- dado[, .(#total_pessoas_domic = sum(d.qtd_pessoas_domic_fam)/length(d.qtd_pessoas_domic_fam),
            total_pessoas_domic = sum(cadastradas, na.rm = TRUE),
            total_pessoas_idade_ativa = sum(aux_idade_ativa, na.rm = TRUE)), 
       by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d1_c3_i2 := fifelse(total_pessoas_idade_ativa > (total_pessoas_domic / 2), 1, 0)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                   d1_c3_i2)]
  
  return(saida)
}
