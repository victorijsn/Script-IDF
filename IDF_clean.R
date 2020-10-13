#' Indice de Desenvolvimento Familiar - IDF
#'
#' Esta função calcula o IDF a partir do Cadastro Único.
#'
#' @param ExtPobreza Extrema pobreza (em reiais)
#' @param SalarioMin Salário mínimo (em reais)
#' @param tudo Matriz extraída do CadUnico
#' @param Ano_inicial Ano inicial para selecionar universo.
#' @param Ano_final Ano final para selecionar universo.
#' @param Escolhe_base Ano base para inflacionar ("deflacionar") os valores monetários.
#' @param LimSupPobreza Limite superior da pobreza.
#'
#' @return Matriz que contém: (i) todas as variáveis necessárias para o cálculo do IDF; (ii) IDF estimado ?!?!
#' @export
#'
#' @examples
IDF_clean <- function(ExtPobreza = 249.5, SalarioMin = 998, tudo, Ano_inicial= 2016, Ano_final = 2019, Escolhe_base = "2019-03", LimSupPobreza = 499){
        # ExtPobraza: Extrema pobreza.
        # SalarioMin: Salário Mínimo.
        # tudo: matriz completa: (base pessoas e base domicílios)
        # ano_inicial: Limite inferior para selecionar universo. Veja PRIMEIRO FILTRO
        # ano_final: Limite superior para selecionar universo.   Veja PRIMEIRO FILTRO
        # escolhe_base: mês e ano base para calcular os deflatores. Formato: YYYY-MM.
        # LimSupPobreza: Limite superior da linha da pobreza: (Veja R7: Despesa familiar per capita superior a linha de pobreza)

##Inicio do código
# trocando d.cod_familiar_fam (nome no arquivo original) por cod_familiar_fam
t <- proc.time()
bd <- rename(tudo,  cod_familiar_fam = d.cod_familiar_fam)
#bd <- tudo
### Manipulando DATAS
bd$nasc <- bd$dta_nasc_pessoa
bd$dcadas <- bd$dat_atual_fam
bd$dentrada <- bd$dat_cadastramento_fam

################################ PRIMEIRO FILTRO ##############################################
### *Selecionando universo: pessoas com cadastro entre 2011,e 2015 ou
# com atualizacao neste periodo (ultimos 3 anos)
b <- filter(bd, year(bd$dcadas) >= Ano_inicial & year(bd$dcadas) <= Ano_final)

# Criando variável idade - linha 76
b$diasp <- time_length(interval(b$nasc,b$dcadas),"days") #b$dcadas - b$nasc # numero de dias entre duas datas #time_length
b$idade <- floor(time_length(interval(b$nasc,b$dcadas),"years"))# b$diasp/365). Esse linha nao bate por causa dos anos bissextos. Porém é o mais adequado.
#b$idade <- floor(b$diasp/365)
b$idade <- if_else(b$idade < 0, NA_real_,
                   if_else(b$idade >= 120 , NA_real_, b$idade))

# VERIFICAR problema cadastro -- veja linha 79-80

#b$pes_cad <- matrix(0,dim(b)[1],dim(b)[2])
b$pes_cad <- if_else((b$cod_est_cadastral_memb==3 | b$cod_est_cadastral_memb==6),1,0)

################################ SEGUNDO FILTRO ##############################################
b <- filter(b, b$pes_cad==1)
b$index <- 1:dim(b)[1]


##LINHA 87
# AUX_V1 - CRIANCAS DE 0 A 6 ANOS
b$aux_v1 <- if_else((b$idade >= 0 & b$idade <= 6),1,if_else(is.na(b$idade), NA_real_, 0))

# AUX_V2 - CRIANCAS DE 0 A 14 ANOS
b$aux_v2 <- if_else((b$idade >= 0 & b$idade <= 14),1,if_else(is.na(b$idade),NA_real_,0))

# AUX_V3 - CRIANCAS DE 0 A 17 ANOS
b$aux_v3 <- if_else((b$idade >= 0 & b$idade <= 17),1,if_else(is.na(b$idade),NA_real_,0))

# AUX_V4:PORTADORES DE DEFICIENCIA E IDOSOS
b$aux_v4 <- if_else((b$cod_deficiencia_memb == 1),1,if_else(is.na(b$cod_deficiencia_memb),NA_real_,0))

# AUX_V5: IDOSOS DE 65 ANOS OU MAIS
b$aux_v5 <- if_else((b$idade >= 65),1,if_else(is.na(b$idade), NA_real_, 0))

#OBS: codigo STATA nao possui V6 ! Nomenclatura segue codigo original

# AUX_V7: PRESENCA DO CONJUGE
b$aux_v7 <- if_else((b$cod_parentesco_rf_pessoa == 2),1,if_else(is.na(b$cod_deficiencia_memb),NA_real_,0))

# AUX_V8A: TOTAL DE MEMBROS EM IDADE ATIVA (15 A 64 ANOS)
b$aux_v8a <- if_else((b$idade >= 15 & b$idade <= 64),1,if_else(is.na(b$idade), NA_real_, 0))

# CRIANDO VARIAVEL PARENTESCO_RF_2
b$parentesco_rf_2 <- if_else(b$cod_parentesco_rf_pessoa >= 1 & b$cod_parentesco_rf_pessoa<=10,1,
                             if_else(is.na(b$cod_parentesco_rf_pessoa), NA_real_, 11))

# AUX_V8B - Total de membros
b$aux_v8b <- if_else((b$parentesco_rf_2 >= 1 & b$parentesco_rf_2 <= 11),1,
                       if_else(is.na(b$cod_parentesco_rf_pessoa), NA_real_, 0))

# AUX_V9: PESSOAS COM 15 ANOS OU MAIS
b$aux_v9 <- if_else(b$idade >= 15,1,if_else(is.na(b$idade), NA_real_, 0))

# AUX_V10: PESSOAS COM 18 ANOS OU MAIS
b$aux_v10 <- if_else(b$idade >= 18,1,if_else(is.na(b$idade), NA_real_, 0))

# AUX_V11: PESSOAS COM 21 ANOS OU MAIS
b$aux_v11 <- if_else(b$idade >= 21,1,if_else(is.na(b$idade), NA_real_, 0))

# AUX_V12: PESSOAS COM ATE 9 ANOS QUE NAO SEJA FILHO OU ENTEADO DO RF
b$aux_v12 <- if_else(   b$idade >= 0 & b$idade <= 9 &
                        ((b$cod_parentesco_rf_pessoa >= 1 & b$cod_parentesco_rf_pessoa <= 2) |
                        (b$cod_parentesco_rf_pessoa >= 5 & b$cod_parentesco_rf_pessoa <= 11)), 1,
                        if_else(is.na(b$idade) | is.na(b$cod_parentesco_rf_pessoa), NA_real_,0) )

# AUX_V13: PESSOAS COM ATE 9 ANOS (INCLUSIVE) QUE SEJA OUTRO PARENTE OU NAO PARENTE DO RF
b$aux_v13 <- if_else(b$idade >= 0 & b$idade <= 9 &
                     b$cod_parentesco_rf_pessoa >= 10 & b$cod_parentesco_rf_pessoa <= 11,1,
                      if_else(is.na(b$idade) | is.na(b$cod_parentesco_rf_pessoa),NA_real_,0))

# AUX_V14: RESPONSAVEL PELA FAMILIA NASCEU NESSE MUNICIPIO
b$aux_v14 <- if_else(b$cod_parentesco_rf_pessoa==1 & b$cod_local_nascimento_pessoa==1,1,
                     if_else(is.na(b$cod_parentesco_rf_pessoa) | is.na(b$cod_local_nascimento_pessoa),NA_real_,0))

# AUX_V15: CRIANCA OU ADOLESCENTE COM ATE 14 (INCLUSIVE) ANOS QUE NASCEU EM OUTRO MUNICIPIO
b$aux_v15 <- if_else(b$idade >= 0  & b$idade <= 14 &
                     b$cod_local_nascimento_pessoa >= 2 & b$cod_local_nascimento_pessoa<=3,1,
                      if_else(is.na(b$idade) | is.na(b$cod_local_nascimento_pessoa),NA_real_,0))

## CRIANDO A VARIAVEL ANALFABETO - LINHA 167
b$analf <- if_else(b$cod_sabe_ler_escrever_memb==2,1,
                   if_else(b$cod_sabe_ler_escrever_memb==1,0,NA_real_))

# AUX_D9: ADOLESCENTE COM 15 A 17 ANOS ANALFABETO
b$aux_d9 <- if_else((b$idade >=15 & b$idade<=17 & b$analf == 1),1,
                    if_else(is.na(b$idade) | is.na(b$analf),NA_real_,0))

################################ CRIANDO A VARIAVEL EDUCA ###########################################

# Creche, pre-escola, C.A.: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2  &
                    b$cod_curso_frequenta_memb  >= 1 & b$cod_curso_frequenta_memb  <= 3,0,NA_real_)

