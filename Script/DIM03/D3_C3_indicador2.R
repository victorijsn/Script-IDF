## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.3. Remuneração
# Indicador: 3.3.2. Presença de pelo menos um ocupado com rendimento superior a 2 salário mínimo


D3_C3_I2 <- function(base, salario_minimo) {
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  if (("aux_pessoa_ocupada" %in% colnames(base)) == TRUE) {
    
    dado <- base[, .(d.cod_familiar_fam,
                     p.val_remuner_emprego_memb,
                     aux_pessoa_ocupada)]
    
  } else {
    
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R") 
    
    dado <- auxiliar_pessoa_ocupada(base)
    
    dado <- dado[, .(d.cod_familiar_fam,
                     p.val_remuner_emprego_memb,
                     aux_pessoa_ocupada)]
    
  }
  
  
  # marcando pessoas que tem a renda superior a 2 salário mínimo ------------
  
  dado[, marca_pess_renda_maior_2_sl := fifelse(aux_pessoa_ocupada == 1 
                                                & (p.val_remuner_emprego_memb > (2 * salario_minimo) ),
                                                1, 0)]
  
  # somando total de pessoas na família que foram marcadas ------------------
  
  dado <- dado[, .(total_pess_renda_maior_2_sl = 
                     sum(marca_pess_renda_maior_2_sl, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  
  # calculando o indicador --------------------------------------------------
  
  dado[, d3_c3_i2 := fifelse(total_pess_renda_maior_2_sl > 0, 1, 0)]
  
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c3_i2)]
  
  return(saida)
}