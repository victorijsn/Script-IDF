# Calculo dezembro de 2022
# Objetivo: fazer o arquivo final que será lido pelo painel

# Pacotes -----------------------------------------------------------------

library(data.table)

# Base de dados -----------------------------------------------------------

base <- arrow::read_parquet("bases/saida_idf_familias.parquet", ) |> 
  data.table::setDT()

# Agregacoes --------------------------------------------------------------

pesos_munic <- base[,.(total_cadastros=sum(total_cadastros),
                       total_familias = .N),
                    by = "cod_ibge"] |> setkey(cod_ibge)

pesos_munic <- melt.data.table(base, id.vars = 1:4,
                               measure.vars = 5:101,
                               variable.name = "COD_idf",
                               value.name = "indice")

pesos_munic <- pesos_munic[!is.na(indice),.(indice=mean(indice),
                                            pesos = uniqueN(d.cod_familiar_fam)),
                           by = c("cod_ibge", "COD_idf")] |> setkey(cod_ibge)

arrow::write_parquet(pesos_munic, "bases/saida_idf_municipios.parquet")
