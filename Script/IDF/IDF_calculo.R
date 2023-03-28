# função que irá chamar as 6 dimensões e calculará o idf

IDF <- function(base, 
                salario_minimo,
                linha_extrema_pobreza,
                linha_pobreza, 
                ano_inicial,
                data_referencia) {
  
  require(data.table)
  
  # chamando as funções das 6 dimensões -------------------------------------
  
  source("Script/DIM01/DIM01.R")
  # source("Script/DIM02/DIM02.R")
  source("Script/DIM03/DIM03.R")
  source("Script/DIM04/DIM04.R")
  # source("Script/DIM05/DIM05.R")
  source("Script/DIM06/DIM06.R")
  


  # calculando cada dimensão ------------------------------------------------

  dimensao1 <- D1(base) 
  # dimensao2 <- D2(base) 
  dimensao3 <- D3(base, 
                  salario_minimo)
  dimensao4 <- D4(base,
                  linha_extrema_pobreza,
                  linha_pobreza,
                  ano_inicial, 
                  data_referencia)
  # dimensao5 <- D5(base) 
  dimensao6 <- D6(base)
  
  lista_dimensoes <- list(dimensao1,
                          # dimensao2,
                          dimensao3,
                          dimensao4,
                          # dimensao5,
                          dimensao6
                          )
  
  # concatenando as 6 dimensões ---------------------------------------------

  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_dimensoes,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)

  # calculando o IDF --------------------------------------------------------
  
  dado[, idf := rowMeans(as.data.table(.(d1,
                                         # d2,
                                         d3,
                                         d4,
                                         # d5,
                                         d6
                                         )))]

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    idf)]
  
  return(saida)
}


