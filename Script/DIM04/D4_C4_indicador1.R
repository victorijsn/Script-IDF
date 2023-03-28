## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.4. Capacidade de Geração de Renda
# Indicador: 4.4.1. Maior parte da renda familiar não advém de transferências


D4_C4_I1 <- function(base, ano_inicial, data_referencia){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("renda_tranferencia" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    
    if (!"deflatores" %in% ls()) {
      
      if (!"inpc" %in% ls()) {
        #auxiliar inpc
        source("Script/AUXILIARES/auxiliar_inpc.R", encoding = "UTF-8") 
        inpc <- auxiliar_inpc()
      }
      
      #auxiliar deflatores
      source("Script/AUXILIARES/auxiliar_deflatores.R", encoding = "UTF-8") 
      deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    }
    
    source("Script/AUXILIARES/auxiliar_valores.R",  encoding = "UTF-8") #auxiliar valores
    dado <- auxiliar_valores(base, deflatores)
  }
  
  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado <- dado[,.(d.cod_familiar_fam, renda_tranferencia, renda_alguma)]

  # Agrupando por código familiar e somando os valores da renda e transferência ----------------------
  
  dado <- dado[, .(renda_tranferencia = 
                     sum(renda_tranferencia, na.rm = TRUE),
                   renda_alguma = 
                     sum(renda_alguma, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Maior parte da renda familiar não advém de transferências ----------------
  
  dado[, d4_c4_i1 := fcase(renda_tranferencia < (renda_alguma/2) &
                             is.na(renda_tranferencia) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c4_i1)]
  
  return(saida)
}