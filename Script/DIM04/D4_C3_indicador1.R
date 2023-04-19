## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.3. Pobreza
# Indicador: 4.3.1. Despesa familiar per capita superior a linha da pobreza

D4_C3_I1 <- function(base, linha_pobreza){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("despesa_total" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_inpc.R") #auxiliar inpc
    source("Script/AUXILIARES/auxiliar_deflatores.R") #auxiliar deflatores
    source("Script/AUXILIARES/auxiliar_valores.R") #auxiliar valores
    inpc <- auxiliar_inpc()
    deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    dado <- auxiliar_valores(base, deflatores)
  }
  
  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado <- dado[,.(d.cod_familiar_fam, despesa_total, d.qtd_pessoas_domic_fam)]
  
  # Criando a coluna pessoas no domicilio ------------------------------------------------------------
  
  dado[, pessoas_domicilio := .N, by = c("d.cod_familiar_fam")]
  
  # Agrupando por código familiar e calculando a despesa percapita -----------------------------------
  
  dado <- dado[, .(despesa_percapita = 
                     max(despesa_total/pessoas_domicilio, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Despesa familiar per capita superior a linha de extrema pobreza ----------
  
  dado[, d4_c3_i1 := fcase(despesa_percapita > linha_pobreza &
                             is.na(despesa_percapita) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c3_i1)]
  
  return(saida)
}