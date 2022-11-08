# pessoas ocupadas
# VITÓRIA SESANA 


aux_pessoa_ocupada <- function(base) {
  dado <- base
  dado[, aux_pessoa_ocupada := 
         fifelse(p.cod_trabalhou_memb == 1 | ( p.cod_trabalhou_memb == 2 & p.cod_afastado_trab_memb == 1), 1, 0) ]
  
  dado$aux_pessoa_ocupada %>% is.na() %>% table()
  
}