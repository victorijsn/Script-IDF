## NAGI - SETADES / 2023
## Responsável: Victor Nunes Toscano

# Índice de Desenvolvimento Familiar
# Função Auxiliar: Anos de estudo

auxiliar_educa <- function(base) {
  
  require(data.table)
  
  dado <- base
  
  # 0 ano de estudo
  ## Pessoas que frequentam escola
  ### Creche, pre-escola, C.A.
  dado[p.ind_frequenta_escola_memb %in% c(1,2)  & 
         p.cod_curso_frequenta_memb  %in% c(1:3),aux_educa:=0L ]
  
  ### Fundamental nao seriado e especial nao seriado
  dado[p.ind_frequenta_escola_memb %in% c(1,2) &
         p.cod_curso_frequenta_memb %in% c(4,6) & 
         p.cod_ano_serie_frequenta_memb == 10, aux_educa:=0L ]
  
  ### Fundamental novo 1o ano
  dado[p.ind_frequenta_escola_memb %in% c(1,2) & 
         p.cod_curso_frequenta_memb == 5 & 
         p.cod_ano_serie_frequenta_memb == 1, aux_educa:=0L ]
   
  ### EJA primeiro ciclo e Alfabetizacao de adultos
  dado[p.ind_frequenta_escola_memb %in% c(1,2) &
         p.cod_curso_frequenta_memb %in% c(9,12), aux_educa:=0L ]

  ## Pessoas que NAO frequentam, mas ja frequentaram 
  
  ### Creche, pre, C.A.
  dado[p.ind_frequenta_escola_memb ==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(1:3),aux_educa:=0L ]
  
  ### fundamental primeiro ciclo e escpecial nao seriado
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(4,6,7) &
         p.cod_ano_serie_frequentou_memb==10 & 
         p.cod_concluiu_frequentou_memb==2, aux_educa:=0L ]
  
  ### Fundamental novo: 1o ano
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==6 &
         p.cod_ano_serie_frequentou_memb==1, aux_educa:=0L ]

  ### EJA primeiro ciclo fundamental
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==10 &
         p.cod_concluiu_frequentou_memb==2, aux_educa:=0L ]
  
  ### Alfabetizacao de adultos ou Nao frequentou nenhum curso
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(14,15), aux_educa:=0L ]
  
  ## Nunca frequentou escola
  dado[p.ind_frequenta_escola_memb==4, aux_educa:=0L ]
  
  
  # Anos de estudo em serie (1 a 7 anos)
  ## Pessoas que frequentam escola
  
  ### Fundamental: educa: serie-1 (fundamental antigo e especial)
  dado[p.ind_frequenta_escola_memb %in% c(1,2) &
         p.cod_curso_frequenta_memb %in% c(4,6)  & 
         p.cod_ano_serie_frequenta_memb %in% c(1:8), 
       aux_educa:=p.cod_ano_serie_frequenta_memb-1 ]
  
  ### Fundamental novo 2o ao 9o ano: educa=serie-2
  dado[p.ind_frequenta_escola_memb %in% c(1,2) &
         p.cod_curso_frequenta_memb == 5 & 
         p.cod_ano_serie_frequenta_memb %in% c(2:9), 
       aux_educa:=p.cod_ano_serie_frequenta_memb-2 ]
  
  ## Pessoas que NAO frequentam, mas ja frequentaram   

  ### Fundamental primeiro ciclo: nao concluiu (educa=serie-1)
  dado[p.ind_frequenta_escola_memb == 3L &
         p.cod_curso_frequentou_pessoa_memb==4 &
         p.cod_ano_serie_frequentou_memb %in% c(1:4) &
         p.cod_concluiu_frequentou_memb == 2, 
       aux_educa:=p.cod_ano_serie_frequenta_memb-1 ]
  
  ### Fundamental segundo ciclo (educa=serie-1)
  dado[p.ind_frequenta_escola_memb == 3L &
         p.cod_curso_frequentou_pessoa_memb==5 &
         p.cod_ano_serie_frequentou_memb %in% c(5:8) &
         p.cod_concluiu_frequentou_memb == 2, 
       aux_educa:=p.cod_ano_serie_frequenta_memb-1 ]
  
  ### Fundamental especial: nao concluiu (educa = serie-1)
  dado[p.ind_frequenta_escola_memb == 3L &
         p.cod_curso_frequentou_pessoa_memb==7 &
         p.cod_ano_serie_frequentou_memb %in% c(1:8) &
         p.cod_concluiu_frequentou_memb == 2, 
       aux_educa:=p.cod_ano_serie_frequenta_memb-1 ]
  
  ### Fundamental novo: nao concluiu (educa=serie-2)
  dado[p.ind_frequenta_escola_memb == 3L &
         p.cod_curso_frequentou_pessoa_memb==6L &
         p.cod_ano_serie_frequentou_memb %in% c(2:9) &
         p.cod_concluiu_frequentou_memb == 2, 
       aux_educa:=p.cod_ano_serie_frequenta_memb-2 ]
  
  # 4 anos de estudo
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==4 &
         p.cod_concluiu_frequentou_memb==1, aux_educa:=4L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==5 &
         p.cod_ano_serie_frequentou_memb == 10 & 
         p.cod_concluiu_frequentou_memb == 2, aux_educa:=4L]
  
  dado[p.ind_frequenta_escola_memb >= 1 & 
         p.ind_frequenta_escola_memb <= 2 &
         p.cod_curso_frequenta_memb==10, aux_educa:=4L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==11 &
         p.cod_concluiu_frequentou_memb==2, aux_educa:=4L]

  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==10 &
         p.cod_concluiu_frequentou_memb==1, aux_educa:=4L]
  
  # 8 anos de estudo
  
  #*Ensino medio 1a serie: educa=8
  
  dado[p.ind_frequenta_escola_memb >= 1 & 
         p.ind_frequenta_escola_memb<=2 &
         p.cod_curso_frequenta_memb %in% c(7,8) & 
         p.cod_ano_serie_frequenta_memb==1, aux_educa:=8L]
  
  #*Ensino medio nao seriado: educa=8
  dado[p.ind_frequenta_escola_memb >= 1 & 
         p.ind_frequenta_escola_memb<=2 &
         p.cod_curso_frequenta_memb %in% c(7,8) & 
         p.cod_ano_serie_frequenta_memb==10, aux_educa:=8L]
  
  # Concluiu 
  #*Fundamental segundo ciclo
  dado[p.ind_frequenta_escola_memb == 3L & 
         p.cod_curso_frequentou_pessoa_memb == 5L &
         p.cod_concluiu_frequentou_memb == 1L, aux_educa:=8L]
  
  ### Fundamental segundo ciclo nao seriado 
  dado[p.ind_frequenta_escola_memb == 3 & 
         p.cod_curso_frequentou_pessoa_memb == 5 &
         p.cod_ano_serie_frequentou_memb == 10 & 
         p.cod_concluiu_frequentou_memb == 1, aux_educa:=8L]
  
  ### Fundamental novo: concluiu educa=8
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==6 &
         p.cod_concluiu_frequentou_memb==1, aux_educa:=8L]
  
  ## Fundamental especial: concluiu: educa=8
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==7 &
         p.cod_concluiu_frequentou_memb==1, aux_educa:=8L]
  
  #fundamental especial nao seriado
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==7 &
         p.cod_ano_serie_frequentou_memb==10 & 
         p.cod_concluiu_frequentou_memb==1,aux_educa:=8L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) & 
         p.cod_ano_serie_frequentou_memb==1 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=8L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_ano_serie_frequentou_memb==10 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=8L]

  #*EJA medio: educa=8
  dado[p.ind_frequenta_escola_memb >= 1 & 
         p.ind_frequenta_escola_memb<=2 &
         p.cod_curso_frequenta_memb==11,aux_educa:=8L]
  

  #*EJA segundo ciclo fundamental
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==11 &
         p.cod_concluiu_frequentou_memb==1,aux_educa:=8L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==12 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=8L]

  # 9 anos de estudo
  
  #*Ensino medio 2a serie: educa=9
  dado[p.ind_frequenta_escola_memb %in% c(1,2) & 
         p.cod_curso_frequenta_memb %in% c(7,8) & 
         p.cod_ano_serie_frequenta_memb==2,aux_educa:=9L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_ano_serie_frequentou_memb==2 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=9L]
  
  # 10 anos de estudo
    
  # *Ensino medio 3a / 4a serie: educa=10
  dado[p.ind_frequenta_escola_memb %in% c(1:2) & 
         p.cod_curso_frequenta_memb %in% c(7,8) & 
         p.cod_ano_serie_frequenta_memb %in% c(3,4),aux_educa:=10L]
  
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_ano_serie_frequentou_memb==3 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=10L]

  dado[p.ind_frequenta_escola_memb==3 &
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_ano_serie_frequentou_memb==4 &
         p.cod_concluiu_frequentou_memb==2,aux_educa:=10L]
  
  # 11 anos de estudo
  
  #*Pre-vestibular: educa=11
  
  dado[p.ind_frequenta_escola_memb %in% c(1,2) & 
         p.cod_curso_frequenta_memb==14,aux_educa:=11L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_concluiu_frequentou_memb==1,aux_educa:=11L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb %in% c(8,9) &
         p.cod_concluiu_frequentou_memb==1,aux_educa:=11L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==12 &
         p.cod_concluiu_frequentou_memb==1,aux_educa:=11L]
  
  # 13 anos de estudo
  
  #Superior, aperfeicoamento, mestrado, doutorado: educa=13
  
  dado[p.ind_frequenta_escola_memb %in% c(1,2)>= 1 & 
         p.cod_curso_frequenta_memb==13, aux_educa:=13L]
  
  dado[p.ind_frequenta_escola_memb==3 & 
         p.cod_curso_frequentou_pessoa_memb==13, aux_educa:=13L]
  

  # saída -------------------------------------------------------------------
  
  saida <- dado
  
  return(saida)
  
}
