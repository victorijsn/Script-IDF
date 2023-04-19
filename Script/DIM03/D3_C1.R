## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.1. Disponibilidade de Trabalho

D3_C1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
  source("Script/AUXILIARES/auxiliar_idade_ativa.R") 
  
  
  if (("aux_idade_ativa" %in% colnames(base)) == TRUE) {
    
    
    if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
      
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
      
    } else {
      
      dado <- auxiliar_pessoa_ocupada(base)
      
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
    }
    
  } else {
    
    if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
      
      dado <- auxiliar_idade_ativa(base)
      
      dado <- dado[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)]
      
    } else {
      
      dado <- auxiliar_idade_ativa(base)
      dado <- auxiliar_pessoa_ocupada(dado)
      dado <- base[, .(d.cod_familiar_fam,
                       aux_pessoa_ocupada,
                       aux_idade_ativa)] 
    }
  }
  
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM03/D3_C1_indicador1.R", encoding = "UTF-8") 
  source("Script/DIM03/D3_C1_indicador2.R", encoding = "UTF-8")


  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D3_C1_I1(dado); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D3_C1_I2(dado); setkey(dado2, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2)
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  # calculando o componente -------------------------------------------------
  
  dado[, d3_c1 := rowMeans(as.data.table(.(d3_c1_i1,
                                           d3_c1_i2)), 
                           na.rm = TRUE )]
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c1)]
  
  return(saida)
}