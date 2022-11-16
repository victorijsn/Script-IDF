## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 
# Indicador: 1.1.2. Ausência de criança ou adolescente


D1_C1_I2 <- function(base){
  
  require(data.table)
  dado <- base
  
  # calculando as idades ----------------------------------------------------
  
  if (("aux_idade" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") # auxiliar idade
    dado <- auxiliar_idade(dado)
  }
  
  # marca criança 0 a 14 -----------------------------------------------------
  
  dado[, marca_idade_0_a_14 := fifelse(aux_idade >= 0 & aux_idade <= 14, 1, 
                                      fifelse(is.na(aux_idade), NA_real_, 0))]
  
  
  # calculando indicador familiar -------------------------------------------
  
  dado <- dado[, .(total_pessoas_0_a_14 =
                     sum(marca_idade_0_a_14, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  dado[, d1_c1_i2 := fifelse(total_pessoas_0_a_14 > 0, 0, 1)]
  

  # validação ---------------------------------------------------------------

  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c1_i2)]
  
  return(saida)
}
