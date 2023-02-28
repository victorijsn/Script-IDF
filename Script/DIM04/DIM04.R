## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos

D4 <- function(base, linha_extrema_pobreza, linha_pobreza) {
  
  require(data.table)
  dado <- base
  
  # chamando as funções de calcular os componentes ---------------------------------------------------
  
  source("Script/DIM04/D4_C1.R", encoding = "UTF-8") # componente 01 / D4_C1
  source("Script/DIM04/D4_C2.R", encoding = "UTF-8") # componente 02 / D4_C2
  source("Script/DIM04/D4_C3.R", encoding = "UTF-8") # componente 03 / D4_C3
  source("Script/DIM04/D4_C4.R", encoding = "UTF-8") # componente 04 / D4_C4
  
  
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
  
  # Calculando os componentes e definindo chave primária ---------------------------------------------
  
  dado1 <- D4_C1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D4_C2(dado, linha_extrema_pobreza); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D4_C3(dado, linha_pobreza); setkey(dado3, d.cod_familiar_fam)
  dado4 <- D4_C4(dado); setkey(dado4, d.cod_familiar_fam)
  
  lista_componentes <- list(dado1,
                            dado2,
                            dado3,
                            dado4)
  
  # Concatenando os componentes em relação a família -------------------------------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_componentes,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # Calculando a dimensão 4 --------------------------------------------------------------------------
  
  dado[, d4 := rowMeans(as.data.table(.(d4_c1,
                                        d4_c2,
                                        d4_c3,
                                        d4_c4)))]
  
  # saída --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4)]
  
  return(saida)
}