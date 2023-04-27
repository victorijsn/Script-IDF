## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Índice de Desenvolvimento Familiar
# Função Auxiliar: deflatores

# Calculando os deflatores atualizados para cada mês

# source("../AUXILIARES/auxiliar_inpc.R")

# ano_inicial <- as.numeric("2020")
# data_referencia <- as.Date("2022-01-01")
# inpc <- auxiliar_inpc()

auxiliar_deflatores <- function(ano_inicial, data_referencia, inpc){
  # Tratando o inpc
  # primeiro vamos chamar os valores no período estabelecido entre o ano inicial e a data de referência
  # depois prosseguiremos aos cálculos das deflações
  
  # TRATANDO --------------------------------------------------------
  data_inicial <- paste(ano_inicial,"-01-01",sep="")
  inpc <- data.table::as.data.table(inpc)
  data_INPC <- format(as.Date(max(inpc$date)), "%Y-%m") # ultima data disponível do INPC.
  inpc <- inpc[date <= data_referencia]
  tabela <- data.table::as.data.table(inpc)
  tabela[, ano := data.table::year(date)]
  tabela[, mes := data.table::month(date)]
  tabela[, date := format(as.Date(tabela$date), "%Y-%m")]
  data.table::setnames(tabela, c("date","value"), c("data", "inpc"))
  
  # Verificando se data de referência (dataref_dados) é menor ou igual a última data da inflação.
  
  data_referencia <- format(as.Date(data_referencia), "%Y-%m") # ano e mês de referência.
  
  if( data_referencia  > data_INPC ){
    saida <- NULL
  } else {
    
    ## CÁLCULOS ------------------------------
    
    # criando função
    func_calc <- function(tabela) {
      tamanho <- dim(tabela)[1]
      vetor <- as.matrix(c(1, replicate( tamanho - 1, NA)))
      
      for (i in 2:tamanho){
        vetor[i,1] <- vetor[i-1,1]*(1 + tabela$inpc[i]/100)
      }
      return(data.table::as.data.table(vetor)$V1)
    }
    
    # aplicando a função na tabela
    tabela[, calculo1 := func_calc(tabela)]
    
    # reordenando 
    ordem <- c("data", "ano", "mes", "inpc", "calculo1")
    tabela <- tabela[ , ..ordem]
    
    # Cálculo 2 inpc / indice base da data de referencia
    indBase <- tabela[data == data_referencia]$calculo1
    tabela[, calculo2 := calculo1/indBase]
    
    # Cálculo 3 : Deflator
    tabela[, deflator := 1/calculo2]
    
    # Saídas 
    saida <- tabela[,.(data, deflator)]
    data.table::setnames(saida, c("data", "deflator"), c("ano_mes", "deflatores"))
  }
  
  return(saida)
}