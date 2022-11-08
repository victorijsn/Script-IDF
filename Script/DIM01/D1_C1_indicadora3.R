## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 
# Indicador: 1.1.3. Ausência de criança ou adolescente ou jovens


D1_C1_I3 <- function(base){
  
  # calculando as idades ----------------------------------------------------
  require(data.table)
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    dado <- base
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") # auxiliar idade
    dado <- auxiliar_idade(base)
  }
  
  # marca criança 0 a 17 -----------------------------------------------------
  dado[, marca_idade_0_a_17 := fifelse(aux_idade >= 0 & aux_idade <= 17, 1, 
                                       fifelse(is.na(aux_idade), NA_real_, 0))]
  
  
  # calculando indicador familiar -------------------------------------------
  dado <- dado[, .(total_pessoas_0_a_17 =
                     sum(marca_idade_0_a_17, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  dado[, d1_c1_i3 := fifelse(total_pessoas_0_a_17 > 0, 0, 1)]
  
  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c1_i3)]
  return(saida)
}
