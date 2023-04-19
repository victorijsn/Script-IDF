## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 


D1_C1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     aux_idade)]
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------

  source("Script/DIM01/D1_C1_indicador1.R", 
         encoding = "UTF-8") 
  source("Script/DIM01/D1_C1_indicador2.R",
         encoding = "UTF-8") 
  source("Script/DIM01/D1_C1_indicador3.R",
         encoding = "UTF-8")
  

  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D1_C1_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D1_C1_I2(dado); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D1_C1_I3(dado); setkey(dado3, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2, dado3)
  
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")

  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d1_c1 := rowMeans(as.data.table(.(d1_c1_i1,
                                           d1_c1_i2, 
                                           d1_c1_i3)), 
                          na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c1)]
  
  return(saida)
}




