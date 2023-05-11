## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.4. Capacidade de Geração de Renda

D4_C4 <- function(base, com_comp=F) {
  # Chamando os indicadores --------------------------------------------------------------------------
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  dado <- base
  
  # função indicadora 4.4.1
  source("Script/DIM04/D4_C4_indicador1.R",
         encoding = "UTF-8")

  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("renda_tranferencia" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_inpc.R") #auxiliar inpc
    source("Script/AUXILIARES/auxiliar_deflatores.R") #auxiliar deflatores
    source("Script/AUXILIARES/auxiliar_valores.R") #auxiliar valores
    inpc <- auxiliar_inpc()
    deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    dado <- auxiliar_valores(base, deflatores)
  }
  
  # Calculando os indicadores ------------------------------------------------------------------------
  
  dado1 <- D4_C4_I1(dado); setkey(dado1, d.cod_familiar_fam) # indicador 4.4.1
  
  # juntando os indicadores --------------------------------------------------------------------------
  
  dado <- dado1
  
  # Calculando o componente --------------------------------------------------------------------------
  
  dado[, d4_c4 := rowMeans(as.data.table(.(d4_c4_i1)),
                           na.rm = TRUE)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  # Saída --------------------------------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d4_c2)]
  } else {
    saida <- dado
  }
  
  return(saida)
}