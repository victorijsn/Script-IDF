# Calculo dezembro de 2022
# Objetivo: fazer o arquivo final que será lido pelo painel

# Pacotes -----------------------------------------------------------------

library(data.table)
library(lubridate)

# Base de dados -----------------------------------------------------------

base <- arrow::read_parquet("bases/saida_idf_familias.parquet", ) |> 
  data.table::setDT()

dmunic <- fread("bases/dMunic.csv", encoding = "UTF-8") 


# Agregacoes --------------------------------------------------------------

idf_munic <- base[,lapply(.SD,mean, na.rm=T),
                   by = "cod_ibge",
                   .SDcols = c(5:101)] |> setkey(cod_ibge)

pesos_munic <- base[,.(total_cadastros=sum(total_cadastros),
                       total_familias = .N),
                    by = "cod_ibge"] |> setkey(cod_ibge)

base_munic <- merge.data.table(x = pesos_munic,
                               y = idf_munic)
