
dotify <- function() {

  files <- list.files("R", full.names = TRUE)
  for (file in files)
    dotify_file(file)
}

dotify_file <- function(file) {
  expr <- parse(file, keep.source = FALSE)
  dotify_expr(expr)
}

#' @importFrom utils globalVariables
dotify_expr <- function(expr) {

  if (identical(expr, quote(expr = )))
    return()

  dotty <-
    is.call(expr) &&
    identical(expr[[1L]], as.name("<-")) &&
    is.call(expr[[2L]]) &&
    identical(expr[[2L]][[1L]], as.name("[")) &&
    identical(expr[[2L]][[2L]], as.name("."))

  if (dotty) {
    dotcall <- expr[[2L]]
    for (i in 3L:length(dotcall)) {
      name <- as.character(dotcall[[i]])
      globalVariables(name, package = .packageName)
    }
  }

  if (is.recursive(expr))
    for (i in seq_along(expr))
      dotify_expr(expr[[i]])

}
