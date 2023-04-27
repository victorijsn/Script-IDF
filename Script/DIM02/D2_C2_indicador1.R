## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.2. Escolaridade
# Indicador: 2.2.1. Presença de pelo menos um adulto com fundamental completo

D2_C2_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.grau_instrucao,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.grau_instrucao,
                     aux_idade)]
  }
  
  # marca fundamental completo ----------------------------------------------
  
  dado[!is.na(p.grau_instrucao), marca_fund_completo := 
         fifelse(p.grau_instrucao>=3L, 1L,0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[aux_idade>17L, .(total_adultos_fund_completo = 
                                  sum(marca_fund_completo, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c2_i1 := fifelse(total_adultos_fund_completo == 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c2_i1)]
  
  return(saida)
}