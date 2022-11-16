## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.2. Qualidadade do posto de trabalho

D3_C2 <- function(base){
  
  require(data.table)
  dado <- base
  
  # chamando as funções para calcular os indicadores ---------------------
  
  source("Script/DIM03/D3_C2_indicadora1.R", encoding = "UTF-8") 
  source("Script/DIM03/D3_C2_indicadora2.R", encoding = "UTF-8")
  
  # marcando se a pessoa estava ocupada -------------------------------------
  
  if ("aux_pessoa_ocupada" %in% colnames(dado)) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R", encoding = "UTF-8")
    dado <- auxiliar_pessoa_ocupada(dado)
  }
  
  
  # calculando os indicadores -----------------------------------------------
  
  dado1 <- D3_C2_I1(dado)
  dado2 <- D3_C2_I2(dado)
  
  # juntando os indicadores -------------------------------------------------
  
  dado <- dado1[dado2, on = c("d.cod_familiar_fam")]
  
  # calculando o componente -------------------------------------------------
  
  dado[, d3_c2 := rowMeans(as.data.table(.(d3_c2_i1,
                                           d3_c2_i2)), 
                           na.rm = TRUE )]
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c2)]
  
  return(saida)
}