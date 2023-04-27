## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade

D1 <- function(base){

  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
  }
  

  # chamando as funções para calculcar os componentes -----------------------
  
  source("Script/DIM01/D1_C1.R", encoding = "UTF-8") # componente 01 / D1_C1
  source("Script/DIM01/D1_C2.R", encoding = "UTF-8") # componente 02 / D1_C2
  source("Script/DIM01/D1_C3.R", encoding = "UTF-8") # componente 03 / D1_C4
  source("Script/DIM01/D1_C4.R", encoding = "UTF-8") # componente 04 / D1_C4
  source("Script/DIM01/D1_C5.R", encoding = "UTF-8") # componente 05 / D1_C5
  source("Script/DIM01/D1_C6.R", encoding = "UTF-8") # componente 06 / D1_C6
  source("Script/DIM01/D1_C7.R", encoding = "UTF-8") # componente 07 / D1_C7
  

  # calculando os componentes e definindo chave primária --------------------
  
  dado1 <- D1_C1(dado); setkey(dado1, d.cod_familiar_fam) 
  dado2 <- D1_C2(dado); setkey(dado2, d.cod_familiar_fam) 
  dado3 <- D1_C3(dado); setkey(dado3, d.cod_familiar_fam) 
  dado4 <- D1_C4(dado); setkey(dado4, d.cod_familiar_fam) 
  dado5 <- D1_C5(dado); setkey(dado5, d.cod_familiar_fam) 
  dado6 <- D1_C6(dado); setkey(dado6, d.cod_familiar_fam) 
  dado7 <- D1_C7(dado); setkey(dado7, d.cod_familiar_fam) 
  
  lista_componentes <- list(dado1,
                            dado2,
                            dado3, 
                            dado4,
                            dado5,
                            dado6,
                            dado7)
  
  # concatenando os componentes em realção a família ------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_componentes,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
            

  # calculando a dimensão 1 -------------------------------------------------
  
  dado[, d1 := rowMeans(as.data.table(.(d1_c1, 
                                        d1_c2,
                                        d1_c3,
                                        d1_c4,
                                        d1_c5,
                                        d1_c6, 
                                        d1_c7)))]
  

  # saída -------------------------------------------------------------------

  saida <- dado[, .(d.cod_familiar_fam,
                    d1)]
  
  return(saida)
}
