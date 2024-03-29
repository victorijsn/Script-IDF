## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.2. Pessoas com deficiência e idosos
# Indicador: 1.2.2. Ausência de idoso

D1_C2_I2 <- function(base) {
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     aux_idade)]
  }
  
  # marca se a pessoa é idosa -----------------------------------------------
  
  dado[, marca_idoso := fifelse(aux_idade >= 65, 1, 
                                fifelse(is.na(aux_idade), NA_real_, 0))]
  

  # calculando quantidade de pessoas idosas por família ---------------------
  
  dado <- dado[, .(total_idosos = sum(marca_idoso, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador -----------------------------------------------------
  
  dado[, d1_c2_i2 := fifelse(total_idosos > 0, 0, 1)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c2_i2)]
  
  return(saida)
}


