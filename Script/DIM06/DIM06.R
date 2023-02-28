## NAGI - SETADES / 2022
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 6. Condições habitacionais

D6 <- function(base){
  
  dado <- base
  
  require(data.table)
  
  # chamando as funções para calculcar os componentes -----------------------
  
  source("Script/DIM06/D6_C1.R", encoding = "UTF-8") # componente 01 / D6_C1
  source("Script/DIM06/D6_C2.R", encoding = "UTF-8") # componente 02 / D6_C2
  source("Script/DIM06/D6_C3.R", encoding = "UTF-8") # componente 03 / D6_C3
  source("Script/DIM06/D6_C4.R", encoding = "UTF-8") # componente 04 / D6_C4
  source("Script/DIM06/D6_C5.R", encoding = "UTF-8") # componente 05 / D6_C5
  source("Script/DIM06/D6_C6.R", encoding = "UTF-8") # componente 06 / D6_C6
  source("Script/DIM06/D6_C7.R", encoding = "UTF-8") # componente 07 / D6_C7
  source("Script/DIM06/D6_C8.R", encoding = "UTF-8") # componente 08 / D6_C8
  
  
  # calculando os componentes e definindo chave primária --------------------
  
  dado1 <- D6_C1(dado); setkey(dado1, d.cod_familiar_fam) 
  dado2 <- D6_C2(dado); setkey(dado2, d.cod_familiar_fam) 
  dado3 <- D6_C3(dado); setkey(dado3, d.cod_familiar_fam) 
  dado4 <- D6_C4(dado); setkey(dado4, d.cod_familiar_fam) 
  dado5 <- D6_C5(dado); setkey(dado5, d.cod_familiar_fam) 
  dado6 <- D6_C6(dado); setkey(dado6, d.cod_familiar_fam) 
  dado7 <- D6_C7(dado); setkey(dado7, d.cod_familiar_fam)
  dado8 <- D6_C8(dado); setkey(dado8, d.cod_familiar_fam)
  
  lista_componentes <- list(dado1,
                            dado2,
                            dado3, 
                            dado4,
                            dado5,
                            dado6,
                            dado7,
                            dado8)
  
  # concatenando os componentes em realção a família ------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_componentes,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando a dimensão 6 -------------------------------------------------
  
  dado[, d6 := rowMeans(as.data.table(.(d6_c1, 
                                        d6_c2,
                                        d6_c3,
                                        d6_c4,
                                        d6_c5,
                                        d6_c6, 
                                        d6_c7,
                                        d6_c8)))]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d6)]
  
  return(saida)
}