# Fundamental: educa: serie-1 (fundamental antigo)
b$educa <-  if_else(b$ind_frequenta_escola_memb >=1 & b$ind_frequenta_escola_memb<=2    &
                      b$cod_curso_frequenta_memb ==4  & b$cod_ano_serie_frequenta_memb>=1 &
                      b$cod_ano_serie_frequenta_memb<=8, b$cod_ano_serie_frequenta_memb - 1,b$educa)

# Fundamental nao seriado: educa=0
b$educa <-  if_else(b$ind_frequenta_escola_memb >=1 & b$ind_frequenta_escola_memb <=2 &
                      b$cod_curso_frequenta_memb == 4 & b$cod_ano_serie_frequenta_memb == 10, 0, b$educa)

#*Fundamental novo 1o ano: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2 &
                   b$cod_curso_frequenta_memb == 5 & b$cod_ano_serie_frequenta_memb == 1, 0, b$educa)


# Fundamental novo 2o ao 9o ano: educa=serie-2
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <=2     &
                     b$cod_curso_frequenta_memb  == 5 & b$cod_ano_serie_frequenta_memb >= 2 &
                     b$cod_ano_serie_frequenta_memb <= 9, b$cod_ano_serie_frequenta_memb-2,b$educa)

#*Fundamental especial: educa=serie-1
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2 &
                     b$cod_curso_frequenta_memb  == 6 & b$cod_ano_serie_frequenta_memb>=1 &
                     b$ cod_ano_serie_frequenta_memb <=8, b$cod_ano_serie_frequenta_memb-1,b$educa)

#*Fundamental especial nao seriado: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb == 6  & b$cod_ano_serie_frequenta_memb==10,0,b$educa)

#*Ensino medio 1a serie: educa=8
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb  >= 7 & b$cod_curso_frequenta_memb <=8 &
                     b$cod_ano_serie_frequenta_memb==1,8,b$educa)

#*Ensino medio 2a serie: educa=9
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb  >= 7 & b$cod_curso_frequenta_memb <=8 &
                     b$cod_ano_serie_frequenta_memb==2,9,b$educa)

# *Ensino medio 3a / 4a serie: educa=10
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2 &
                     b$cod_curso_frequenta_memb  >= 7 & b$cod_curso_frequenta_memb <= 8  &
                     (b$cod_ano_serie_frequenta_memb==3 | b$cod_ano_serie_frequenta_memb==4),
                     10,b$educa)

#*Ensino medio nao seriado: educa=8
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb  >= 7 & b$cod_curso_frequenta_memb <=8 &
                     b$cod_ano_serie_frequenta_memb==10,8,b$educa)

#*EJA primeiro ciclo: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb>=1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb==9,0,b$educa)

#*EJA segundo ciclo: educa=4
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2 &
                     b$cod_curso_frequenta_memb==10,4,b$educa)
#*EJA medio: educa=8
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb==11,8,b$educa)

#*Alfabetizacao de adultos: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb <= 2 &
                   b$cod_curso_frequenta_memb==12,0,b$educa)

#*Superior, aperfeicoamento, mestrado, doutorado: educa=13
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb==13,13,b$educa)

#*Pre-vestibular: educa=11
b$educa <- if_else(b$ind_frequenta_escola_memb >= 1 & b$ind_frequenta_escola_memb<=2 &
                     b$cod_curso_frequenta_memb==14,11,b$educa)

#**NAO FREQUENTRA MAS JA FREQUENTOU ESCOLA

#*Creche, pre, C.A.: educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb ==3 & b$cod_curso_frequentou_pessoa_memb>=1 &
                     b$cod_curso_frequentou_pessoa_memb<=3,0,b$educa)

#*Fundamental primeiro ciclo: concluiu (educa=4) nao concluiu (educa=serie-1)
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==4 &
                     b$cod_concluiu_frequentou_memb==1,4,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb == 3 & b$cod_curso_frequentou_pessoa_memb==4 &
                     b$cod_ano_serie_frequentou_memb >= 1 & b$cod_ano_serie_frequentou_memb<=4 &
                     b$cod_concluiu_frequentou_memb == 2, b$cod_ano_serie_frequentou_memb-1,b$educa)

#*fundamental primeiro ciclo nao seriado; educa=0.
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==4 &
                     b$cod_ano_serie_frequentou_memb==10 & b$cod_concluiu_frequentou_memb==2,0,b$educa)


#*Fundamental segundo ciclo
b$educa <-  if_else(b$ind_frequenta_escola_memb == 3 & b$cod_curso_frequentou_pessoa_memb == 5 &
                    b$cod_concluiu_frequentou_memb == 1, 8, b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb == 5 &
                   b$cod_ano_serie_frequentou_memb >= 5 & b$cod_ano_serie_frequentou_memb <= 8 &
                   b$cod_concluiu_frequentou_memb == 2 , b$cod_ano_serie_frequentou_memb-1,b$educa)

#*Fundamental segundo ciclo nao seriado linha 247
b$educa <- if_else(b$ind_frequenta_escola_memb == 3 & b$cod_curso_frequentou_pessoa_memb == 5 &
                     b$cod_ano_serie_frequentou_memb == 10 & b$cod_concluiu_frequentou_memb == 1,8,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb == 3     & b$cod_curso_frequentou_pessoa_memb == 5 &
                   b$cod_ano_serie_frequentou_memb == 10 & b$cod_concluiu_frequentou_memb == 2,4,b$educa)

#*Fundamental novo: 1o ano educa=0
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==6 &
                     b$cod_ano_serie_frequentou_memb==1,0,b$educa)

#*Fundamental novo: concluiu educa=8
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==6 &
                     b$cod_concluiu_frequentou_memb==1,8,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3       & b$cod_curso_frequentou_pessoa_memb==6 &
                     b$cod_ano_serie_frequentou_memb>=2 & b$cod_ano_serie_frequentou_memb<=9    &
                     b$cod_concluiu_frequentou_memb==2,b$cod_ano_serie_frequentou_memb-2,b$educa)

#*fundamental nao seriado: educa = 0
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==6 &
                   b$cod_ano_serie_frequentou_memb==10 & b$cod_concluiu_frequentou_memb==2,0,b$educa)

