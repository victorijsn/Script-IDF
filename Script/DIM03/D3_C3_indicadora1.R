## NAGI - SETADES / 2022
## Responsável: Vitoria Sesana

# Cálculo do Índice de Desenvolvimento Familiar
# Dimensão: 3. Acesso ao Trabalho
# Componente: 3.3. Remuneração
# Indicador: 3.3.1. Presença de pelo menos um ocupado com rendimento superior a 1 salário mínimo
salario_minimo = 1212

D3_C3_I1 <- function(base, salario_minimo) {
  
  require(data.table)
  dado <- base
  
  # criando a variável pessoa ocupada caso ela não exista -------------------
  
  if ("aux_pessoa_ocupada" %in% colnames(dado)) {
    dado <- dado 
  } else {
    source("Script/AUXILIARES/auxiliar_pessoa_ocupada.R", encoding = "UTF-8")
    dado <- auxiliar_pessoa_ocupada(dado)
  }

  # marcando pessoas que tem a renda superior a 1 salário mínimo ------------
  
  dado[, marca_pess_renda_maior_1_sl := fifelse(aux_pessoa_ocupada == 1 
                            & (p.val_remuner_emprego_memb > salario_minimo),
                            1, 0)]

  # somando total de pessoas na família que foram marcadas ------------------
  
  dado <- dado[, .(total_pess_renda_maior_1_sl = 
                     sum(marca_pess_renda_maior_1_sl, na.rm = TRUE)), 
               by = c("d.cod_familiar_fam")]
  
  
  # calculando o indicador --------------------------------------------------
  
  dado[, d3_c3_i1 := fifelse(total_pess_renda_maior_1_sl > 0, 1, 0)]
  
  # saída -------------------------------------------------------------------
  
  saida <- dado[, .(d.cod_familiar_fam, 
                    d3_c3_i1)]
  
  return(saida)
}