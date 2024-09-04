
#' Dotify an R Package
#'
#' When using `dotty` within an R package, you might see **NOTE**s during
#' `R CMD check` of the form:
#'
#' ```
#' N  checking R code for possible problems (1.8s)
#'    <package>: no visible binding for global variable <variable>
#'    Undefined global functions or variables:
#'      <variable>
#' ```
#'
#' This occurs because the [codetools] package, which is used for static
#' analysis of \R code during `R CMD check`, does not recognize that e.g.
#' `.[apple] <- 42` would create a variable called `apple` in the current
#' scope. Calling `dotty::dotify()` in your package's `.onLoad()` will
#' allow `dotty` to patch `codetools` in a way that will allow it to
#' understand `dotty` usages, and so prevent these `R CMD check` notes
#' from being emitted.
#'
#' @export
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
