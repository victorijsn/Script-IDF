# Calculo dezembro de 2022

base <- arrow::read_parquet("bases/tab_cad_24122022_32_20230117.parquet", ) |> 
  data.table::setDT()

salario_minimo <- 1302L
ano_inicial <- 2018L
data_referencia <- "2022-12-21"
linha_extrema_pobreza <- 155L
linha_pobreza <- 450L

source("Script/IDF/IDF_calculo.R", encoding = "UTF-8")

idf_teste <- IDF(base, 
                 salario_minimo,
                 ano_inicial,
                 data_referencia,
                 linha_extrema_pobreza,
                 linha_pobreza)
