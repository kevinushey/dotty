
#' @export
. <- structure(list(), class = "dot")

#' @export
`[<-.dot` <- function(x, ..., value) {
  dots <- eval(substitute(alist(...)))
  symbols <- sapply(dots, as.character)
  envir <- parent.frame()
  for (i in seq_along(symbols))
    assign(symbols[[i]], value[[i]], envir = envir)
  .
}
