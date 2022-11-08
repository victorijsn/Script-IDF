## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.5. Convivência familiar
# Indicadora: 1.5.2. Ausência de crianças de até 9 anos que seja "outro parente" ou "não parente" 

D1_C5_I2 <- function(base) {

  # calculando a variável idade caso ela não exista -------------------------
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
  
  # marcando crianças com essa característica -------------------------------
  dado[, marcador := fifelse(aux_idade >= 0 & 
                               aux_idade <= 9 & 
                               (p.cod_parentesco_rf_pessoa %in% c(10,11)), 1, 0)]
  

  # contando criança com essa característica por família --------------------
  dado <- dado[, .(total_ausentes = sum(marcador, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  # calculando o indicador -----------------------------------------------------
  dado[, d1_c5_i2 := fifelse(total_ausentes > 0, 0, 1)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c5_i2)]
  
  return(saida)
}
