## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.1. Propriedade do domicílio 
# Indicador: 6.1.1. Domicílio particular ou coletivo

D6_C1_I1 <- function(base){
  
  # selecionando as colunas que serão utilizadas ----------------------------------------------------
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam, d.cod_especie_domic_fam)]
  
  # calculando o indicador ----------------------------------------------------
  
  dado[, d6_c1_i1 := fcase(d.cod_especie_domic_fam %in% c(1:3), 1L,
                           default = 99L)]
  
  dado <- dado[, .(d6_c1_i1 = 
                     max(d6_c1_i1, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d6_c1_i1 := fcase(d6_c1_i1 == 1, 1L,
                               default = NA_integer_)]

  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6_c1_i1)]
  
  return(saida)
}