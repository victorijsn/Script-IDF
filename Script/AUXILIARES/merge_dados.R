merge_dados <- function(dados, by = NULL, sort = FALSE) {
  Reduce(function(...) {merge(...,
                              by = by,
                              all = TRUE,
                              sort = sort)}, dados)
}