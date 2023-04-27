## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.1. Trabalho precoce

D5_C1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & 
      "aux_pessoa_ocupada" %in% colnames(base)) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_trabalho_infantil_pessoa,
                     aux_idade,
                     aux_pessoa_ocupada)]
    
  } else {
    
    if (!("aux_idade" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_idade.R") 
      
      dado <- auxiliar_idade(base)
      
    }
    
    if (!("aux_pessoa_ocupada" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
      
      dado <- auxiliar_pessoa_ocupada(base)
      
    }
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_trabalho_infantil_pessoa,
                     aux_idade,
                     aux_pessoa_ocupada)]
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM05/D5_C1_indicador1.R", 
         encoding = "UTF-8") 
  source("Script/DIM05/D5_C1_indicador2.R",
         encoding = "UTF-8") 
  source("Script/DIM05/D5_C1_indicador3.R",
         encoding = "UTF-8")
  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D5_C1_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D5_C1_I2(dado); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D5_C1_I3(dado); setkey(dado3, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2, dado3)
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d5_c1 := rowMeans(as.data.table(.(d5_c1_i1,
                                           d5_c1_i2, 
                                           d5_c1_i3)), 
                           na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d5_c1)]
  
  return(saida)
}
