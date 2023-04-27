## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.1. Trabalho precoce
# Indicador: 5.1.1. Ausência de criancas menores de 12 anos trabalhando

D5_C1_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & "aux_pessoa_ocupada" %in% colnames(base)) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_trabalho_infantil_pessoa,
                     aux_idade,
                     aux_pessoa_ocupada)]
    
  } else {
    
    if (!("aux_idade" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_idade.R") 
      
      dado <- auxiliar_idade(base)
      
    }
    
    if (!("aux_pessoa_ocupada" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
      
      dado <- auxiliar_pessoa_ocupada(base)
      
    }
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_trabalho_infantil_pessoa,
                     aux_idade,
                     aux_pessoa_ocupada)]
  }
  
  # Criancas menores de 12 anos trabalhando ---------------------------------

  dado[aux_idade<12L, marca_12anos_trab:=fifelse(aux_pessoa_ocupada==1L |
                                                   p.ind_trabalho_infantil_pessoa==1L,
                                                 1L, 0L)]

  # calculando o indicador --------------------------------------------------
  
  dado <- dado[, .(total_12anos_trab = 
                     sum(marca_12anos_trab, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d5_c1_i1 := fifelse(total_12anos_trab > 0, 0, 1)]
  
  
  # Validação ---------------------------------------------------------------
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5_c1_i1)]
  
  return(saida)
}