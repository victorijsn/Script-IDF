## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.3. Pobreza

D4_C3 <- function(base, linha_pobreza, com_comp=F) {
  # Chamando os indicadores --------------------------------------------------------------------------
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  dado <- base
  
  # função indicadora 4.3.1
  source("Script/DIM04/D4_C3_indicador1.R",
         encoding = "UTF-8")
  # função indicadora 4.3.2
  source("Script/DIM04/D4_C3_indicador2.R",
         encoding = "UTF-8")

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
  
  # Calculando os indicadores ------------------------------------------------------------------------
  
  dado1 <- D4_C3_I1(dado, linha_extrema_pobreza); setkey(dado1, d.cod_familiar_fam) # indicador 4.3.1
  dado2 <- D4_C3_I2(dado, linha_extrema_pobreza); setkey(dado2, d.cod_familiar_fam) # indicador 4.3.2

  lista_indicadores <- list(dado1, dado2)
  
  # juntando os indicadores --------------------------------------------------------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # Calculando o componente --------------------------------------------------------------------------
  
  dado[, d4_c3 := rowMeans(as.data.table(.(d4_c3_i1,
                                           d4_c3_i2)),
                           na.rm = TRUE)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  # Saída --------------------------------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d4_c3)]
  } else {
    saida <- dado
  }
  
  return(saida)
}