## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.1. Criança, adolescentes e jovens 
# Indicador: 1.1.1. Ausência de criança

#"aux_idade" %in% colnames(base)#

base <- data.table::fread("Entradas/tab_cad_13082022_32_20221004.csv",
                          nrows = 10000,
                          select = c(
                            "d.cod_familiar_fam",
                            # 111, 112, 113, 122, 141, 142, 143 (aux_idade)
                            "p.num_nis_pessoa_atual",
                            "p.dta_nasc_pessoa",
                            "p.ref_cad",
                            # 121
                            "p.cod_deficiencia_memb",
                            # 123
                            "d.qtd_pessoa_inter_0_17_anos_fam",
                            "d.qtd_pessoa_inter_18_64_anos_fam",
                            "d.qtd_pessoa_inter_65_anos_fam",
                            # 131 151 152 162
                            "p.cod_parentesco_rf_pessoa",
                            # 132
                            "d.qtd_pessoas_domic_fam",
                            # 161
                            "p.cod_local_nascimento_pessoa",
                            # 171
                            "d.cod_familia_indigena_fam",
                            "d.ind_familia_quilombola_fam",

                            #Dimensão 3

                            # 311
                            "p.cod_trabalhou_memb",
                            "p.cod_afastado_trab_memb",

                            # 321
                            "p.cod_principal_trab_memb",

                            # renda
                            "p.val_remuner_emprego_memb",
                            "p.val_renda_bruta_12_meses_memb",
                            "p.val_renda_doacao_memb",
                            "p.val_renda_aposent_memb",
                            "p.val_renda_seguro_desemp_memb",
                            "p.val_renda_pensao_alimen_memb",
                            "p.val_outras_rendas_memb"

                          ))



# fifelse(is.na(aux_idade), NA_real_, 0))]
# sum(, na.rm = TRUE)

source("Script/IDF/IDF_calculo.R")
IDF(base = base, salario_minimo = 1212)