#*fundamental especial: concluiu: educa=8
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==7 &
                   b$cod_concluiu_frequentou_memb==1,8,b$educa)

#*fundamental especial: nao concluiu
b$educa <- if_else(b$ind_frequenta_escola_memb==3     & b$cod_curso_frequentou_pessoa_memb==7 &
                   b$cod_ano_serie_frequentou_memb>=1 & b$cod_ano_serie_frequentou_memb<=8 &
                   b$ cod_concluiu_frequentou_memb==2, b$cod_ano_serie_frequentou_memb-1,b$educa)

#fundamental especial nao seriado
b$educa <- if_else(b$ind_frequenta_escola_memb==3      & b$cod_curso_frequentou_pessoa_memb==7 &
                 b$cod_ano_serie_frequentou_memb==10 & b$cod_concluiu_frequentou_memb==1,8,b$educa)


b$educa <- if_else(b$ind_frequenta_escola_memb==3      & b$cod_curso_frequentou_pessoa_memb==7 &
                   b$cod_ano_serie_frequentou_memb==10 & b$cod_concluiu_frequentou_memb==2,0,b$educa)

### MEDIO
b$educa <- if_else(b$ind_frequenta_escola_memb==3        & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9 & b$cod_concluiu_frequentou_memb==1,11,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3         & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9  & b$cod_ano_serie_frequentou_memb==1 &
                   b$cod_concluiu_frequentou_memb==2,8,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3        & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9 & b$cod_ano_serie_frequentou_memb==2 &
                   b$cod_concluiu_frequentou_memb==2,9,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3        & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9 & b$cod_ano_serie_frequentou_memb==3 &
                   b$cod_concluiu_frequentou_memb==2,10,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3        & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9 & b$cod_ano_serie_frequentou_memb==4    &
                   b$cod_concluiu_frequentou_memb==2,10,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3        & b$cod_curso_frequentou_pessoa_memb>=8 &
                   b$cod_curso_frequentou_pessoa_memb<=9 & b$cod_ano_serie_frequentou_memb==10   &
                   b$cod_concluiu_frequentou_memb==2,8,b$educa)

#*EJA primeiro ciclo fundamental
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==10 &
                   b$cod_concluiu_frequentou_memb==1,4,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==10 &
                   b$cod_concluiu_frequentou_memb==2,0,b$educa)

#*EJA segundo ciclo fundamental
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==11 &
                   b$cod_concluiu_frequentou_memb==1,8,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==11 &
                   b$cod_concluiu_frequentou_memb==2,4,b$educa)

#*EJA medio
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==12 &
                   b$cod_concluiu_frequentou_memb==1,11,b$educa)

b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==12 &
                   b$cod_concluiu_frequentou_memb==2,8,b$educa)

#*Superior, aperfeicoamento, mestrado, doutorado
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==13,13,b$educa)

#*Alfabetizacao de adultos
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==14,0,b$educa)

#*Nao frequentou nenhum curso
b$educa <- if_else(b$ind_frequenta_escola_memb==3 & b$cod_curso_frequentou_pessoa_memb==15,0,b$educa)

#**Nunca frequentou escola
b$educa <- if_else(b$ind_frequenta_escola_memb==4,0,b$educa)

######### FIM VARIAVEL EDUCACAO

## LINHA 305
#* AUX_C1: ADULTO COM MAIS DE 17 ANOS ANALFABETO
b$aux_c1 <- if_else(b$idade > 17  & b$analf==1 , 1,if_else(is.na(b$idade) | is.na(b$analf),NA_real_,0))

#* AUX_C2: ADULTO COM MAIS DE 17 ANOS ANALFABETO FUNCIONAL (MENOS DE 4 ANOS DE ESTUDO)
b$aux_c2 <- if_else(b$idade>17 &  b$educa>=0 & b$educa<=3, 1, if_else(is.na(b$idade) | is.na(b$educa),NA_real_,0))

#* AUX_C3: PRESENCA DE PELO MENOS UMA PESSOA COM 15 ANOS OU MAIS ALFABETIZADA
b$aux_c3 <- if_else(b$idade>=15 & b$analf==0 ,1,if_else(is.na(b$idade) | is.na(b$analf),NA_real_,0))

#* FREQESC_JAFREQ: FREQUENTA A ESCOLA OU JA FREQUENTOU
b$freqesc_jafreq <- if_else(b$ind_frequenta_escola_memb>=1 & b$ind_frequenta_escola_memb<=3,1,
                            if_else(is.na(b$ind_frequenta_escola_memb),NA_real_,0))

#* AUX_C4: ADULTO COM 15 ANOS  OU MAIS QUE FREQUENTA OU JA FREQUENTOU A ESCOLA
b$aux_c4 <- if_else(b$idade >= 15 &  b$freqesc_jafreq == 1,1,if_else(is.na(b$idade) | is.na(b$freqesc_jafreq) ,NA_real_,0))

#* AUX_C5: ADULTO COM 15 ANOS OU MAIS ALFABETIZADA QUE FREQUENTA OU JA FREQUENTOU A ESCOLA
b$aux_c5 <- if_else(b$idade>=15 &  b$analf==0 & b$freqesc_jafreq==1,1,
                    if_else(is.na(b$idade) | is.na(b$analf) | is.na(b$freqesc_jafreq),NA_real_,0))

#* AUX_C6: ADULTO COM MAIS DE 17 ANOS COM FUNDAMENTAL COMPLETO (MAIS DE 7 ANOS DE ESTUDO)
b$aux_c6 <- if_else(b$idade>17 & b$educa>=8,1,if_else(is.na(b$idade) | is.na(b$educa),NA_real_,0))

#* AUX_C7: ADULTO COM MAIS DE 17 ANOS COM MEDIO COMPLETO (MAIS DE 10 ANOS DE ESTUDO)
b$aux_c7 <- if_else(b$idade>17 &  b$educa>=11,1,if_else(is.na(b$idade) | is.na(b$educa),NA_real_,0))

#* AUX_C8: ADULTO COM MAS DE 17 ANOS COM ALGUMA EDUCACAO SUPERIOR (MAIS DE 11 ANOS DE ESTUDO)
b$aux_c8 <- if_else(b$idade>17 & b$educa>=12,1,if_else(is.na(b$idade) | is.na(b$educa),NA_real_,0))

#* AUX_T1: MEMBRO EM IDADE ATIVA
b$aux_t1 <- if_else(b$idade>=15,1,if_else(is.na(b$idade),NA_real_,0))

#* PESS_OCUP ## VERIFICAR ESSA IMPLEMENTACAO !!!!!!!!!!!!!!!!!!!!!!!!!!!! CUIDADO NA_real!!!
b$pess_ocup <- if_else((b$cod_trabalhou_memb==1) | (b$cod_trabalhou_memb==2 & b$cod_afastado_trab_memb==1),1,
                          if_else((b$cod_trabalhou_memb==2 & b$cod_afastado_trab_memb==2) |
                                 (b$cod_trabalhou_memb==2 & (b$cod_afastado_trab_memb!=1 & b$cod_afastado_trab_memb!=2)),0,NA_real_))

#* AUX_T2: MEMBRO EM IDADE ATIVA OCUPADO
b$aux_t2 <- if_else(b$idade>=15 & b$idade<=64 & b$pess_ocup==1,1,if_else(is.na(b$idade)| is.na(b$pess_ocup),NA_real_,0))

