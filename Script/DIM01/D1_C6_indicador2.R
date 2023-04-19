## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração
# Indicadora: 1.6.2. Ausência de criança ou adolescente com até 14 anos que nasceu em outro município

D1_C6_I2 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_local_nascimento_pessoa,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_local_nascimento_pessoa,
                     aux_idade)]
  }

  # marcando criança/adolescente que nasceu fora do município ---------------
  
  dado[, marca_crianca := fifelse((aux_idade >= 0 & aux_idade <= 14) & 
                                    (p.cod_local_nascimento_pessoa != 1), 1, 0)]
  

  # quantidade total por família --------------------------------------------
  
  dado <- dado[, .(total_crianca_q_migrou = sum(marca_crianca, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d1_c6_i2 := fifelse(total_crianca_q_migrou > 0, 0, 1)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c6_i2)]
  
  return(saida)
}