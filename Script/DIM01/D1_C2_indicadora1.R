## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.2. Pessoas com deficiência e idosos
# Indicador: 1.2.1. Ausência de pessoas com deficiência

D1_C2_I1 <- function(base) {
  
  dado <- base
  
  # marca se a pessoa tem deficiência ---------------------------------------
  dado[, marca_deficiente := fifelse(p.cod_deficiencia_memb == 1, 1, 
                                fifelse(is.na(p.cod_deficiencia_memb), NA_real_, 0))]
  

  # soma quantidade de pessoas com deficiência por pessoa -------------------
  dado <- dado[, .(total_deficientes = sum(marca_deficiente, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # criando indicador -------------------------------------------------------
  dado[, d1_c2_i1 := fifelse(total_deficientes > 0, 0, 1)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c2_i1)]
  
  return(saida)
}

