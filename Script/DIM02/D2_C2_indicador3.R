## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.2. Escolaridade
# Indicador: 2.2.3. Presença de pelo menos um adulto com alguma educação superior

D2_C2_I3 <- function(base){
  
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
  
  # marca superior ----------------------------------------------
  
  dado[!is.na(p.grau_instrucao), marca_superior := 
         fifelse(p.grau_instrucao == 6L, 1L,0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[aux_idade>17L, .(total_adultos_superior = 
                                  sum(marca_superior, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c2_i3 := fifelse(total_adultos_superior == 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c2_i3)]
  
  return(saida)
}