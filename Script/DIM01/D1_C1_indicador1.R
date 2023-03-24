## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 
# Indicador: 1.1.1. Ausência de criança


D1_C1_I1 <- function(base){
  
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

  # marca criança 0 a 6 -----------------------------------------------------
  
  dado[, marca_idade_0_a_6 := fifelse(aux_idade >= 0 & aux_idade <= 6, 1, 
                                        fifelse(is.na(aux_idade), NA_real_, 0))]


  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_pessoas_0_a_6 = 
                     sum(marca_idade_0_a_6, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d1_c1_i1 := fifelse(total_pessoas_0_a_6 > 0, 0, 1)]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c1_i1)]
  
  return(saida)
}



