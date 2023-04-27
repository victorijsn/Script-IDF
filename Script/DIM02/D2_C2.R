## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.2. Escolaridade

D2_C2 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base)) {
    
    dado <- base[,.(d.cod_familiar_fam,
                    p.grau_instrucao,
                    aux_idade)]
  } else {
    if (!("aux_idade" %in% colnames(base))) {
      source("Script/AUXILIARES/auxiliar_idade.R")
      dado <- auxiliar_idade(base)
    }
    
    dado <- base[,.(d.cod_familiar_fam,
                    p.grau_instrucao,
                    aux_idade)]
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM02/D2_C2_indicador1.R", 
         encoding = "UTF-8") 
  source("Script/DIM02/D2_C2_indicador2.R",
         encoding = "UTF-8") 
  source("Script/DIM02/D2_C2_indicador3.R",
         encoding = "UTF-8")
  source("Script/DIM02/D2_C2_indicador4.R",
         encoding = "UTF-8")
  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D2_C2_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D2_C2_I2(dado); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D2_C2_I3(dado); setkey(dado3, d.cod_familiar_fam)
  dado4 <- D2_C2_I4(dado); setkey(dado4, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2, dado3, dado4)
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # calculando o componente -------------------------------------------------
  
  dado[, d2_c2 := rowMeans(as.data.table(.(d2_c2_i1,
                                           d2_c2_i2, 
                                           d2_c2_i3,
                                           d2_c2_i4)), 
                           na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d2_c2)]
  
  return(saida)
}