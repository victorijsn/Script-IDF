# quantidade de pessoas por domícilio

# fazer um cálculo para identificar outliers

auxiliar_pessoas_domicilio <-function(base) {

  dado <- base
  dado[, cadastro := 1]
  dado <- dado[, .(ditas = sum(d.qtd_pessoas_domic_fam, na.rm = TRUE)/length(d.qtd_pessoas_domic_fam),
                 calculadas = sum(cadastro) ),
             by = "d.cod_familiar_fam"]
  dado[, diferenca := ditas - calculadas]
  visao <- dado[, .(d.cod_familiar_fam, ditas, calculadas, diferenca)]
  visao[, n := 1]
  length(dado)
  visao[, .(qntd = .N,
            percent = .N/length(visao$d.cod_familiar_fam)*100), by = c("diferenca")][order(-percent)]
}

