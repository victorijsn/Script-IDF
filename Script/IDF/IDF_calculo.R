# função que irá chamar as 6 dimensões e calculará o idf

IDF <- function(base, 
                salario_minimo) {
  
  require(data.table)
  
  # chamando as funções das 6 dimensões -------------------------------------
  
  source("Script/DIM01/DIM01.R")
  # source("Script/DIM02/DIM02.R")
  source("Script/DIM03/DIM03.R")
  # source("Script/DIM04/DIM04.R")
  # source("Script/DIM05/DIM05.R")
  # source("Script/DIM06/DIM06.R")
  


  # calculando cada dimensão ------------------------------------------------

  dimensao1 <- D1(base) 
  # dimensao2 <- D2(base) 
  dimensao3 <- D3(base, salario_minimo)
  # dimensao4 <- D4(base) 
  # dimensao5 <- D5(base) 
  # dimensao6 <- D6(base) 
  
  
  # concatenando as 6 dimensões ---------------------------------------------

  dado <- 
    dimensao1[dimensao3, on = c("d.cod_familiar_fam")]

  # calculando o IDF --------------------------------------------------------
  
  dado[, idf := rowMeans(as.data.table(.(d1,
                                         # d2,
                                         d3
                                         # d4,
                                         # d5,
                                         # d6
                                         )))]

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    idf)]
  return(saida)
}


