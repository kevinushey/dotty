
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
  dotdot <- as.name("..")

  index <- NULL
  for (i in seq_along(parts)) {
    if (identical(parts[[i]], dotdot)) {
      index <- i
      break
    }
  }

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
    symbol <- as.character(parts[[i]])
    key <- names(parts)[[i]]
    if (is.character(key) && nzchar(key))
      assign(key, value[[symbol]], envir = envir)
    else
      assign(symbol, value[[i]], envir = envir)
  }

  .

}
