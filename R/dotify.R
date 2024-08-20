
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

dotify <- function() {

  # allow us to be disabled if necessary
  enabled <- Sys.getenv("DOTTY_DOTIFY_ENABLED", unset = "TRUE")
  if (!as.logical(enabled))
    return()

  # use some .onLoad() hacks to tell codetools how to parse our code
  if (!requireNamespace("codetools", quietly = TRUE))
    return()

  # make sure we have a handlers environment
  codetools <- asNamespace("codetools")
  collectUsageHandlers <- codetools$collectUsageHandlers
  if (!is.environment(collectUsageHandlers))
    return()

  # add our handler for subset-assignment
  handler <- collectUsageHandlers$`[<-` %||% function(v, w) {}
  collectUsageHandlers$`[<-` <- function(v, w) {

    # only handle dotty calls
    if (!identical(v[[2L]], dot)) {
      handler(v, w)
      return()
    }

    # start adding them as local variables
    vars <- character()
    for (i in seq_along(v)) {
      if (is.symbol(v[[i]])) {
        vars <- c(vars, as.character(v[[i]]))
      }
    }

    # collect locals with these treated as parameters
    w$startCollectLocals(vars, character(), w)

    # call original handler
    handler(v, w)

  }

}
