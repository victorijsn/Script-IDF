## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.2. Pessoas com deficiência e idosos
# Indicador: 1.2.3. Ausência de pessoas na família internada ou abrigada em hospital, em casa de saúde, asilo, orfanato ou estabelecimento similar

D1_C2_I3 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------

  dado <- base[, .(d.cod_familiar_fam,
                   d.qtd_pessoa_inter_0_17_anos_fam,
                   d.qtd_pessoa_inter_18_64_anos_fam,
                   d.qtd_pessoa_inter_65_anos_fam)]

  
  # tratando as NA's --------------------------------------------------------
  
  dado[, `:=` (d.qtd_pessoa_inter_0_17_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_0_17_anos_fam), 0, d.qtd_pessoa_inter_0_17_anos_fam),
               d.qtd_pessoa_inter_18_64_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_18_64_anos_fam), 0, d.qtd_pessoa_inter_18_64_anos_fam),
               d.qtd_pessoa_inter_65_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_65_anos_fam), 0, d.qtd_pessoa_inter_65_anos_fam)
               )]
  

  # somando quantidade de pessoas internadas --------------------------------
  
  dado[, qtd_pessoas_internadas := d.qtd_pessoa_inter_0_17_anos_fam + 
                    d.qtd_pessoa_inter_18_64_anos_fam + d.qtd_pessoa_inter_65_anos_fam]
  
  
  # quantidade total de pessoas internadas por família ----------------------
  
  dado <- dado[, .(total_pessoas_internadas = 
                     sum(qtd_pessoas_internadas, na.rm = TRUE) / length(qtd_pessoas_internadas)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d1_c2_i3 := fifelse(total_pessoas_internadas > 0, 0, 1)]
  
  
  # saída -------------------------------------------------------------------

  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c2_i3)]
  
  return(saida)
}

