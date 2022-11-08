## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica


D1_C3 <- function(base) {
  
  # função indicadora 1.3.1
  source("Script/DIM01/D1_C3_indicadora1.R", encoding = "UTF-8")
  # função indicadora 1.3.2
  source("Script/DIM01/D1_C3_indicadora2.R", encoding = "UTF-8")
  
  dado1 <- D1_C3_I1(base)
  dado2 <- D1_C3_I2(base)
  
  # juntando as bases -------------------------------------------------------
  dado <- dado1[dado2, on = c("d.cod_familiar_fam")]

  # calculando o componente -------------------------------------------------
  dado[, d1_c3 := rowMeans(as.data.table(.(d1_c3_i1,
                                           d1_c3_i2)), na.rm = TRUE)]
  
  # validação ---------------------------------------------------------------


  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c3)]
  return(saida)
}
