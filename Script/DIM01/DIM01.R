## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade

D1 <- function(base){

  # chamando as funções de calcular os componentes --------------------------
  
  source("Script/DIM01/D1_C1.R", encoding = "UTF-8") # componente 01 / D1_C1
  source("Script/DIM01/D1_C2.R", encoding = "UTF-8") # componente 02 / D1_C2
  source("Script/DIM01/D1_C3.R", encoding = "UTF-8") # componente 03 / D1_C4
  source("Script/DIM01/D1_C4.R", encoding = "UTF-8") # componente 04 / D1_C4
  source("Script/DIM01/D1_C5.R", encoding = "UTF-8") # componente 05 / D1_C5
  source("Script/DIM01/D1_C6.R", encoding = "UTF-8") # componente 06 / D1_C6
  source("Script/DIM01/D1_C7.R", encoding = "UTF-8") # componente 07 / D1_C7


  # calculando a variável idade caso ela não exista -------------------------
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    base <- base
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") # auxiliar idade
    base <- auxiliar_idade(base)
  }
  

  # calculando os componentes -----------------------------------------------
  dado1 <- D1_C1(base) # componente 1.1
  dado2 <- D1_C2(base) # componente 1.2
  dado3 <- D1_C3(base) # componente 1.3
  dado4 <- D1_C4(base) # componente 1.4
  dado5 <- D1_C5(base) # componente 1.5
  dado6 <- D1_C6(base) # componente 1.6
  dado7 <- D1_C7(base) # componente 1.7
  

  # juntando os componentes em uma única base -------------------------------
  dado <- 
    dado1[
      dado2, on =c("d.cod_familiar_fam")][
        dado3, on = c("d.cod_familiar_fam")][
          dado4, on = c("d.cod_familiar_fam")][
            dado4, on = c("d.cod_familiar_fam")][
              dado5, on = c("d.cod_familiar_fam")][
                dado6, on = c("d.cod_familiar_fam")][
                  dado7, on = c("d.cod_familiar_fam")]
           
            

  # calculando a dimensão 1 -------------------------------------------------
  
  dado[, d1 := rowMeans(as.data.table(.(d1_c1, 
                                        d1_c2,
                                        d1_c3,
                                        d1_c4,
                                        d1_c5,
                                        d1_c6, 
                                        d1_c7)))]
  
  saida <- dado[, .(d.cod_familiar_fam, d1)]
  
  return(saida)
}