#* AUX_T3: OCUPADO NO SETOR FORMAL - AQUI HA problema logico de implementacao STATA. REVER P CIMA
## VERIFICAR ESSA IMPLEMENTACAO !!!!!!!!!!!!!!!!!!!!!!!!!!!! CUIDADO NA_real!!!
b$aux_t3 <- if_else(  (b$pess_ocup==1 & b$cod_principal_trab_memb==4) |
                        (b$pess_ocup==1 & b$cod_principal_trab_memb==6) |
                        (b$pess_ocup==1 & b$cod_principal_trab_memb>=8 & b$cod_principal_trab_memb<=11),1,
                   if_else(b$pess_ocup==1,0,NA_real_))

#* AUX_T4: OCUPADO EM SETOR NAO AGRO
b$aux_t4 <- if_else(b$pess_ocup==1 & b$cod_agricultura_trab_memb==2,1,
                         if_else(b$pess_ocup==1 & is.na(b$cod_agricultura_trab_memb)==FALSE ,0,NA_real_))

#* TRATAMENTO DA RENDA
b$val_remuner_emprego_memb <- if_else(is.na(b$val_remuner_emprego_memb), 0, as.numeric(b$val_remuner_emprego_memb))
b$val_renda_bruta_12_meses_memb <- if_else(is.na(b$val_renda_bruta_12_meses_memb), 0, as.numeric(b$val_renda_bruta_12_meses_memb))

#* RENDA DO TRABALHO
b$rendatrab <- b$val_remuner_emprego_memb


#* ALGUMA RENDA
b$renda_alg <- rowSums(select(b,val_renda_bruta_12_meses_memb, val_renda_doacao_memb ,val_renda_aposent_memb,
                                val_renda_seguro_desemp_memb , val_renda_pensao_alimen_memb,val_outras_rendas_memb),na.rm = TRUE)

#* RENDA_TRANSF
b$renda_transf <- rowSums(select(b,val_renda_doacao_memb, val_renda_aposent_memb, val_renda_seguro_desemp_memb,
                               val_renda_pensao_alimen_memb),na.rm=TRUE)

#* RENDA
b$renda  <- b$renda_alg

#*ALGUMA RENDA EXCETO TRANSFERENCIAS
b$renda_ntrans <- b$renda_alg - b$renda_transf
b$renda_ntrans <- if_else(b$renda_ntrans < 0,0, b$renda_ntrans)
#####
###################### Criando Base Domicilios a partir
proc.time() - t

t <- proc.time()
D <- ungroup(slice(group_by(bd, cod_familiar_fam),1))
proc.time() - t
######## INSERINDO DEFLATORES
t <- proc.time()
Bancos_com_deflatores <- CriaDeflatores(tudo = b, tib_D = D, escolhe_base = Escolhe_base) # Year_Month
proc.time() - t
b <- Bancos_com_deflatores$tudo
#LINHA 427
#*RENDA DEFLACIONADA
b$renda_defla  <- b$renda*b$deflatores

#*SALARIO MINIMO 2016
sm <- SalarioMin

#*AUX_T5: OCUPADO COM RENDIMENTO SUPERIOR A 1 SM

b$aux_t5 <- if_else((b$pess_ocup==1 & b$renda>sm), 1,
                      if_else( is.na(b$pess_ocup) | is.na(b$renda), NA_real_,0))

#* AUX_T6: OCUPADO COM RENDIMENTO SUPERIOR A 2 SM
b$aux_t6 <- if_else(b$pess_ocup==1 & b$renda > 2*sm,1,
                         if_else(is.na(b$pess_ocup) | is.na(b$renda),NA_real_,0))

#* CRIANDO A VARIAVEL DEFAS
b$defas <- if_else( 0 >= b$idade - 7 -b$educa, 0, if_else(b$idade-7-b$educa>0, b$idade-7-b$educa,NA_real_))

#* AUX_D1: CRIANCAS MENORES DE 12 ANOS TRABALHANDO
b$aux_d1 <- if_else((b$idade>=0 & b$idade<=11 & (b$pess_ocup==1 | b$ind_trabalho_infantil_pessoa==1)),1,
        if_else(is.na(b$idade) | is.na(b$pess_ocup) | is.na(b$ind_trabalho_infantil_pessoa), NA_real_,0)
        )

#* AUX_D2: CRIANCAS MENORES DE 14 ANOS TRABALHANDO
b$aux_d2 <- if_else(b$idade>=0 & b$idade<=13 & (b$pess_ocup==1 |
                                                  b$ind_trabalho_infantil_pessoa==1),1,
                    if_else(is.na(b$idade) | is.na(b$pess_ocup) | is.na(b$ind_trabalho_infantil_pessoa),NA_real_,0))

#* AUX_D3: CRIANCAS MENORES DE 16 ANOS TRABALHANDO
b$aux_d3 <- if_else(b$idade>=0 & b$idade<=15 & (b$pess_ocup==1 | b$ind_trabalho_infantil_pessoa==1),1,
                    if_else(is.na(b$idade) | is.na(b$pess_ocup) | is.na(b$ind_trabalho_infantil_pessoa), NA_real_,0))

#* AUX_D4: CRIANCAS DE 4 A 6 ANOS QUE NAO FREQUENTAM A ESCOLA
b$aux_d4 <- if_else(b$idade>=4 & b$idade<=6 & b$freqesc_jafreq==0,1,
                         if_else(is.na(b$idade) | is.na(b$freqesc_jafreq),NA_real_,0))

#* AUX_D5: CRIANCAS DE 7 A 14 ANOS QUE NAO FREQUENTAM A ESCOLA
b$aux_d5 <- if_else(b$idade >= 7 & b$idade<=14 & b$freqesc_jafreq==0, 1,
                         if_else(is.na(b$idade) | is.na(b$freqesc_jafreq),NA_real_,0))

#* AUX_D6: CRIANCAS DE 7 A 17 ANOS QUE NAO FREQUENTAM A ESCOLA
b$aux_d6 <- if_else(b$idade>=7 & b$idade<=17 & b$freqesc_jafreq==0, 1,
                         if_else(is.na(b$idade) | is.na(b$freqesc_jafreq),NA_real_,0))

#* AUX_D7: CRIANCAS DE 0 A 14 ANOS COM MAIS DE 2 ANOS DE DEFASAGEM
b$aux_d7 <- if_else( 0 >= b$idade & b$idade <= 14 & b$defas > 2, 1,
                    if_else(is.na(b$idade) | is.na(b$defas), NA_real_,0))

#* AUX_D8: ADOLESCENTE COM 10 A 14 ANOS ANALFABETO
b$aux_d8 <- if_else(b$idade >= 10 & b$idade<=14 & b$analf==1,1,
                         if_else(is.na(b$idade) | is.na(b$analf),NA_real_,0))

#Linha - 649
b$aux_v8a_  <- b$aux_v8a
b$aux_v8b_  <- b$aux_v8b
b$aux_t1_   <- b$aux_t1
b$aux_t2_   <- b$aux_t2
b$renda_transf_ <- b$renda_transf

## COLLAPSE 1
grupo <- group_by(b, cod_familiar_fam ,cd_ibge)
collapse1 <- summarise_at(grupo, vars(idade:aux_d8), mean,na.rm=TRUE)
collapse1a <- summarise_at(grupo,vars(aux_v8a_, aux_v8b_, aux_t1_, aux_t2_, renda_transf_), sum,na.rm=TRUE)
B <- cbind(collapse1,collapse1a) #nova_base_pessoas

#save "C:\Users\guilh\Google Drive\IJSN\IDF_R\STATA\saidas\nova_base_pess.dta",replace


###################### BASE DOMICILIOS ##########################################################
#DESPESA TOTAL - LINHA900
# ja deflacionada !
D <- Bancos_com_deflatores$D

