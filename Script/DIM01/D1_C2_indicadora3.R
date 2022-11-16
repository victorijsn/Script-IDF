## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.2. Pessoas com deficiência e idosos
# Indicador: 1.2.3. Ausência de pessoas na família internada ou abrigada em hospital, em casa de saúde, asilo, orfanato ou estabelecimento similar

D1_C2_I3 <- function(base){
  
  require(data.table)
  dado <- base

  # tratando as NA's --------------------------------------------------------
  
  dado[, `:=` (d.qtd_pessoa_inter_0_17_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_0_17_anos_fam), 0, d.qtd_pessoa_inter_0_17_anos_fam),
               d.qtd_pessoa_inter_18_64_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_18_64_anos_fam), 0, d.qtd_pessoa_inter_18_64_anos_fam),
               d.qtd_pessoa_inter_65_anos_fam = 
                 fifelse(is.na(d.qtd_pessoa_inter_65_anos_fam), 0, d.qtd_pessoa_inter_65_anos_fam)
               )]
  

  # Somando a Quantidade de pessoas Internadas ------------------------------
  
  dado[, qtd_pessoas_internadas := d.qtd_pessoa_inter_0_17_anos_fam + 
                    d.qtd_pessoa_inter_18_64_anos_fam + d.qtd_pessoa_inter_65_anos_fam]
  

  # Somando por família -----------------------------------------------------
  
  dado <- dado[, .(total_pessoas_internadas = 
                     sum(qtd_pessoas_internadas, na.rm = TRUE) / 
                     length(qtd_pessoas_internadas)), 
               by = c("d.cod_familiar_fam")]
  

  # Criando a indicadora ----------------------------------------------------
  
  dado[, d1_c2_i3 := fifelse(total_pessoas_internadas > 0, 0, 1)]
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c2_i3)]
  
  return(saida)
}

