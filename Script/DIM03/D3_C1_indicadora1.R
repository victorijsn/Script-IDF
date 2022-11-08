## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho
# Indicador: 3.1.1. Presença de pelo menos um membro em idade ativa

D3_C1_I1 <- function(base) {
  
  require(data.table)
  
  if ("aux_idade" %chin% colnames(base)) {
    dado <- base 
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R", encoding = "UTF-8")
    dado <- auxiliar_idade(base)
  }
  
  dado[, marca_idade_ativa := fifelse(aux_idade >= 15, 1, 0)]
  
  dado <- dado[, .(total_fam_cm_IA = sum(marca_idade_ativa)), 
               by = c("d.cod_familiar_fam")]
  
  dado[, d3_c1_i1 := fifelse(total_fam_cm_IA > 0, 1, 0)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c1_i1)]
  
  return(saida)
}