D$desptot <- rowSums(select(D, val_desp_energia_fam,val_desp_agua_esgoto_fam,val_desp_gas_fam,
                  val_desp_alimentacao_fam,val_desp_transpor_fam,val_desp_aluguel_fam,
                  val_desp_medicamentos_fam),na.rm = TRUE)*D$deflatores
#* DESPALIM
D$despalim <- D$val_desp_alimentacao_fam

#* RENDA_MEDIA
D$renda_media <- D$vlr_renda_media_fam*D$deflatores

#* TOT_PESS
D$tot_pess <- D$qtd_pessoas_domic_fam

#* GRUPO: DEFICIT HABITACIONAL
# qtd_comodos_dormitorio_fam "not in" c(1:8,50,60). Observar ! no come?o
#D$dormitorios <- if_else(D$qtd_comodos_dormitorio_fam %in% c(1:8,50,60),D$qtd_comodos_dormitorio_fam,NA_integer_)
D$dormitorios <- if_else(D$qtd_comodos_dormitorio_fam == 1 , 1,
                 if_else(D$qtd_comodos_dormitorio_fam == 2 , 2,
                 if_else(D$qtd_comodos_dormitorio_fam == 3 , 3,
                 if_else(D$qtd_comodos_dormitorio_fam == 4 , 4,
                 if_else(D$qtd_comodos_dormitorio_fam == 5 , 5,
                 if_else(D$qtd_comodos_dormitorio_fam == 6 , 6,
                 if_else(D$qtd_comodos_dormitorio_fam == 7 , 7,
                 if_else(D$qtd_comodos_dormitorio_fam == 8 , 8,
                 if_else(D$qtd_comodos_dormitorio_fam == 50, 50,
                 if_else(D$qtd_comodos_dormitorio_fam == 60, 60, NA_real_))))))))))

#* DENSIDADE
D$densidade <- if_else(D$tot_pess<0 | D$qtd_comodos_dormitorio_fam<=0, NA_real_, D$tot_pess / D$qtd_comodos_dormitorio_fam)

D$fam_cad <- if_else(D$cod_est_cadastral_fam==3,1,0)

## BASE DOMICILIOS
D <- filter(D, D$fam_cad==1)

#* AUX_V6 - Pessoa na familia internada ou abrigada em hospital. casa de saude. asilo. orfanato ou estabelecimento similr;
##Minha interpretação#
D$aux_v6 <- if_else( (D$qtd_pessoa_inter_0_17_anos_fam > 0  & is.na(D$qtd_pessoa_inter_0_17_anos_fam)==FALSE)  |
                     (D$qtd_pessoa_inter_18_64_anos_fam > 0 & is.na(D$qtd_pessoa_inter_18_64_anos_fam)==FALSE)  |
                     (D$qtd_pessoa_inter_65_anos_fam > 0    & is.na(D$qtd_pessoa_inter_65_anos_fam)==FALSE ), 1,
               if_else(is.na(D$qtd_pessoa_inter_0_17_anos_fam) | is.na(D$qtd_pessoa_inter_18_64_anos_fam) |
                        is.na(D$qtd_pessoa_inter_65_anos_fam),NA_real_,0))
#Impletamentacao STATA
#D$aux_v6 <- D$qtd_pessoa_inter_0_17_anos_fam*0
#D$aux_v6 <- if_else( (D$qtd_pessoa_inter_0_17_anos_fam > 0  & is.na(D$qtd_pessoa_inter_0_17_anos_fam)==FALSE)  |
#                     (D$qtd_pessoa_inter_18_64_anos_fam > 0 & is.na(D$qtd_pessoa_inter_18_64_anos_fam)==FALSE)  |
#                     (D$qtd_pessoa_inter_65_anos_fam > 0    & is.na(D$qtd_pessoa_inter_65_anos_fam)==FALSE ), 1, D$aux_v6)

#D$aux_v6 <- if_else(is.na(D$qtd_pessoa_inter_0_17_anos_fam) | is.na(D$qtd_pessoa_inter_18_64_anos_fam) |
#                    is.na(D$qtd_pessoa_inter_65_anos_fam),NA_real_,D$aux_v6)


#sum(D$aux_v6,na.rm = TRUE)
#* AUX_V16 - Familia que nao e indigena nem quilombola
D$aux_v16 <- if_else(D$cod_familia_indigena_fam==2 & D$ind_familia_quilombola_fam==2,1,
                     if_else(D$cod_familia_indigena_fam==1 | D$ind_familia_quilombola_fam==1,0,NA_real_))

#* H1: DOMICILIO PARTICULAR OU COLETIVO
D$h1 <- if_else(D$cod_especie_domic_fam==1 | D$cod_especie_domic_fam==2 | D$cod_especie_domic_fam==3,1,
              if_else(is.na(D$cod_especie_domic_fam),NA_real_,0))

#* H2: DOMICILIO PARTICULAR PERMANENTE OU PROVISORIO
D$h2 <- if_else(D$cod_especie_domic_fam==1 | D$cod_especie_domic_fam==2,1,
                     if_else(is.na(D$cod_especie_domic_fam),NA_real_,0))

#* H3: DOMICILIO PARTICULAR PERMANENTE
D$h3 <- if_else(D$cod_especie_domic_fam==1, 1, if_else(is.na(D$cod_especie_domic_fam),NA_real_,0))

#* H4:DENSIDADE DE ATE 2 MORADORES POR DORMITORIO
D$h4 <- if_else(D$h3==1 & D$densidade<=2 & is.na(D$densidade)==FALSE, 1,
                if_else( (is.na(D$h3) & is.na(D$densidade) )| D$h3 != 1, NA_real_,0))

#*H5: MATERIAL DE CONSTRU??O PERMANENTE EM DOMICILIO PARTICULAR PERMANENTE
D$h5 <- if_else(D$h3==1 & D$cod_material_domic_fam %in% c(1:4), 1,
                     if_else( (D$h3==1 & is.na(D$cod_material_domic_fam)) | D$h3 != 1,NA_real_,0))

#* H6: ACESSO ADEQUADO A AGUA DE REDE GERAL DE DISTRIBUICAO EM DOMICILIO PARTICULAR PERMANENTE
D$h6 <- if_else(D$h3==1 & D$cod_abaste_agua_domic_fam==1, 1,
                     if_else( (D$h3==1 & is.na(D$cod_abaste_agua_domic_fam)) | D$h3 != 1,NA_real_,0))

#* H7: ACESSO ADEQUADO A AGUA EM DOMICILIO PARTICULAR PERMANENTE
D$h7  <- if_else( (D$h3==1 & D$cod_abaste_agua_domic_fam==1) |(D$h3==1 & D$cod_abaste_agua_domic_fam==2) |
                  (D$h3==1 & D$cod_abaste_agua_domic_fam==3) , 1,
            if_else( (D$h3==1 & is.na(D$cod_abaste_agua_domic_fam) ) | D$h3 != 1,NA_real_,0))

#* H8: DOMICILIO PARTICULAR PERMANENTE POSSUI BANHEIRO OU SANITARIO
D$h8 <- if_else(D$h3==1 & D$cod_banheiro_domic_fam==1, 1,
            if_else(D$h3==1 & D$cod_banheiro_domic_fam==2, 0, NA_real_))

#* H9: ESGOTAMENTO SANITARIO ADEQUADO EM DOMICILIO PARTICULAR PERMANENTE
D$h9 <- if_else(D$h3==1 & D$cod_banheiro_domic_fam==1 & D$cod_escoa_sanitario_domic_fam %in% c(1:2), 1,
                if_else(D$h3==1 & D$cod_banheiro_domic_fam==1 & is.na(D$cod_escoa_sanitario_domic_fam),NA_real_,
                        if_else(D$h3!=1 | D$cod_banheiro_domic_fam!=1,NA_real_,0)))

