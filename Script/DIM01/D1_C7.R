## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.7. Comunidades tradicionais


D1_C7 <- function(base, com_comp=F) {
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  # chamando as colunas necessárias -----------------------------------------
  
  dado <- base[, .(d.cod_familiar_fam,
                   d.cod_familia_indigena_fam,
                   d.ind_familia_quilombola_fam)]
  
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM01/D1_C7_indicador1.R", encoding = "UTF-8")

  
  # calculando o indicador do componente ------------------------------------
  
  dado <- D1_C7_I1(dado)

  
  # Saída -------------------------------------------------------------------

  if (com_comp==F) {
    saida <- setnames(dado, "d1_c7_i1", "d1_c7")
  } else {
    saida <- dado[,d1_c7:=d1_c7_i1]
  }
  
  return(saida)
}
