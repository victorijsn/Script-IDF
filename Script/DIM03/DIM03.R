## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho

D3 <- function(base, salario_minimo) {
  
  require(data.table)
  dado <- base
  
  # chamando as funções de calcular os componentes --------------------------
  
  source("Script/DIM03/D3_C1.R", encoding = "UTF-8") # componente 01 / D3_C1
  source("Script/DIM03/D3_C2.R", encoding = "UTF-8") # componente 02 / D3_C2
  source("Script/DIM03/D3_C3.R", encoding = "UTF-8") # componente 03 / D3_C3
  
  # calculando variável idade ativa caso ela não exista ---------------------------
  
  if ("aux_idade_ativa" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_idade_ativa.R", encoding = "UTF-8")
    dado <- auxiliar_idade_ativa(dado)
  }
  
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
  
  # calculando os componentes -----------------------------------------------
  
  dado1 <- D3_C1(dado) # componente 3.1
  dado2 <- D3_C2(dado) # componente 3.2
  dado3 <- D3_C3(dado, salario_minimo) # componente 3.3
  
  # juntando os componentes em uma única base -------------------------------
  
  dado <- 
    dado1[
      dado2, on =c("d.cod_familiar_fam")][
        dado3, on = c("d.cod_familiar_fam")]
  
  # calculando a dimensão 3 -------------------------------------------------
  
  dado[, d3 := rowMeans(as.data.table(.(d3_c1, 
                                        d3_c2,
                                        d3_c3)))]
  

  # saída -------------------------------------------------------------------

  saida <- dado[, .(d.cod_familiar_fam,
                    d3)]
  
  return(saida)
}
