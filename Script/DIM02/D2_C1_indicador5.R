## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 2. Acesso ao conhecimento
# Componente: 2.1. Analfabetismo
# Indicador: 2.1.5. Presença de pelo menos uma pessoa com 15 anos ou mais 
# alfabetizada que frequenta ou tenha frequentado a escola

D2_C1_I5 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_idade" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     p.ind_frequenta_escola_memb,
                     aux_idade)]
  } else {
    source("Script/AUXILIARES/auxiliar_idade.R") 
    dado <- auxiliar_idade(base)
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_sabe_ler_escrever_memb,
                     p.ind_frequenta_escola_memb,
                     aux_idade)]
  }
  
  # Marca alfabetizado que frequenta ou frequentou a escola --------------------
  
  dado[!is.na(p.cod_sabe_ler_escrever_memb) &
         !is.na(p.ind_frequenta_escola_memb), 
       marca_alfab_freq_escola := fifelse(p.cod_sabe_ler_escrever_memb == 1L &
                                            p.ind_frequenta_escola_memb <= 3L,1L,0L)]

  # calculando o indicador --------------------------------------------------
  
  dado <- dado[aux_idade>=15L,
               .(total_15anos_alfab_freq_escola = 
                   sum(marca_alfab_freq_escola, na.rm = TRUE)),
               by = c("d.cod_familiar_fam")]
  
  dado[, d2_c1_i5 := fifelse(total_15anos_alfab_freq_escola == 0, 0, 1)]
  
  # Validação ---------------------------------------------------------------
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam,
                    d2_c1_i5)]
  return(saida)
}
