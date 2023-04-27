## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.1. Analfabetismo
# Indicador: 2.1.1. Ausência de adultos analfabetos

D2_C1_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     aux_idade)]
  }
  
  # marca analfabeto -----------------------------------------------------
  
  dado[!is.na(p.cod_sabe_ler_escrever_memb), marca_analfabeto := 
         fifelse(p.cod_sabe_ler_escrever_memb==2L, 1L,0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[aux_idade>17L, .(total_adultos_analfabetos = 
                     sum(marca_analfabeto, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c1_i1 := fifelse(total_adultos_analfabetos > 0, 0, 1)]
  

  # Validação ---------------------------------------------------------------

  
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c1_i1)]
  
  return(saida)
}