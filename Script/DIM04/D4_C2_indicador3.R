## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.2. Extrema Pobreza
# Indicador: 4.2.3. Despesa com alimentos, higiene e limpeza superior a linha de extrema pobreza


D4_C2_I3 <- function(base, linha_extrema_pobreza){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("despesa_alimentacao" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {
    source("Script/AUXILIARES/auxiliar_inpc.R") #auxiliar inpc
    source("Script/AUXILIARES/auxiliar_deflatores.R") #auxiliar deflatores
    source("Script/AUXILIARES/auxiliar_valores.R") #auxiliar valores
    inpc <- auxiliar_inpc()
    deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    dado <- auxiliar_valores(base, deflatores)
  }
  
  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado <- dado[,.(d.cod_familiar_fam, despesa_alimentacao, d.qtd_pessoas_domic_fam)]
  
  # OBS IMPORTANTE - No texto não é mencionado a despesa com alimentação percapita, porém o cálculo é
  # por membro da família seguindo o que foi feito nos Scripts anteriores.
  
  # Criando a coluna pessoas no domicilio ------------------------------------------------------------
  
  dado[, pessoas_domicilio := .N, by = c("d.cod_familiar_fam")]
  
  # Agrupando por código familiar e calculando a despesa com alimentação percapita -------------------
  
  dado <- dado[, .(despesa_alim_percapita = 
                     max(despesa_alimentacao/pessoas_domicilio, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Despesa com alimentos, higiene e limpeza superior a linha de extrema pobreza
  
  dado[, d4_c2_i3 := fcase(despesa_alim_percapita > linha_extrema_pobreza &
                             is.na(despesa_alim_percapita) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c2_i3)]
  
  return(saida)
}