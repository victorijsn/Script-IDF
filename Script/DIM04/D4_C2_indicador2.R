## NAGI - SETADES / 2023
## Responsável: Edil Oliveira

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 4. Disponibilidade de Recursos
# Componente: 4.2. Extrema Pobreza
# Indicador: 4.2.2. Renda familiar per capita superior a linha de extrema pobreza


D4_C2_I2 <- function(base, linha_extrema_pobreza, ano_inicial, data_referencia){
  
  require(data.table)
  dado <- base
  
  # Verificando se as colunas já foram calculadas ----------------------------------------------------
  
  if (("renda_media" %in% colnames(dado)) == TRUE) {
    dado <- dado
  } else {

    if (!"deflatores" %in% ls()) {

      if (!"inpc" %in% ls()) {
        #auxiliar inpc
        source("Script/AUXILIARES/auxiliar_inpc.R", encoding = "UTF-8")
        inpc <- auxiliar_inpc()
      }

      #auxiliar deflatores
      source("Script/AUXILIARES/auxiliar_deflatores.R", encoding = "UTF-8")
      deflatores <- auxiliar_deflatores(ano_inicial, data_referencia, inpc)
    }

    source("Script/AUXILIARES/auxiliar_valores.R",  encoding = "UTF-8") #auxiliar valores
    dado <- auxiliar_valores(base, deflatores)
  }
  
  # Selecionando as colunas que serão utilizadas -----------------------------------------------------
  
  dado <- dado[,.(d.cod_familiar_fam, renda_media)]
  
  
  # Agrupando por código familiar --------------------------------------------------------------------
  
  dado <- dado[, .(renda_media = 
                     max(renda_media, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  # Calculando o indicador: Renda familiar per capita superior a linha de extrema pobreza ------------
  
  dado[, d4_c2_i2 := fcase(renda_media > linha_extrema_pobreza &
                             is.na(renda_media) == FALSE, 1L, default = 0L)]
  
  # Validação ----------------------------------------------------------------------------------------
  
  
  
  # saida --------------------------------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d4_c2_i2)]
  
  return(saida)
}