## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.7. Comunidades tradicionais


D1_C7_I1 <- function(base) {
  
  # chamando as colunas necessárias -----------------------------------------
  
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam,
                   d.cod_familia_indigena_fam,
                   d.ind_familia_quilombola_fam)]
  
  # marcando família indigena ou quilombola ---------------------------------
  
  dado[, marca_fam := fifelse(d.cod_familia_indigena_fam != 1 & 
                                d.ind_familia_quilombola_fam != 1, 0, 1)]
  

  # calculando o total por família ------------------------------------------
  
  dado <- dado[, .(familias = sum(marca_fam, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d1_c7_i1 := fifelse(familias > 0, 0, 1)]  
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c7_i1)]
  
  return(saida)
}