# Calculo dezembro de 2022
# Objetivo: fazer o arquivo final que será lido pelo painel

# Pacotes -----------------------------------------------------------------

library(data.table)
library(lubridate)

# Base de dados -----------------------------------------------------------

base <- arrow::read_parquet("bases/tab_cad_24122022_32_20230117.parquet", ) |> 
  data.table::setDT()

# Parâmetros --------------------------------------------------------------

data_referencia <- ymd(max(base$d.ref_cad),tz = "America/Sao_Paulo")
ano_inicial <- year(data_referencia-years(2)) # Anos de atualização
salario_minimo <- 1302L
linha_extrema_pobreza <- 155L
linha_pobreza <- 450L

# Filtros -----------------------------------------------------------------

base <- base[d.dat_atual_fam>=data_referencia-years(2),]

# Funções auxiliares ------------------------------------------------------

auxiliares <- list.files("Script/AUXILIARES/", full.names = T)
lapply(auxiliares, source)

auxiliar_educa(base)
auxiliar_idade(base)
auxiliar_idade_ativa(base)
auxiliar_pessoa_ocupada(base)
auxiliar_rendas(base)

# Deflacionar valores monetarios
# Desativar proxy para rodar
inpc <- auxiliar_inpc()
deflatores <- auxiliar_deflatores(ano_inicial,
                                  data_referencia,
                                  inpc)
auxiliar_valores(base, deflatores)

# Limpar script para testes
rm(list = c(ls(pattern = "auxiliar_*"),"auxiliares"))

# Dim 01 - Ausência de vulnerabilidades -----------------------------------

dim1 <- list.files("Script/DIM01/", 
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim1, source)

