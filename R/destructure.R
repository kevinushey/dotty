
destructure <- function(object) {
  UseMethod("destructure")
}

#' @export
destructure.default <- function(object) {
  object
}

#' @export
destructure.numeric_version <- function(object) {
  unclass(object)[[1L]]
}
