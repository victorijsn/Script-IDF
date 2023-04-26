## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.2. Escolaridade
# Indicador: 2.2.4. Presença de pelo menos um adulto com alguma educação superior
# Repetição proposital para dar maior peso ao ensino superior

D2_C2_I4 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("d2_c2_i3" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     d2_c2_i3)]
    
    dado[, d2_c2_i4 := d2_c2_i3]
    
  } else {
    
    source("Script/DIM02/D2_C2_indicador3.R") 
    
    dado <- D2_C2_I3(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     d2_c2_i3)]
    
    dado[, d2_c2_i4 := d2_c2_i3]
  }
  

  # Validação ---------------------------------------------------------------
  
  
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c2_i4)]
  
  return(saida)
}