dado1 <- D1_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D1_C2(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado3 <- D1_C3(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado4 <- D1_C4(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado5 <- D1_C5(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado6 <- D1_C6(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado7 <- D1_C7(base, com_comp = T) |> setkey(d.cod_familiar_fam)

lista_componentes <- list(dado1,
                          dado2,
                          dado3, 
                          dado4,
                          dado5,
                          dado6,
                          dado7)

dado_d1 <- merge_dados(dados = lista_componentes,
                    by = "d.cod_familiar_fam",
                    sort = TRUE)

dado_d1[, d1 := rowMeans(as.data.table(.(d1_c1, 
                                         d1_c2,
                                         d1_c3,
                                         d1_c4,
                                         d1_c5,
                                         d1_c6, 
                                         d1_c7)))]
# Limpeza
rm(list = c(ls(pattern = "D1_*"), "dim1"))


# DIM 02 - Acesso à informação --------------------------------------------

dim2 <- list.files("Script/DIM02/", 
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim2, source)

dado1 <- D2_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D2_C2(base, com_comp = T) |> setkey(d.cod_familiar_fam)

lista_componentes <- list(dado1,
                          dado2)

dado_d2 <- merge_dados(dados = lista_componentes,
                       by = "d.cod_familiar_fam",
                       sort = TRUE)

dado_d2[, d2 := rowMeans(as.data.table(.(d2_c1, 
                                         d2_c2)))]
# Limpeza
rm(list = c(ls(pattern = "D2_*"), "dim2"))

# DIM 03 - Acesso a trabalho ----------------------------------------------
dim3 <- list.files("Script/DIM03/", 
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim3, source)

dado1 <- D3_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D3_C2(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado3 <- D3_C3(base, salario_minimo, com_comp = T) |> setkey(d.cod_familiar_fam)

lista_componentes <- list(dado1,
                          dado2,
                          dado3)

dado_d3 <- merge_dados(dados = lista_componentes,
                       by = "d.cod_familiar_fam",
                       sort = TRUE)

dado_d3[, d3 := rowMeans(as.data.table(.(d3_c1, 
                                         d3_c2,
                                         d3_c3)))]

# Limpeza
rm(list = c(ls(pattern = "D3_*"), "dim3"))

# DIM 04 - Acesso a recursos ----------------------------------------------
dim4 <- list.files("Script/DIM04/",
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim4, source)

dado1 <- D4_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D4_C2(base, linha_extrema_pobreza, com_comp = T) |> setkey(d.cod_familiar_fam)
dado3 <- D4_C3(base, linha_pobreza, com_comp = T) |> setkey(d.cod_familiar_fam)
dado4 <- D4_C4(base, com_comp = T) |> setkey(d.cod_familiar_fam)

lista_componentes <- list(dado1,
                          dado2,
                          dado3,
                          dado4)

dado_d4 <- merge_dados(dados = lista_componentes,
                       by = "d.cod_familiar_fam",
                       sort = TRUE)

dado_d4[, d4 := rowMeans(as.data.table(.(d4_c1, 
                                         d4_c2,
                                         d4_c3,
                                         d4_c4)))]
# Limpeza
rm(list = c(ls(pattern = "D4_*"), "dim4"))

# DIM 05 - Desenvolvimento infantil ---------------------------------------
dim5 <- list.files("Script/DIM05/", 
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim5, source)

dado1 <- D5_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D5_C2(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado3 <- D5_C3(base, com_comp = T) |> setkey(d.cod_familiar_fam)

lista_componentes <- list(dado1,
                          dado2,
                          dado3)

dado_d5 <- merge_dados(dados = lista_componentes,
                       by = "d.cod_familiar_fam",
                       sort = TRUE)

dado_d5[, d5 := rowMeans(as.data.table(.(d5_c1, 
                                         d5_c2,
                                         d5_c3)))]
# Limpeza
rm(list = c(ls(pattern = "D5_*"), "dim5"))

# DIM06 - Condicoes habitacionais -----------------------------------------
dim6 <- list.files("Script/DIM06/",
                   pattern = "[[:alpha:]][[:alnum:]]_[[:alpha:]][[:alnum:]].R",
                   full.names = T)
lapply(dim6, source)

dado1 <- D6_C1(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado2 <- D6_C2(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado3 <- D6_C3(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado4 <- D6_C4(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado5 <- D6_C5(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado6 <- D6_C6(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado7 <- D6_C7(base, com_comp = T) |> setkey(d.cod_familiar_fam)
dado8 <- D6_C8(base, com_comp = T) |> setkey(d.cod_familiar_fam)


lista_componentes <- list(dado1,
                          dado2,
                          dado3, 
                          dado4,
                          dado5,
                          dado6,
                          dado7,
                          dado8)

dado_d6 <- merge_dados(dados = lista_componentes,
                       by = "d.cod_familiar_fam",
                       sort = TRUE)

dado_d6[, d6 := rowMeans(as.data.table(.(d6_c1, 
                                         d6_c2,
                                         d6_c3,
                                         d6_c4,
                                         d6_c5,
                                         d6_c6, 
                                         d6_c7,
                                         d6_c8)))]
# Limpeza
rm(list = c(ls(pattern = "D6_*"), "dim6", "lista_componentes",
            ls(pattern = "^dado[[:alnum:]]"),
            ls(pattern = "auxiliar_*")))

# Calculo final -----------------------------------------------------------

lista_dimensoes <- list(dado_d1,
                        dado_d2,
                        dado_d3, 
                        dado_d4,
                        dado_d5,
                        dado_d6)

IDF <- merge_dados(dados = lista_dimensoes,
                   by = "d.cod_familiar_fam",
                   sort = TRUE)

IDF[, idf := rowMeans(as.data.table(.(d1, 
                                      d2,
                                      d3,
                                      d4,
                                      d5,
                                      d6)))]

#Numero de familias sem IDF
print(IDF[is.na(idf),.N])

# Preparacao do arquivo final
info_fam <- base[,.(total_cadastros = .N,
                    mes_atualizacao = max(d.dat_atual_fam),
                    cod_ibge = max(d.cd_ibge)), 
                 by = "d.cod_familiar_fam"] |> setkey(d.cod_familiar_fam)

base_final <- merge.data.table(x = info_fam,
                               y = IDF)

base_final <- base_final[!is.na(idf)]

# Limpeza
rm(list = c(ls(pattern = "dado[[:alnum:]]*"),
            "lista_dimensoes", "info_fam","inpc",
            "deflatores", "IDF","base"))
gc()

# Exporta arquivo
arrow::write_parquet(base_final,"bases/saida_idf_familias.parquet")