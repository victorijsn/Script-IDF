## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.7. Acesso a eletricidade
# Indicador: 6.7.2. Acesso à eletricidade

D6_C7_I2 <- function(base){
  
  # selecionando as colunas que serão utilizadas ----------------------------------------------------
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam, d.cod_especie_domic_fam, d.cod_iluminacao_domic_fam)]
  
  # calculando o indicador ----------------------------------------------------
  
  dado[, d6_c7_i2 := fcase(d.cod_especie_domic_fam == 1 & d.cod_iluminacao_domic_fam %in% c(1:3), 1L,
                           (d.cod_especie_domic_fam == 1 & is.na(d.cod_iluminacao_domic_fam) == TRUE) | d.cod_especie_domic_fam != 1, 99L,
                           default = 0L)]

  dado <- dado[, .(d6_c7_i2 = 
                     max(d6_c7_i2, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d6_c7_i2 := fcase(d6_c7_i2 == 1, 1L,
                           d6_c7_i2 == 0, 0L,
                           default = NA_integer_)]
  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6_c7_i2)]
  
  return(saida)
}