## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.4. Capacidade de Geração de Renda

D4_C4 <- function(base, ano_inicial, data_referencia) {
  # Chamando os indicadores --------------------------------------------------------------------------
  
  require(data.table)
  dado <- base
  
  # função indicadora 4.4.1
  source("Script/DIM04/D4_C4_indicador1.R",
         encoding = "UTF-8")

  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("despesa_total"  %in% colnames(dado)) == TRUE) {
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
  
  # Calculando os indicadores ------------------------------------------------------------------------
  
  dado1 <- D4_C4_I1(dado, ano_inicial, data_referencia); setkey(dado1, d.cod_familiar_fam) # indicador 4.4.1
  
  # juntando os indicadores --------------------------------------------------------------------------
  
  dado <- dado1
  
  # Calculando o componente --------------------------------------------------------------------------
  
  dado[, d4_c4 := rowMeans(as.data.table(.(d4_c4_i1)),
                           na.rm = TRUE)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  # Saída --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, d4_c4)]
  
  return(saida)
}