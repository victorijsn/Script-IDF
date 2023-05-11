## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração


D1_C6 <- function(base, com_comp=F) {
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_parentesco_rf_pessoa,
                     p.cod_local_nascimento_pessoa,
                     aux_idade)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade.R") 
    
    dado <- auxiliar_idade(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_parentesco_rf_pessoa,
                     p.cod_local_nascimento_pessoa,
                     aux_idade)]
  }
  

  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM01/D1_C6_indicador1.R", encoding = "UTF-8")
  source("Script/DIM01/D1_C6_indicador2.R", encoding = "UTF-8")
  

  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D1_C6_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D1_C6_I2(dado); setkey(dado2, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2)
  
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d1_c6 := rowMeans(as.data.table(.(d1_c6_i1,
                                           d1_c6_i2)))]
  

  # saída -------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d1_c6)]
  } else {
    saida <- dado
  }
  
  return(saida)
}
