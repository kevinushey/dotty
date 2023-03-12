
dotdot <- as.name("..")

#' @export
. <- structure(list(), class = "dotty")

#' @export
`[<-.dotty` <- function(x, ..., value) {

  dotty(
    call  = as.list(sys.call()),
    value = value,
    envir = parent.frame()
  )

}

dotty <- function(call, value, envir) {

  # drop the irrelevant parts of the call
  parts <- call[3L:(length(call) - 1L)]

  # search for a '..' placeholder
  index <- dotty_find(parts)

  if (is.null(index))
    return(dotty_impl(parts, value, envir))

  nleft <- index - 1L
  nright <- length(parts) - index + 1L

  dotty_impl(
    head(parts, n = nleft),
    head(value, n = nleft),
    envir
  )

  dotty_impl(
    tail(parts, n = nright),
    tail(value, n = nright),
    envir
  )

  .

}

dotty_impl <- function(parts, value, envir) {

  for (i in seq_along(parts)) {

    part <- parts[[i]]
    key <- names(parts)[[i]]

    if (is.character(key) && nzchar(key)) {
      result <- eval(part, envir = value, enclos = envir)
      assign(key, result, envir = envir)
    } else {
      assign(as.character(part), value[[i]], envir = envir)
    }

  }

  .

}

dotty_find <- function(parts) {

  for (i in seq_along(parts))
    if (identical(parts[[i]], dotdot))
      return(i)

}
