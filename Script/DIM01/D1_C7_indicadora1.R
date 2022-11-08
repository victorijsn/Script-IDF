## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.7. Comunidades tradicionais


D1_C7_I1 <- function(base) {
  dado <- base
  

  # marcando familia indigena ou quilombola ---------------------------------
  dado[, marca_fam := fifelse(d.cod_familia_indigena_fam != 1 & d.ind_familia_quilombola_fam != 1, 0, 1)]
  

  # agrupando por família ---------------------------------------------------
  dado <- dado[, .(familias = sum(marca_fam, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  

  # calculando a indicadora -------------------------------------------------
  dado[, d1_c7_i1 := fifelse(familias > 0, 0, 1)]  
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c7_i1)]
  
  return(saida)
}