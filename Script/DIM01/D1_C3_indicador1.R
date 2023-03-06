## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica
# Indicador: 1.3.1. Presença de Cônjuge


D1_C3_I1 <- function(base){

  # chamando as colunas necessárias -----------------------------------------
  
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam,
                   p.cod_parentesco_rf_pessoa)]

  # indicando se possui cônjuge ou não --------------------------------------
  
  dado[, marca_conjuge := fifelse(p.cod_parentesco_rf_pessoa == 2, 1, 0)]  
  

  # cônjuge por família ----------------------------------------------------
  
  dado <- dado[, .(possui_conjuge = 
                     sum(marca_conjuge, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam") ]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d1_c3_i1 := fifelse(possui_conjuge > 0, 1, 0)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c3_i1)]
  
  return(saida)
}