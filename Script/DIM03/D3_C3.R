## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.3. Remuneração

D3_C3 <- function(base, salario_minimo){
  
  require(data.table)
  dado <- base
  
  # chamando as funções para calcular os indicadores ---------------------
  
  source("Script/DIM03/D3_C3_indicadora1.R", encoding = "UTF-8") 
  source("Script/DIM03/D3_C3_indicadora2.R", encoding = "UTF-8")
  
  # criando a variável pessoa ocupada caso ela não exista -------------------
  
  if ("aux_pessoa_ocupada" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R", encoding = "UTF-8")
    dado <- auxiliar_pessoa_ocupada(dado)
  }
  
  # criando a variável alguma renda caso ela não exista ---------------------
  
  if ("aux_alguma_renda" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_rendas.R", encoding = "UTF-8")
    dado <- auxiliar_rendas(dado)
  }
  
  
  # calculando os indicadores -----------------------------------------------
  
  dado1 <- D3_C3_I1(dado, salario_minimo)
  dado2 <- D3_C3_I2(dado, salario_minimo)
  
  # juntando os indicadores -------------------------------------------------
  
  dado <- dado1[dado2, on = c("d.cod_familiar_fam")]
  
  # calculando o componente -------------------------------------------------
  
  dado[, d3_c3 := rowMeans(as.data.table(.(d3_c3_i1,
                                           d3_c3_i2)), 
                           na.rm = TRUE )]
  
  
  # saida -------------------------------------------------------------------
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c3)]
  
  return(saida)
}