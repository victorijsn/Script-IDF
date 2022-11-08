## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica
# Indicador: 1.3.1. Presença de Cônjugue


D1_C3_I1 <- function(base){

  # chamando as colunas -----------------------------------------------------
  
  require(data.table)
  
  dado <- base[, .(d.cod_familiar_fam,
                   p.cod_parentesco_rf_pessoa)]

  # marca conjuge -----------------------------------------------------------
  dado[, marca_conjuge := fifelse(p.cod_parentesco_rf_pessoa == 2, 1, 0)]  
  

  # conjugue por familia ----------------------------------------------------
  dado <- dado[, .(tem_conjugue = sum(marca_conjuge, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam") ]
  

  # criando indicador -------------------------------------------------------
  dado[, d1_c3_i1 := fifelse(tem_conjugue > 0, 1, 0)]
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c3_i1)]
  return(saida)
}