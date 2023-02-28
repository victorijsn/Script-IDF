## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.2. Extrema Pobreza

D4_C2 <- function(base, linha_extrema_pobreza) {
  # Chamando os indicadores --------------------------------------------------------------------------
  
  require(data.table)
  dado <- base
  
  # função indicadora 4.2.1
  source("Script/DIM04/D4_C2_indicador1.R",
         encoding = "UTF-8")
  # função indicadora 4.2.2
  source("Script/DIM04/D4_C2_indicador2.R",
         encoding = "UTF-8")
  # função indicadora 4.2.3
  source("Script/DIM04/D4_C2_indicador3.R",
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
  
  dado1 <- D4_C2_I1(dado, linha_extrema_pobreza); setkey(dado1, d.cod_familiar_fam) # indicador 4.2.1
  dado2 <- D4_C2_I2(dado, linha_extrema_pobreza); setkey(dado2, d.cod_familiar_fam) # indicador 4.2.2
  dado3 <- D4_C2_I3(dado, linha_extrema_pobreza); setkey(dado3, d.cod_familiar_fam) # indicador 4.2.3
  
  lista_indicadores <- list(dado1, dado2, dado3)
  
  # juntando os indicadores --------------------------------------------------------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # Calculando o componente --------------------------------------------------------------------------
  
  dado[, d4_c2 := rowMeans(as.data.table(.(d4_c2_i1,
                                           d4_c2_i2,
                                           d4_c2_i3)),
                           na.rm = TRUE)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  # Saída --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, d4_c2)]
  
  return(saida)
}