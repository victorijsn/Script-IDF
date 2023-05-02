## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.3. Progresso escolar
# Indicador: 5.3.1. Ausência de criancas até 14 anos com mais de 2 anos de atraso

D5_C3_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & "aux_educa" %in% colnames(base)) {
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade,
                     aux_educa)]
    dado[,idade_arred:=floor(aux_idade)]
  } else {
    if (!("aux_idade" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
      dado[,idade_arred:=floor(aux_idade)]
    } 
    if (!("aux_educa" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_educacao.R")
      dado <- auxiliar_educa(base)
    }
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade,
                     aux_educa,
                     idade_arred)]
  }
  
  # Marca de defasagem escolar superior a 2 anos em crianças até 14 anos  ---

  dado[idade_arred<=14,defasagem:= (idade_arred - 6L) - aux_educa] # Verificar isso.
  dado[defasagem<0,defasagem:= NA_real_]
  dado[,marca_defasagem:=fifelse(idade_arred<=14 & defasagem>2L, 1L, 0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_14anos_defasagem = 
                     sum(marca_defasagem, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d5_c3_i1 := fifelse(total_14anos_defasagem > 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5_c3_i1)]
  
  return(saida)
}