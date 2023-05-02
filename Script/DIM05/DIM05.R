## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento infantil

D5 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base) & "aux_educa" %in% colnames(base)) {
    
    dado <- base
    
  } else {
    if (!("aux_idade" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_idade.R")
      
      dado <- auxiliar_idade(base)
      
    } 
    if (!("aux_educa" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_educacao.R")
      
      dado <- auxiliar_educa(base)
    }
  }
  
  # chamando as funções para calculcar os componentes -----------------------
  
  source("Script/DIM05/D5_C1.R", encoding = "UTF-8") 
  source("Script/DIM05/D5_C2.R", encoding = "UTF-8") 
  source("Script/DIM05/D5_C3.R", encoding = "UTF-8") 
  
  
  # calculando os componentes e definindo chave primária --------------------
  
  dado1 <- D5_C1(dado); setkey(dado1, d.cod_familiar_fam) 
  dado2 <- D5_C2(dado); setkey(dado2, d.cod_familiar_fam) 
  dado3 <- D5_C3(dado); setkey(dado2, d.cod_familiar_fam) 
  
  lista_componentes <- list(dado1,
                            dado2,
                            dado3)
  
  # concatenando os componentes em realção a família ------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_componentes,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando a dimensão 1 -------------------------------------------------
  
  dado[, d5 := rowMeans(as.data.table(.(d5_c1, 
                                        d5_c2,
                                        d5_c3)))]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d5)]
  
  return(saida)
}
