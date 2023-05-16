## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.3. Progresso escolar
# Indicador: 5.3.3. Ausência de pelo menos um adolescente de 15 a 17 anos analfabeto

D5_C3_I3 <- function(base){
  
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
  

  # Marca analfabeto --------------------------------------------------------

  dado[aux_idade>=15 & aux_idade<=17, 
       marca_analfabeto:= fifelse(p.cod_sabe_ler_escrever_memb==2L,1L,0L)]
  
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_15a17anos_analf = 
                     sum(marca_analfabeto, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d5_c3_i3 := fifelse(total_15a17anos_analf > 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5_c3_i3)]
  
  return(saida)
}