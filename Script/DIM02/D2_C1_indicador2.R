## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.1. Analfabetismo
# Indicador: 2.1.2. Ausência de adultos analfabetos funcionais

D2_C1_I2 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & "aux_educa" %in% colnames(base)) {
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade,
                     aux_educa)]
  } else {
    if (!("aux_idade" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
    } 
    if (!("aux_educa" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_educacao.R")
      dado <- auxiliar_educa(base)
    }
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade,
                     aux_educa)]
  }

  # calculando o indicador --------------------------------------------------
  
  dado[,marc_analf_func:=fifelse(aux_idade>17L & aux_educa < 4L,1L,0L)]
  
  dado <- dado[, .(total_adultos_analf_func = sum(marc_analf_func, na.rm = T)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c1_i2 := fifelse(total_adultos_analf_func > 0L, 0L, 1L)]
  
  # Validação ---------------------------------------------------------------
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c1_i2)]
  return(saida)
}