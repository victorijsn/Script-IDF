## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.2. Qualidadade do posto de trabalho
# Indicador: 3.2.1. Presença de pelo menos um ocupado no setor formal


D3_C2_I1 <- function(base){
  
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

  # marcando pessoas que trabalham no setor formal --------------------------
  
  dado[, marca_pessoa_setor_formal := fifelse((aux_pessoa_ocupada == 1 & p.cod_principal_trab_memb == 4) |
                                                (aux_pessoa_ocupada == 1 & p.cod_principal_trab_memb == 6) |
                                                (aux_pessoa_ocupada == 1 & p.cod_principal_trab_memb >= 8 & 
                                                   p.cod_principal_trab_memb <= 11), 1, 0)]
  

  # contando o total de pessoas no setor formal por família -----------------
  
  dado <- dado[, .(total_pess_setor_formal = 
                     sum(marca_pessoa_setor_formal, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  

  # calculando o indicador --------------------------------------------------
  
  dado[, d3_c2_i1 := fifelse(total_pess_setor_formal > 0, 1, 0)]

  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c2_i1)]  
  
  return(saida)
}
