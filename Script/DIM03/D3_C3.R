## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.3. Remuneração

D3_C3 <- function(base, salario_minimo){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.val_remuner_emprego_memb,
                     aux_pessoa_ocupada)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
    
    dado <- auxiliar_pessoa_ocupada(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.val_remuner_emprego_memb,
                     aux_pessoa_ocupada)]
  }
  
  
  # chamando a função dos indicadores relacionada ao componente -------------
  
  source("Script/DIM03/D3_C3_indicador1.R", encoding = "UTF-8") 
  source("Script/DIM03/D3_C3_indicador2.R", encoding = "UTF-8")

  
  # calculando os indicadores e definindo chave primária --------------------
  
  dado1 <- D3_C3_I1(dado, salario_minimo); setkey(dado1, d.cod_familiar_fam)
  dado2 <- D3_C3_I2(dado, salario_minimo); setkey(dado2, d.cod_familiar_fam)
  
  lista_indicadores <- list(dado1, dado2)
  
  
  # relacionando os indicadores para cada família ---------------------------
  
  source("Script/AUXILIARES/merge_dados.R",
         encoding = "UTF-8")
  
  dado <- merge_dados(dados = lista_indicadores,
                      by = "d.cod_familiar_fam",
                      sort = TRUE)
  
  
  # calculando o componente -------------------------------------------------
  
  dado[, d3_c3 := rowMeans(as.data.table(.(d3_c3_i1,
                                           d3_c3_i2)), 
                           na.rm = TRUE )]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c3)]
  
  return(saida)
}