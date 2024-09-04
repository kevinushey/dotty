
#' Destructure an Object
#'
#' `destructure` is primarily used to help define how an
#' object should be prepared, or transformed, prior to a
#' destructuring assignment. This can be relevant for
#' objects which have unique subsetting semantics -- for
#' example, [numeric_version] objects.
#'
#' Packages which would like to define special destructring
#' semantics for certain object classes can implement
#' methods for this class.
#'
#' @param object An \R object.
#' @export
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
