## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho
# Indicador: 3.1.1. Presença de pelo menos um membro em idade ativa

D3_C1_I1 <- function(base) {
  
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
  
  
  # calculando o total de pessoas com idade ativa na família ----------------

  dado <- dado[, .(total_pess_com_idade_ativa = sum(aux_idade_ativa)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d3_c1_i1 := fifelse(total_pess_com_idade_ativa > 0, 1, 0)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c1_i1)]
  
  return(saida)
}

