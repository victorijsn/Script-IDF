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
  
  base_Tratada <- data.table::as.data.table(base_Tratada)
  base_Tratada <- base_Tratada[, c("Valor", "Mês")]
  data.table::setnames(base_Tratada, c("Valor","Mês"), c("inpc","meses"))
  
  # tratando as datas -------------------------------------------------------
  colunas_mes_ano <- stringr::str_split(base_Tratada$meses,
                                        pattern = " ",
                                        simplify = T)
  base_Tratada[, mes := colunas_mes_ano[,1]]
  base_Tratada[, ano := colunas_mes_ano[,2]]
  base_Tratada[, mes_num := data.table::fcase(
    mes == "janeiro", 1L,
    mes == "fevereiro", 2L,
    mes == "março", 3L,
    mes == "abril", 4L,
    mes == "maio", 5L,
    mes == "junho", 06L,
    mes == "julho", 07L,
    mes == "agosto", 08L,
    mes == "setembro", 09L,
    mes == "outubro", 10L,
    mes == "novembro", 11L,
    mes == "dezembro", 12L,
    default = NA_integer_
  )]
  base_Tratada[, date := as.Date(paste(ano, mes_num, '01', sep = '-'))]
  base_Tratada[, value:=as.numeric(inpc)]
  base_Tratada <- base_Tratada[, .(date,value)]
  
  # Saída -------------------------------------------------------------------
  return(base_Tratada)
  
}