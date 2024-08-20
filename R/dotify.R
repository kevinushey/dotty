
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
  handlers <- codetools$collectUsageHandlers
  if (!is.environment(handlers))
    return()

  # make sure we have 'isUtilsVar'
  if (!exists("isUtilsVar", envir = codetools))
    return()

  # check if 'isUtilsVar' has changed in an unexpected way
  isUtilsVar <- codetools$isUtilsVar
  expected <- pairlist(v = quote(expr = ), env = quote(expr = ))
  if (!identical(formals(isUtilsVar), expected))
    return()

  # tell codetools to accept our code's handlers
  # TODO: ask Luke nicely to allow us to do this
  if (.BaseNamespaceEnv$bindingIsLocked("isUtilsVar", env = codetools)) {
    .BaseNamespaceEnv$unlockBinding("isUtilsVar", env = codetools)
    on.exit(.BaseNamespaceEnv$lockBinding("isUtilsVar", env = codetools), add = TRUE)
  }

  # replace the binding
  hack <- function(v, env) TRUE
  environment(hack) <- codetools
  assign("isUtilsVar", hack, envir = codetools)

  # add our handler for subset-assignment
  handler <- handlers$`[<-` %||% function(v, w) {}
  handlers$`[<-` <- function(v, w) {

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

  # included just for testing
  .[a, b] <- c(1, 2)
  c(a, b)

}
