## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração
# Indicadora: 1.6.2. Ausência de criança ou adolescente com até 14 anos que nasceu em outro município

D1_C6_I2 <- function(base){
  

  # calculando a variavel idade caso não exista  ----------------------------
  if ("aux_idade" %in% colnames(base)) {
    dado <- base
  } else {
    if ("auxiliar_idade" %in% ls()){
      dado <- auxiliar_idade(base)
    } else {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
    }
  }
  

  # marcando criança/adolescente que nasceu fora do municipio ---------------
  dado[, marca_crianca := fifelse((aux_idade >= 0 & aux_idade <= 14) & 
                                    (p.cod_local_nascimento_pessoa != 1), 1, 0)]
  

  # contando por familia ----------------------------------------------------
  dado <- dado[, .(total_crianca_q_migrou = sum(marca_crianca, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  dado[, d1_c6_i2 := fifelse(total_crianca_q_migrou > 0, 0, 1)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c6_i2)]
  
  return(saida)
}