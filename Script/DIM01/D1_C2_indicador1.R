## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.2. Pessoas com deficiência e idosos
# Indicador: 1.2.1. Ausência de pessoas com deficiência

D1_C2_I1 <- function(base) {
  
  # chamando as colunas necessárias -----------------------------------------
  
  require(data.table)
  
  dado <- base[, .(d.cod_familiar_fam,
                   p.cod_deficiencia_memb)]
  
  # marcando pessoas com deficiência ----------------------------------------

  dado[, marca_deficiente := fifelse(p.cod_deficiencia_memb == 1, 1, 
                                fifelse(is.na(p.cod_deficiencia_memb), NA_real_, 0))]
  

  # quantidade total de pessoas com deficiência -----------------------------
  
  dado <- dado[, .(total_deficientes = 
                     sum(marca_deficiente, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando indicador ----------------------------------------------------
  
  dado[, d1_c2_i1 := fifelse(total_deficientes > 0, 0, 1)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c2_i1)]
  
  return(saida)
}

