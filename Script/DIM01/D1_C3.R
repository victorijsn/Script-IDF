## NAGI - SETADES / 2022
## Responsável: Vitória Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.3. Dependência Econômica


D1_C3 <- function(base) {
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade_ativa" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_parentesco_rf_pessoa,
                     aux_idade_ativa)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_idade_ativa.R") 
    
    dado <- auxiliar_idade_ativa(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_parentesco_rf_pessoa,
                     aux_idade_ativa)]
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM01/D1_C3_indicador1.R", 
         encoding = "UTF-8")
  source("Script/DIM01/D1_C3_indicador2.R", 
         encoding = "UTF-8")
  
  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D1_C3_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D1_C3_I2(dado); setkey(dado2, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2)
  
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d1_c3 := rowMeans(as.data.table(.(d1_c3_i1,
                                           d1_c3_i2)), na.rm = TRUE)]
  

  # saida -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d1_c3)]
  return(saida)
}
