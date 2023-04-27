## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.1. Analfabetismo
# Indicador: 2.1.3. Presença de pelo menos uma pessoa com 15 anos ou mais alfabetizada

D2_C1_I3 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     aux_idade)]
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") 
    dado <- auxiliar_idade(base)
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     aux_idade)]
  }
  
  # marca alfabetizada -----------------------------------------------------
  
  dado[!is.na(p.cod_sabe_ler_escrever_memb), 
       marca_alfabetizada := fifelse(p.cod_sabe_ler_escrever_memb==1L, 1L,0L)]
  
  # calculando o indicador --------------------------------------------------
  
  dado <- dado[aux_idade>=15L, .(total_15anos_alfabetizada = 
                                  sum(marca_alfabetizada, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c1_i3 := fifelse(total_15anos_alfabetizada == 0, 0, 1)]
  
  # Validação ---------------------------------------------------------------
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c1_i3)]
}