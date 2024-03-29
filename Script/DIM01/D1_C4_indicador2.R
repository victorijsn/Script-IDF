## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.4. Presença de jovem ou adulto 
# Indicador: 1.4.2. Presença de pelo menos uma pessoa de 18 anos ou mais 


D1_C4_I2 <- function(base){
  
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
  
  # marca pessoa 18 anos ou mais --------------------------------------------
  
  dado[, marca_idade_18 := fifelse(aux_idade >= 18, 1, 
                                   fifelse(is.na(aux_idade), NA_real_, 0))]
  
  
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_pessoas_18 = 
                     sum(marca_idade_18, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d1_c4_i2 := fifelse(total_pessoas_18 > 0, 1, 0)]

  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c4_i2)]
  
  return(saida)
}
