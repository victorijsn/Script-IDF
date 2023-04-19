## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.1. Existência de Renda e Despesas
# Indicador: 4.1.2. Família possui alguma renda, excluindo-se as transferências


D4_C1_I2 <- function(base){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("renda_sem_tranferencia" %in% colnames(dado)) == TRUE) {
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
  
  dado <- dado[,.(d.cod_familiar_fam, despesa_total, renda_sem_tranferencia)]
  
  # Agrupando por código familiar --------------------------------------------------------------------
  
  dado <- dado[, .(despesa_total = 
                     max(despesa_total, na.rm = TRUE),
                   renda_sem_tranferencia = 
                     max(renda_sem_tranferencia, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Família possui alguma renda, excluindo-se as transferências --------------
  
  dado[, d4_c1_i2 := fcase((renda_sem_tranferencia > 0 | is.na(renda_sem_tranferencia) == TRUE) &
                             is.na(despesa_total) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c1_i2)]
  
  return(saida)
}