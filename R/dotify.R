
dotify <- function() {

  # use some .onLoad() hacks to tell codetools how to parse our code
  if (!requireNamespace("codetools", quietly = TRUE))
    return()

  # make sure we have a handlers environment
  codetools <- asNamespace("codetools")
  handlers <- codetools$collectUsageHandlers
  if (!is.environment(handlers))
    return()

  # tell codetools to accept our code's handlers
  # TODO: ask Luke nicely to allow us to do this
  hack <- function(v, env) TRUE
  environment(hack) <- codetools
  .BaseNamespaceEnv$unlockBinding("isUtilsVar", env = codetools)
  assign("isUtilsVar", hack, envir = codetools)
  .BaseNamespaceEnv$lockBinding("isUtilsVar", env = codetools)

  # add our handler for subset-assignment
  handler <- handlers$`[<-`
  handlers$`[<-` <- function(v, w) {

    # get defined variables
    vars <- character()
    for (i in seq_along(v)) {
      if (is.symbol(v[[i]])) {
        vars <- c(vars, as.character(v[[i]]))
      }
    }

    # collect locals with these treated as parameters
    w$startCollectLocals(vars, character(), w)

    # call original handler
    if (!is.null(handler))
      handler(v, w)

  }

  # included just for testing
  .[a, b] <- c(1, 2)
  c(a, b)

}
