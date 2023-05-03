## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.1. Existência de Renda e Despesas
# Indicador: 4.1.1. Família tem alguma despesa mensal

D4_C1_I1 <- function(base){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("despesa_total" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_inpc.R", encoding = "UTF-8") #auxiliar inpc
    source("Script/AUXILIARES/auxiliar_deflatores.R", encoding = "UTF-8") #auxiliar deflatores
    source("Script/AUXILIARES/auxiliar_valores.R", encoding = "UTF-8") #auxiliar valores
    inpc <- auxiliar_inpc()
    deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    dado <- auxiliar_valores(base, deflatores)
    }
  
  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado <- dado[,.(d.cod_familiar_fam, despesa_total)]
  
  # Agrupando por código familiar --------------------------------------------------------------------
  
  dado <- dado[, .(despesa_total = 
                     max(despesa_total, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Família tem alguma despesa mensal ----------------------------------------
  
  dado[, d4_c1_i1 := fcase(despesa_total > 0 & is.na(despesa_total) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c1_i1)]
  
  return(saida)
}