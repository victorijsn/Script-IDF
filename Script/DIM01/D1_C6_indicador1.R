## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração
# Indicadora: 1.6.1. Responsável pela família nasceu nesse município

D1_C6_I1 <- function(base){
  
  require(data.table)
  
  # chamando as colunas necessárias -----------------------------------------
  
  dado <- base[, .(d.cod_familiar_fam,
                   p.cod_parentesco_rf_pessoa,
                   p.cod_local_nascimento_pessoa)]
  
  # marca se o responsável nasceu no município  -----------------------------
  
  dado[, marca_responsavel := fifelse(p.cod_parentesco_rf_pessoa == 1 &
                                        p.cod_local_nascimento_pessoa == 1, 1, 0)]
  

  # agrupando por família ---------------------------------------------------
  
  dado <- dado[, .(responsavel = sum(marca_responsavel, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  
  # calculando o indicador -----------------------------------------------------
  
  dado[, d1_c6_i1 := fifelse(responsavel > 0, 1, 0)]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c6_i1)]
  
  return(saida)
}