#* H10: LIXO COLETADO DE FORMA DIRETA EM DOMICILIO PARTICULAR PERMANENTE
D$h10 <- if_else(D$h3==1 & D$cod_destino_lixo_domic_fam==1, 1,
                 if_else( (D$h3==1 & is.na(D$cod_destino_lixo_domic_fam) ) | D$h3!=1, NA_real_,0))

#* H11: LIXO COLETADO DE FORMA DIRETA OU INDIRETA EM DOMICILIO PARTICULAR PERMANENTE
D$h11 <- if_else((D$h3==1 & D$cod_destino_lixo_domic_fam %in% c(1:2)), 1,
                      if_else((D$h3==1 & is.na(D$cod_destino_lixo_domic_fam)) | D$h3 != 1, NA_real_,0))

#* H12: ACESSO A ELETRICIDADE COM MOTOR DE USO EM DOMICILIO PARTICULAR PERMANENTE
D$h12 <- if_else(D$h3==1 & D$cod_iluminacao_domic_fam %in% c(1:2), 1,
                 if_else( (D$h3==1 & is.na(D$cod_iluminacao_domic_fam) ) | D$h3 != 1,NA_real_,0))

#* H13: ACESSO A ELETRICIDADE EM DOMICILIO PARTICULAR PERMANENTE
D$h13 <- if_else((D$h3==1 & D$cod_iluminacao_domic_fam %in% c(1:3)), 1,
                      if_else( ((D$h3==1 & is.na(D$cod_iluminacao_domic_fam) ) | D$h3 != 1),NA_real_,0))

#* H14: Domicilio particular permanente localizado em trecho de logradouro com cacamba/pavimentacao total
D$h14 <- if_else(D$h3==1 & D$cod_calcamento_domic_fam==1, 1,
                     if_else( (D$h3==1 & is.na(D$cod_calcamento_domic_fam) ) | D$h3!=1, NA_real_, 0))

#* H15: Domicilio particular permanente localizado em trecho de logradouro com cacamba/pavimentacao total ou parcial
D$h15 <- if_else(D$h3==1 & D$cod_calcamento_domic_fam %in% c(1,2), 1,
                      if_else( (D$h3==1 & is.na(D$cod_calcamento_domic_fam) ) | D$h3!=1, NA_real_, 0))

#NO STATA -> save: "C:\Users\guilh\Google Drive\IJSN\IDF_R\STATA\saidas\nova_base_dom.dta"

################### BASE PESSOA E DOMICILIO
J <- left_join(D, B, by=c("cd_ibge"="cd_ibge", "cod_familiar_fam"="cod_familiar_fam"))

#*CRIANDO MICRORREGIOES DO ES (MODELO IJSN)
J$cod_planejamento <- if_else(J$cd_ibge %in% c(3201308, 3202207, 3202405, 3205002, 3205101, 3205309, 3205200 ), 1,
                       if_else(J$cd_ibge %in% c(3202702, 3202900, 3204500, 3204559, 3204609), 2,
                        if_else(J$cd_ibge %in% c(3201159, 3201704, 3201902, 3203163, 3203346, 3205069, 3200102), 3,
                         if_else(J$cd_ibge %in% c(3200300, 3200409, 3202603, 3203320, 3204203, 3204302, 3204401, 3202801), 4,
                          if_else(J$cd_ibge %in% c(3200508, 3200706, 3201209, 3201407, 3203106, 3203403, 3203809, 3205036), 5,
                           if_else(J$cd_ibge %in% c(3200201, 3201100, 3201803, 3202009, 3202306, 3202454, 3202553, 3202652, 3203007, 3203700, 3204807), 6,
                            if_else(J$cd_ibge %in% c(3200607, 3202504, 3203130, 3203205, 3204351, 3205010), 7,
                             if_else(J$cd_ibge %in% c(3200359, 3200805, 3201506, 3202256, 3203353, 3204005, 3204658, 3204708, 3204955, 3205176), 8,
                              if_else(J$cd_ibge %in% c(3201001, 3201605, 3203056, 3203502, 3203601, 3204054,3204104,3204252, 3204906), 9,
                               if_else(J$cd_ibge %in% c(3200169, 3200136, 3200904, 3202108, 3203304, 3203908, 3205150), 10, NA_real_))))))))))


#* DESPTOTPC
# No Stata: 10/0 = NA. No R: 10/0 = Inf. Por esse motivo, se tot_pess=0 a função irá responder 0.
# Essa adaptação foi necessária para que os valores das variáveis fossem precisamente iguais.
J$desptotpc <- if_else(J$tot_pess==0, NA_real_, J$desptot/J$tot_pess)

#* DESPALIMPC
J$despalimpc <- if_else(J$tot_pess==0, NA_real_, J$despalim/J$tot_pess)

#*** COMPONENTE: VULNERABILIDADE DA FAMILIA
#** GRUPO: CRIANCASS. ADOLESCENTES E JOVENS

#* V1: Ausencia de criancas
J$v1 <- if_else(J$aux_v1 > 0 & is.na(J$aux_v1)==FALSE,0,1)

#* V2: Ausencia de crianca ou adolescente
J$v2 <- if_else(J$aux_v2 > 0 & is.na(J$aux_v2)==FALSE, 0 ,1)

#* V3: Ausencia de crianca ou adolescente ou jovem
J$v3 <- if_else(J$aux_v3 > 0 & is.na(J$aux_v3)==FALSE, 0, 1)

#* Media V1 V2 V3
J$sub_v1 <- rowMeans(select(J, v1,v2,v3),na.rm = TRUE)


#** GRUPO: PORTADORES DE DEFICIENCIA
#* V4: Ausencia de deficientes e idosos
J$v4 <- if_else(J$aux_v4 > 0 & is.na(J$aux_v4)==FALSE, 0, 1)

#* V5: Ausencia de idoso
J$v5 <- if_else(J$aux_v5>0 & is.na(J$aux_v5)==FALSE, 0, 1)

#* V6: Ausencia de pessoas na familia internada ou abrigada em hospital. casa de saude. asilo. orfanato ou estabelecimento similar
J$v6 <- if_else(J$aux_v6>0 & is.na(J$aux_v6)==FALSE, 0, 1)

#* Media V4 V5 V6
J$sub_v2 <- rowMeans(select(J,v4, v5, v6),na.rm = TRUE)


#** GRUPO: DEPENDENCIA ECONOMICA
#* V7: Presenca de conjuge
J$v7 <- if_else(J$aux_v7>0 & is.na(J$aux_v7)==FALSE, 1, 0)

#* v8: Mais da metade dos membros encontra-se em idade ativa
J$v8 <- if_else( (J$aux_v8a > (J$tot_pess/2)) & is.na(J$aux_v8a)==FALSE & is.na(J$tot_pess)==FALSE , 1, 0)

#* Media V7 V8
J$sub_v3 <- rowMeans(select(J, v7 ,v8),na.rm = TRUE)


#** GRUPO: PRESENCA DE JOVENS OU ADULTOS
#* V9: Presenca de pelo menos uma pessoa com 15 anos ou mais
J$v9 <- if_else(J$aux_v9>0 & is.na(J$aux_v9)==FALSE ,1 ,0)

#* V10: Presenca de pelo menos uma pessoa com 18 anos ou mais
J$v10 <- if_else(J$aux_v10>0 & is.na(J$aux_v10)==FALSE, 1, 0)

