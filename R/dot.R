
dot    <- as.name(".")
dotdot <- as.name("..")

#' The Destructuring Dot Operator
#'
#' Use `dotty` to performed destructuring assignments.
#' Please see the examples below for usages.
#'
#' @examples
#'
#' # extract number of rows, number of columns from mtcars
#' .[nr, nc] <- dim(mtcars)
#' c(nr, nc)
#'
#' # extract first, last element of vector
#' .[first, .., last] <- c(1, 2, 3, 4, 5)
#' c(first, last)
#'
#' # extract a value by name
#' .[beta = beta] <- list(alpha = 1, beta = 2, gamma = 3)
#' beta
#'
#' # unpack nested values
#' .[x, .[y, .[z]]] <- list(1, list(2, list(3)))
#' c(x, y, z)
#'
#' # split version components
#' .[major, minor, patch] <- getRversion()
#' c(major, minor, patch)
#'
#' @aliases dotty
#' @rdname dotty
#' @export
. <- structure(list(), class = "dotty")

#' @export
`[<-.dotty` <- function(x, ..., value) {

  # get call parts
  call <- as.list(sys.call())
  parts <- call[3L:(length(call) - 1L)]

  # destructure value
  value <- destructure(value)

  # run dotty
  dotty(
    parts = parts,
    value = value,
    envir = parent.frame()
  )

}

dotty <- function(parts, value, envir) {

  # search for a '..' placeholder -- if none exists,
  # then just run dotty on the whole vector
  index <- dotty_find(parts)
  if (is.null(index)) {
    dotty_impl(parts, value, envir)
    return(.)
  }

  # we had a '..' placeholder; split the expression into
  # lhs and rhs parts, and apply on each side
  # split into left parts, right parts
  nlhs <- index - 1L
  nrhs <- length(parts) - index + 1L

  # evaluate left variables
  dotty_impl(
    head(parts, n = nlhs),
    head(value, n = nlhs),
    envir
  )

  # evaluate right variables
  dotty_impl(
    tail(parts, n = nrhs),
    tail(value, n = nrhs),
    envir
  )

  .

}

dotty_impl <- function(parts, value, envir) {

  for (i in seq_along(parts)) {

    part <- parts[[i]]
    key <- names(parts)[[i]]

    if (is.character(key) && nzchar(key)) {
      result <- eval(part, envir = as.list(value), enclos = envir)
      assign(key, result, envir = envir)
    } else if (is.call(part)) {
      part <- tail(as.list(part), n = -2L)
      dotty(part, value[[i]], envir)
    } else {
      assign(as.character(part), value[[i]], envir = envir)
    }

  }

}

dotty_find <- function(parts) {

  for (i in seq_along(parts))
    if (identical(parts[[i]], dotdot))
      return(i)

}
