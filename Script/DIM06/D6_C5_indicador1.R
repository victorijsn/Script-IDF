## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.5. Acesso adequado à esgotamento sanitário
# Indicador: 6.5.1. Domicílio possui banheiro ou sanitário

D6_C5_I1 <- function(base){
  
  # selecionando as colunas que serão utilizadas ----------------------------------------------------
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam, d.cod_especie_domic_fam, d.cod_banheiro_domic_fam)]
  
  # calculando o indicador ----------------------------------------------------
  
  dado[, d6_c5_i1 := fcase(d.cod_especie_domic_fam == 1 & d.cod_banheiro_domic_fam == 1, 1L,
                           (d.cod_especie_domic_fam == 1 & d.cod_banheiro_domic_fam == 2), 0L,
                           default = 99L)]
  
  dado <- dado[, .(d6_c5_i1 = 
                     max(d6_c5_i1, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d6_c5_i1 := fcase(d6_c5_i1 == 1, 1L,
                           d6_c5_i1 == 0, 0L,
                           default = NA_integer_)]
  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6_c5_i1)]
  
  return(saida)
}