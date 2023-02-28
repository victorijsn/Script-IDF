## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.1. Propriedade do domicílio 
# Indicador: 6.1.3. Domicílio particular permanente

D6_C1_I3 <- function(base){
  
  # selecionando as colunas que serão utilizadas ----------------------------------------------------
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam, d.cod_especie_domic_fam)]
  
  # calculando o indicador ----------------------------------------------------
  
  dado[, d6_c1_i3 := fcase(d.cod_especie_domic_fam  == 1, 1L,
                           d.cod_especie_domic_fam %in% c(2:3), 0L,
                           default = 99L)]
  
  dado <- dado[, .(d6_c1_i3 = 
                     max(d6_c1_i3, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d6_c1_i3 := fcase(d6_c1_i3  == 1, 1L,
                           d6_c1_i3 == 0, 0L,
                           default = NA_integer_)]
  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6_c1_i3)]
  
  return(saida)
}