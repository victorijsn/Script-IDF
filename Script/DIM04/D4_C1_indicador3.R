## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.1. Existência de Renda e Despesas
# Indicador: 4.1.3. Família possui alguma renda


D4_C1_I3 <- function(base, ano_inicial, data_referencia){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("renda_alguma" %in% colnames(dado)) == TRUE) {
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
  
  dado <- dado[,.(d.cod_familiar_fam, renda_alguma)]
  
  # Agrupando por código familiar --------------------------------------------------------------------
  
  dado <- dado[, .(renda_alguma = 
                     max(renda_alguma, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Família possui alguma renda ---------------------------------------------
  
  dado[, d4_c1_i3 := fcase(renda_alguma > 0 & is.na(renda_alguma) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c1_i3)]
  
  return(saida)
}