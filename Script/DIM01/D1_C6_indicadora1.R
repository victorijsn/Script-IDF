## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 1. Ausência de Vulnerabilidade
# Componente: 1.6. Migração
# Indicadora: 1.6.1. Responsável pela família nasceu nesse município

D1_C6_I1 <- function(base){
  
  dado <- base
  
  # marca se o responsavel nasceu no municipio  -----------------------------
  dado[, marca_responsavel := fifelse(p.cod_parentesco_rf_pessoa == 1 &
                                        p.cod_local_nascimento_pessoa == 1, 1, 0)]
  

  # agrupando por familia ---------------------------------------------------
  dado <- dado[, .(responsavel = sum(marca_responsavel, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  
  # calculando o indicador -----------------------------------------------------
  dado[, d1_c6_i1 := fifelse(responsavel > 0, 1, 0)]
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d1_c6_i1)]
  
  return(saida)
}