## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Inpc

# Coletando e Tratando dados relacionados ao INPC de cada mês

auxiliar_inpc <- function(){
  
  # pedindo requisição da API SIDRA -----------------------------------------
  resposta_API <- httr::GET("https://apisidra.ibge.gov.br/values/t/1736/n1/all/v/44/p/all/d/v44%202")
  base_API <- httr::content(resposta_API)
  
  # tratamento inicial ------------------------------------------------------
  base_Tratada <- data.frame(matrix(unlist(base_API), 
                                    nrow=length(base_API), 
                                    byrow=TRUE)) 
  
  colnames(base_Tratada) <- base_Tratada[1,]
  base_Tratada <- base_Tratada[-c(1,2),]
  
  base_Tratada <- data.table::as.data.table(base_Tratada) |> janitor::clean_names()
  base_Tratada <- base_Tratada[, c("valor", "mes_codigo")]
  data.table::setnames(base_Tratada, c("valor","mes_codigo"), c("inpc","meses"))
  
  # tratando as datas -------------------------------------------------------
  base_Tratada[, mes := stringr::str_sub(meses, start = 5)]
  base_Tratada[, ano := stringr::str_sub(meses, end = 4)]
  
  base_Tratada[, date := as.Date(paste(ano, mes, '01', sep = '-'))]
  base_Tratada[, value:=as.numeric(inpc)]
  base_Tratada <- base_Tratada[, .(date,value)]
  
  # Saída -------------------------------------------------------------------
  return(base_Tratada)
  
}