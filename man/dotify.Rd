% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dotify.R
\name{dotify}
\alias{dotify}
\title{Dotify an R Package}
\usage{
dotify()
}
\description{
When using `dotty` within an R package, you might see **NOTE**s during
`R CMD check` of the form:
}
\details{
```
N  checking R code for possible problems (1.8s)
   <package>: no visible binding for global variable <variable>
   Undefined global functions or variables:
     <variable>
```

This occurs because the [codetools] package, which is used for static
analysis of \R code during `R CMD check`, does not recognize that e.g.
`.[apple] <- 42` would create a variable called `apple` in the current
scope. Calling `dotty::dotify()` in your package's `.onLoad()` will
allow `dotty` to patch `codetools` in a way that will allow it to
understand `dotty` usages, and so prevent these `R CMD check` notes
from being emitted.
}
