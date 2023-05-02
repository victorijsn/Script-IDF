## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.3. Progresso escolar
# Indicador: 5.3.2. Ausência de pelo menos um adolescente de 10 a 14 anos analfabeto

D5_C3_I2 <- function(base){
  
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

  dado[aux_idade>=10 & aux_idade<=14, 
       marca_analfabeto:= fifelse(p.cod_sabe_ler_escrever_memb==2L,1L,0L)]
  
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_10a14anos_analf = 
                     sum(marca_analfabeto, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d5_c3_i2 := fifelse(total_10a14anos_analf > 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5_c3_i2)]
  
  return(saida)
}