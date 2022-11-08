## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica
# Indicador: 1.3.2. Mais da Metade dos Membros se Encontram em Idade Ativa


D1_C3_I2 <- function(base){

  # calculando as idades ----------------------------------------------------
  if ("aux_idade" %in% colnames(base)) {
    dado <- base
  } else {
    if ("auxiliar_idade" %in% ls()){
      dado <- auxiliar_idade(base)
    } else {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
    }
  }
  
  # marca pessoa idade ativa ------------------------------------------------
  dado[, marca_idade_ativa := fifelse(aux_idade > 14 & aux_idade < 65, 1, 0)]
  

  # calculando se mais da metade da familia é idade ativa -------------------
  dado[, cadastradas := 1] # variável criada para calcular a quantidade de pessoas cadastradas
  dado <- dado[, .(#total_pessoas_domic = sum(d.qtd_pessoas_domic_fam)/length(d.qtd_pessoas_domic_fam),
            total_pessoas_domic = sum(cadastradas, na.rm = TRUE),
            total_pessoas_idade_ativa = sum(marca_idade_ativa, na.rm = TRUE)), 
       by = c("d.cod_familiar_fam")]

  # calculando indicador ----------------------------------------------------
  dado[, d1_c3_i2 := fifelse(total_pessoas_idade_ativa > (total_pessoas_domic / 2), 1, 0)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                   d1_c3_i2)]
  return(saida)
}
