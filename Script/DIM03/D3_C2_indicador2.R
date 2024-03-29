## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.2. Qualidadade do posto de trabalho
# Indicador: 3.2.2. Presença de pelo menos um ocupado em avidade não agrícola


D3_C2_I2 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.cod_principal_trab_memb,
                     aux_pessoa_ocupada)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
    
    dado <- auxiliar_pessoa_ocupada(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.cod_principal_trab_memb,
                     aux_pessoa_ocupada)]
  }
  
  # marcando pessoas que trabalham no setor agro --------------------------
  
  dado[, marca_pessoa_setor_agro := fifelse(aux_pessoa_ocupada == 1 & p.cod_principal_trab_memb == 2, 1, 0)]
  
  
  # contando o total de pessoas no setor agro por família -----------------
  
  dado <- dado[, .(total_pess_setor_agro = 
                     sum(marca_pessoa_setor_agro, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  
  # calculando o indicador --------------------------------------------------
  
  dado[, d3_c2_i2 := fifelse(total_pess_setor_agro > 0, 0, 1)]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c2_i2)]  
  
  return(saida)
}