#* V11: Presenca de pelo menos uma pessoa com 21 anos ou mais
J$v11 <- if_else(J$aux_v11>0 & is.na(J$aux_v11)==FALSE, 1, 0)

#*  Media V9 V10 V11
J$sub_v4 <- rowMeans(select(J,v9, v10, v11),na.rm = TRUE)


#** GRUPO: CONVIVENCIA FAMILIAR
#* V12: Ausencia de criancas com ate nove anos que nao sao filhos ou enteado do responsavel pela unidade familiar
J$v12 <- if_else(J$aux_v12>0 & is.na(J$aux_v12)==FALSE,0,1)

#* V13: Ausencia de criancas com ate nove anos que seja outro parente ou nao parente
J$v13 <- if_else(J$aux_v13>0 & is.na(J$aux_v13)==FALSE,0,1)

#* Media V12 V13
J$sub_v5 <- rowMeans(select(J, v12, v13),na.rm = TRUE)

#**GRUPO: MIGRACAO
#* V14: Responsavel pela familia nasceu neste muncipio
J$v14 <- if_else(J$aux_v14>0 & is.na(J$aux_v14)==FALSE, 1, 0)

#* V15: Ausencia de criancas ou adolescentes com ate 14 anos que nasceu em outro municipio
J$v15 <- if_else(J$aux_v15>0 & is.na(J$aux_v15)==FALSE,0,1)

#* Media V14 V15
J$sub_v6 <- rowMeans(select(J, v14, v15),na.rm = TRUE)

#** GRUPO: COMUNIDADES TRADICIONAIS
#* V16: Familia que nao e indigena nem quilombola
J$v16 <- if_else(J$aux_v16>0 & is.na(J$aux_v16)==FALSE,1,0)

#* Media V16
J$sub_v7 <- rowMeans(select(J,v16),na.rm = TRUE)

#* MEDIA DE VULBERABILIDADE DA FAMILIA
J$comp1 <- rowMeans(select(J, sub_v1, sub_v2, sub_v3, sub_v4, sub_v5, sub_v6, sub_v7),na.rm = TRUE)




##
#*** COMPONENTE: ACESSO AO CONHECIMENTO
#** GRUPO:ANALFABETISMO
#* C1: Ausencia de adultos analfabetos
J$c1 <- if_else(J$aux_c1>0 & is.na(J$aux_c1)==FALSE, 0, 1)

#* C2: Ausencia de adultos analfabetos funcionais
J$c2 <- if_else(J$aux_c2>0 & is.na(J$aux_c2)==FALSE, 0, 1)

#* C3: Presenca de  pelo menos uma pessoa com 15 anos ou mais alfabetizada
J$c3 <- if_else(J$aux_c3>0 & is.na(J$aux_c3)==FALSE, 1, 0)

#* C4: Presenca de pelo menos uma pessoa com 15 anos ou mais que frequenta ou que tenha frequentado a escola
J$c4 <- if_else(J$aux_c4>0 & is.na(J$aux_c4)==FALSE, 1, 0)

#* C5: Presenca de pelo menos uma pessoa com 15 anos ou mais alfabetizada. que frequenta ou tenha frequentado a escola
J$c5 <- if_else(J$aux_c5>0 & is.na(J$aux_c5)==FALSE, 1, 0)

#* Media C1 C2 C3 C4 C5
J$sub_c1 <- rowMeans(select(J,c1, c2, c3, c4, c5),na.rm = TRUE)


#** GRUPO: ESCOLARIDADE
#* C6: PRESENCA DE PELO MENOS UM ADULTO COM FUNDAMENTAL COMPLETO
J$c6 <- if_else(J$aux_c6>0 & is.na(J$aux_c6)==FALSE,1,0)

#* C7: PRESENCA DE PELO MENOS UM ADULTO COM SECUNDARIO COMPLETO
J$c7 <- if_else(J$aux_c7>0 & is.na(J$aux_c7)==FALSE,1,0)

#* C8: PRESENCA DE PELO MENOS UM ADULTO COM ALGUMA EDUCACAO SUPERIOR
J$c8 <- if_else(J$aux_c8>0 & is.na(J$aux_c8)==FALSE,1,0)

#* Media C6 C7 C8
J$sub_c2 <- rowMeans(select(J,c6, c7, c8),na.rm = TRUE)

#* Media do componente 2
J$comp2 <- rowMeans(select(J,sub_c1,sub_c2),na.rm = TRUE)



#*** COMPONENTE: ACESSO AO TRABALHO
#** GRUPO: DISPONIBILIDADE DE TRABALHO
#* T1: PRESENCA DE PELO MENOS UM MEMBRO EM IDADE ATIVA
J$t1 <- if_else(J$aux_t1>0  & is.na(J$aux_t1)==FALSE,1,0)

#* T2: MAIS DA METADE DOS MEMBROS EM IDADE ATIVA ENCONTRAM-SE OCUPADOS NA SEMANA ANTERIOR A PESQUISA
J$t2 <- if_else(J$aux_t2 > J$aux_t1/2  & is.na(J$aux_t2)==FALSE, 1, 0)

# Media T1 T2
J$sub_t1 <- rowMeans(select(J, t1, t2),na.rm = TRUE)


#** GRUPO: QUALIDADE DO POSTO DE TRABALHO
#* T3: PRESENCA DE PELO MENOS UM OCUPADO NO SETOR FORMAL
J$t3 <- if_else(J$aux_t3 > 0  & is.na(J$aux_t3)==FALSE,1,0)

#* T4: PRESENCA DE PELO MENOS UM OCUPADO EM ATIVIDADE NAO AGRICOLA
J$t4 <- if_else(J$aux_t4 > 0  & is.na(J$aux_t4)==FALSE,1,0)

#*Media T3 T4
J$sub_t2<- rowMeans(select(J, t3, t4),na.rm = TRUE)



#** GRUPO: REMUNERACAO
#* T5: PRESENCA DE PELO MENOS UM OCUPADO COM RENDIMENTO SUPERIOR A 1 SALARIO MINIMO
J$t5 <- if_else(J$aux_t5 > 0 & is.na(J$aux_t5)==FALSE, 1, 0)

#* T6: PRESENCA DE PELO MENOS UM OCUPADO COM RENDIMENTO SUPERIOR A 2 SALARIO MINIMO
J$t6 <- if_else(J$aux_t6 > 0 & is.na(J$aux_t6)==FALSE, 1, 0)

#* Media T5 T6
J$sub_t3 <- rowMeans(select(J, t5, t6),na.rm = TRUE)

#* Media componente 3
J$comp3 <- rowMeans(select(J, sub_t1, sub_t2, sub_t3),na.rm = TRUE)



#*** COMPONENTE: DISPONIBILIDADE DE RECURSOS
#** GRUPO: Existencia de renda e despesas;
#* R1: Familia tem alguma despesa mensal
J$r1 <- if_else(J$desptot > 0 & is.na(J$desptot)==FALSE, 1, 0 )

#*R2: Familia possue alguma renda. excluindo-se as transferencias
J$r2 <- if_else( (J$renda_ntrans > 0 | is.na(J$renda_ntrans)==TRUE ) & is.na(J$desptot)==FALSE , 1, 0)

#*R3: Familia possue alguma renda
J$r3 <- if_else(J$renda_alg > 0 & is.na(J$renda_alg)==FALSE, 1, 0)

#* Medias R1 R2 R3
J$sub_r1 <- rowMeans(select(J, r1, r2, r3),na.rm = TRUE)


