## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais
# Componente: 6.2. Déficit habitacional  
# Indicador: 6.2.1. Densidade de até 2 moradores por dormitório

############ OBSERVAÇÃO - INDICADOR PRECISA SER MELHOR DEFINIDO !!!

D6_C2_I1 <- function(base){
  
  # selecionando as colunas que serão utilizadas ----------------------------------------------------
  require(data.table)
  dado <- base[, .(d.cod_familiar_fam,
                   d.cod_especie_domic_fam,
                   d.qtd_comodos_dormitorio_fam,
                   d.qtd_pessoas_domic_fam)]
  
  # calculando colunas auxiliares ----------------------------------------------------
  
  dado[, densidade := fifelse((d.qtd_pessoas_domic_fam < 0) | (d.qtd_comodos_dormitorio_fam <= 0), NA_real_,
                            (d.qtd_pessoas_domic_fam / d.qtd_comodos_dormitorio_fam))]
  # calculando o indicador ----------------------------------------------------
  
  dado[, d6_c2_i1 :=  fcase(d.cod_especie_domic_fam == 1 & densidade <= 2 & is.na(densidade)==FALSE, 1L,
                   (is.na(d.cod_especie_domic_fam) == TRUE & is.na(densidade) == TRUE) | d.cod_especie_domic_fam != 1, 99L,
                   default = 0L)]
              
  dado <- dado[, .(d6_c2_i1 = 
                     max(d6_c2_i1, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d6_c2_i1 := fcase(d6_c2_i1 == 1, 1L,
                           d6_c2_i1 == 0, 0L,
                           default = NA_integer_)]
  
  
  # validação ---------------------------------------------------------------
  
  
  
  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6_c2_i1)]
  
  return(saida)
}