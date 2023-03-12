
dotdot <- as.name("..")

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

  # search for a '..' placeholder; if we
  index <- dotty_find(parts)
  if (is.null(index)) {
    dotty_impl(parts, value, envir)
    return(.)
  }

  # split into left parts, right parts
  nleft <- index - 1L
  nright <- length(parts) - index + 1L

  # evaluate left variables
  dotty_impl(
    head(parts, n = nleft),
    head(value, n = nleft),
    envir
  )

  # evaluate right variables
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
