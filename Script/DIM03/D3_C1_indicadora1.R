## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho
# Indicador: 3.1.1. Presença de pelo menos um membro em idade ativa

D3_C1_I1 <- function(base) {
  
  require(data.table)
  dado <- base
  
  # calculando variável idade ativa caso ela não exista ---------------------------
  
  if ("aux_idade_ativa" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_idade_ativa.R", encoding = "UTF-8")
    dado <- auxiliar_idade_ativa(dado)
  }
  
  
  # calculando o total de pessoas com idade ativa na família ----------------

  dado <- dado[, .(total_pess_com_idade_ativa = sum(aux_idade_ativa)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando indicador de presença de pelos menos um membro em ida --------
  
  dado[, d3_c1_i1 := fifelse(total_pess_com_idade_ativa > 0, 1, 0)]
  
  

  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c1_i1)]
  
  return(saida)
}

