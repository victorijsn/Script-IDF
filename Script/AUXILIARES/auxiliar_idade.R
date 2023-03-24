## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Idade

auxiliar_idade <- function(base){

  # chamando a base ---------------------------------------------------------
  
  require(data.table)
  
  dado <- base
  
  dado[, p.dta_nasc_pessoa := format(p.dta_nasc_pessoa, "%Y-%m-%d")]


  # calculando a idade em anos e em dias ------------------------------------
  
  dado[, aux_idade:= lubridate::time_length(
    lubridate::interval(lubridate::ymd(p.dta_nasc_pessoa),
                        lubridate::ymd(p.ref_cad)), "year")]


  # validação ---------------------------------------------------------------
  
  # analise <- dado[, .(qntd_indv_acima_130 = sum(idade > 120),
  #                     qntd_indv_idade_neg = sum(idade < 0),
  #                     qntd_indv_NA = sum(is.na(idade) == TRUE)
  #                     )]
  # analise[, status := rowSums(as.data.table(.SD))]
  #
  # if (analise$status == 0) {
  #   return(dado)
  # } else {
  #   print("Output não está em condições aceitáveis")
  # }
  

  # saida -------------------------------------------------------------------
  
  saida <- dado
  
  return(saida)
}
