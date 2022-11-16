## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.5. Convivência familiar
# Indicadora: 1.5.1. Ausência de crianças com até 9 anos que não são filho ou enteado do responsável pela unidade familiar 

D1_C5_I1 <- function(base){
  
  require(data.table)
  dado <- base
  
  # calculando a variável idade caso ela não exista -------------------------
  
  if ("aux_idade" %in% colnames(dado)) {
    dado <- dado
  } else {
    if ("auxiliar_idade" %in% ls()){
      dado <- auxiliar_idade(dado)
    } else {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(dado)
    }
  }

  # marcando criança com essas caracteriíticas ------------------------------
  
  dado[, marcador := fifelse(aux_idade >= 0 & aux_idade <= 9 & 
                               !(p.cod_parentesco_rf_pessoa %in% c(3,4)), 1, 0)]
  

  # calculando a quantidade dessas crianças na familía -------------------------
  
  dado <- dado[, .(total_ausentes = sum(marcador, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  # calculando o indicador -----------------------------------------------------
  
  dado[, d1_c5_i1 := fifelse(total_ausentes > 0, 0, 1)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c5_i1)]
  
  return(saida)
}