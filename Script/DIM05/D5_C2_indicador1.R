## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.2. Acesso à escola
# Indicador: 5.2.1. Ausência de criancas entre de 4 a 6 anos fora da escola

D5_C2_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base)) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_frequenta_escola_memb,
                     aux_idade)]
    
    dado[,idade_arred:=floor(aux_idade)]
    
  } else {
    
    if (!("aux_idade" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_idade.R") 
      
      dado <- auxiliar_idade(base)
      
      dado <- base[, .(d.cod_familiar_fam,
                       p.ind_frequenta_escola_memb,
                       aux_idade)]
      
      dado[,idade_arred:=floor(aux_idade)]
    }
  }
  
  # Criancas entre 4 e 6 anos fora da escola ---------------------------------
  
  dado[idade_arred >= 4L & idade_arred <= 6L, 
       marca_4a6anos_fora_escola:=fifelse(p.ind_frequenta_escola_memb>=3,1L,0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_4a6anos_fora_escola = 
                     sum(marca_4a6anos_fora_escola, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d5_c2_i1 := fifelse(total_4a6anos_fora_escola > 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5_c2_i1)]
  
  return(saida)
}