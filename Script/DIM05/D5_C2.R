## NAGI - SETADES / 2023
## Responsável: Victor Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 5. Desenvolvimento Infantil
# Componente: 5.2. Acesso à escola

D5_C2 <- function(base, com_comp=F){
  
  require(data.table)
  
  com_comp <- com_comp # opção para que na saída venham os indicadores
  
  # chamando as colunas necessárias -----------------------------------------
  
  if ("aux_idade" %in% colnames(base)) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.ind_frequenta_escola_memb,
                     aux_idade)]
    
    dado[,idade_arred:=floor(aux_idade)]
    
  } else {
    
    if (!("aux_idade" %in% colnames(base))) {
      
      source("Script/AUXILIARES/auxiliar_idade.R") 
      
      dado <- auxiliar_idade(base)
      
      dado <- base[, .(d.cod_familiar_fam,
                       p.ind_frequenta_escola_memb,
                       aux_idade)]
      
      dado[,idade_arred:=floor(aux_idade)]
    }
  }
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM05/D5_C2_indicador1.R", 
         encoding = "UTF-8") 
  source("Script/DIM05/D5_C2_indicador2.R",
         encoding = "UTF-8") 
  source("Script/DIM05/D5_C2_indicador3.R",
         encoding = "UTF-8")
  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D5_C2_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D5_C2_I2(dado); setkey(dado2, d.cod_familiar_fam)
  dado3 <- D5_C2_I3(dado); setkey(dado3, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2, dado3)
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d5_c2 := rowMeans(as.data.table(.(d5_c2_i1,
                                           d5_c2_i2, 
                                           d5_c2_i3)), 
                           na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  if (com_comp==F) {
    saida <- dado[, .(d.cod_familiar_fam, 
                      d5_c2)]
  } else {
    saida <- dado
  }
  
  return(saida)
}
