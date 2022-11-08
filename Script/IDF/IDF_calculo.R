# função que irá chamar as 6 dimensões e calculará o idf

IDF <- function(base){
  source("Script/DIM01/DIM01.R")
  # source("Script/DIM02/DIM02.R")
  # source("Script/DIM03/DIM03.R")
  # source("Script/DIM04/DIM04.R")
  # source("Script/DIM05/DIM05.R")
  # source("Script/DIM06/DIM06.R")
  
  saida <- D1(base) # MODIFICAR QUANDO FOR ESTRUTURAR AS OUTRAS DIMENSÕES
  
  return(saida)
}

IDF(base = base)