#** GRUPO: Extrema pobreza
#* R4: Despesa familiar per capita superior a linha de extrema pobreza
J$r4 <- if_else(J$desptotpc > ExtPobreza & is.na(J$desptotpc)==FALSE , 1, 0)

#* R5: Renda familiar per capita superior a linha da extrema pobreza;
J$r5 <- if_else(J$renda_media > ExtPobreza & is.na(J$renda_media)==FALSE ,1 ,0)

#* R6: Despesa com alimentos. higiene e limpeza superior a linha de extrema pobreza
J$r6 <- if_else(J$despalimpc > ExtPobreza & is.na(J$despalimpc)==FALSE, 1, 0)

#* Medias R4 R5 R6
J$sub_r2 <- rowMeans(select(J, r4, r5, r6),na.rm = TRUE)


#** GRUPO: POBREZA
#* R7: Despesa familiar per capita superior a linha de pobreza
J$r7 <- if_else(J$desptotpc > LimSupPobreza & is.na(J$desptotpc)==FALSE, 1,0)

#* R8: Renda familiar per capita superior a linha de pobreza
J$r8 <- if_else(J$renda_media > LimSupPobreza & is.na(J$renda_media)==FALSE, 1, 0)

#* Medias R7 R8
J$sub_r3 <- rowMeans(select(J, r7, r8),na.rm = TRUE)

#** GRUPO: CAPACIDADE DE GERACAO DE RENDA
#* R9: Maior parte da renda familiar nao advem de transferencia
J$r9 <- if_else(J$renda_transf<(J$renda/2) & is.na(J$renda_transf)==FALSE, 1, 0)

#* Medias
J$sub_r4 <- J$r9

#* MEDIA DO COMPONENTE 4
J$comp4 <- rowMeans(select(J, sub_r1, sub_r2, sub_r3, sub_r4),na.rm = TRUE)



#***COMPONENTE: DESENVOLVIMENTO INFANTIL
#** GRUPO: TRABALHO PRECOCE
#* D1: AUSENCIA DE CRIANCAS COM MENOS DE 12 ANOS TRABALHANDO
J$d1 <- if_else(J$aux_d1>0 & is.na(J$aux_d1)==FALSE, 0, 1)

#* D2: AUSENCIA DE CRIANCAS COM MENOS DE 14 ANOS TRABALHANDO
J$d2 <- if_else(J$aux_d2>0 & is.na(J$aux_d2)==FALSE, 0, 1)

#* D3: AUSENCIA DE CRIANCAS COM MENOS DE 16 ANOS TRABALHANDO
#gen d3=1
J$d3 <- if_else(J$aux_d3>0 & is.na(J$aux_d3)==FALSE, 0 , 1)

#* Medias D1 D2 D3
J$sub_d1 <- rowMeans(select(J,d1, d2, d3),na.rm = TRUE)


#** GRUPO: ACESSO A ESCOLA
#* D4: Ausencia de crianca de 4-6 anos fora da escola
J$d4 <- if_else(J$aux_d4>0 & is.na(J$aux_d4)==FALSE, 0, 1)

#* D5: Ausencia de crianca de 7-14 anos fora da escola
J$d5 <- if_else(J$aux_d5 > 0 & is.na(J$aux_d5)==FALSE, 0, 1)

#* D6: Ausencia de pelo menos uma crianca de 7-17 anos fora da escola
#gen d6=1
J$d6 <- if_else(J$aux_d6>0 & is.na(J$aux_d6)==FALSE, 0, 1)

#* Medias D4 D5 D6
J$sub_d2 <- rowMeans(select(J,d4, d5, d6),na.rm = TRUE)


#** GRUPO: PROGRESSO ESCOLAR
#* D7: Ausencia de crianca com ate 14 anos com mais de 2 anos de atraso
J$d7 <- if_else(J$aux_d7>0 & is.na(J$aux_d7)==FALSE, 0,1)

#* D8: Ausencia de pelo menos um adolescente de 10 a 14 anos analfabeto
J$d8 <- if_else(J$aux_d8 > 0 & is.na(J$aux_d8)==FALSE , 0, 1)

#* D9: Ausencia de pelo menos um jovem de 15 a 17 anos analfabeto
J$d9 <- if_else(J$aux_d9 > 0 & is.na(J$aux_d9)==FALSE, 0 ,1)

#* Medias D7 D8 D9
J$sub_d3 <- rowMeans(select(J,d7, d8, d9),na.rm = TRUE)

#* MEDIA DO COMPONENTE 5
J$comp5 <- rowMeans(select(J, sub_d1, sub_d2, sub_d3),na.rm = TRUE)

# ** GRUPO: PROPRIEDADE DO DOMICILIO
# * H1: DOMICILIO PARTICULAR OU COLETIVO
# //h1=h1//
#         * H2: DOMICILIO PARTICULAR PERMANENTE OU PROVISORIO
# //h2=h2//
#         * H3: DOMICILIO PARTICULAR PERMANENTE
# //h3=h3//
#         * Medias H1. H2 e H3
J$sub_h1 <- rowMeans(select(J, h1, h2, h3),na.rm = TRUE)
# * H4:DENSIDADE DE ATE 2 MORADORES POR DORMITORIO
# * Media H4
J$sub_h2 <- J$h4
# ** GRUPO:ABRIGALIDADE
# * H5: MATERIAL DE CONSTRUCAO PERMANENTE
# * Medias H5
J$sub_h3 <- J$h5
# ** GRUPO: ACESSO ADEQUADO A AGUA
# * H6: ACESSO ADEQUADO A AGUA DE REDE GERAL DE DISTRIBUICAO
# * H7: ACESSO ADEQUADO A AGUA
# * Medias H6 H7
J$sub_h4 <- rowMeans(select(J, h6, h7),na.rm = TRUE)
# ** GRUPO: ACESSO ADEQUADO A ESGOTAMENTO SANITARIO
# * H8: DOMICILIO POSSUI BANHEIRO OU SANITARIO
# * H9: ESGOTAMENTO SANITARIO ADEQUADO
# * Medias H8 H9
J$sub_h5 <- rowMeans(select(J, h8, h9),na.rm = TRUE)
# ** GRUPO: ACESSO A COLETA DE LIXO
# * H10: LIXO COLETADO DE FORMA DIRETA
# * H11: LIXO COLETADO DE FORMA DIRETA E INDIRETA
# * Medias
J$sub_h6 <- rowMeans(select(J, h10, h11),na.rm = TRUE)
# ** GRUPO: ACESSO A ELETRICIDADE
# * H12: ACESSO A ELETRICIDADE COMMOTOR DE USO
# * H13: ACESSO A ELETRICIDADE
# * Medias H12 H13
J$sub_h7 <- rowMeans(select(J, h12, h13),na.rm = TRUE)
# ** GRUPO: PAVIMENTACAO
# * H14: Domicilio localizado em trecho de logradouro com cacamba/pavimentacao total
# * H15: Domicilio localizado em trecho de logradouro com cacamba/pavimentacao total ou parcial
# * Medias H14 H15
J$sub_h8 <- rowMeans(select(J, h14, h15),na.rm = TRUE)
# * Media Condicoes habitacionais
J$comp6 <- rowMeans(select(J, sub_h1, sub_h2, sub_h3, sub_h4, sub_h5, sub_h6, sub_h7, sub_h8),na.rm = TRUE)

#*** IDF
J$idf <- rowMeans(select(J, comp1, comp2, comp3, comp4, comp5, comp6),na.rm = TRUE)

#Preparando Saídas
#out <- list()
out <- as.data.frame(J)
#class(out) <- "variaveis IDF"
return(out)

}# fim da função




