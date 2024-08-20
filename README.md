dotty
================

<!-- badges: start -->

[![R-CMD-check](https://github.com/kevinushey/dotty/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kevinushey/dotty/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Destructuring assignments in R with the `.` object.

### Usage

``` r
library(dotty)

# extract number of rows, number of columns from mtcars
.[nr, nc] <- dim(mtcars)
c(nr, nc)
```

    ## [1] 32 11

``` r
# extract first, last element of vector
.[first, .., last] <- c(1, 2, 3, 4, 5)
c(first, last)
```

    ## [1] 1 5

``` r
# extract a value by name
.[beta = beta] <- list(alpha = 1, beta = 2, gamma = 3)
beta
```

    ## [1] 2

``` r
# unpack nested values
.[x, .[y, .[z]]] <- list(1, list(2, list(3)))
c(x, y, z)
```

    ## [1] 1 2 3

``` r
# split version components
.[major, minor, patch] <- getRversion()
c(major, minor, patch)
```

    ## [1] 4 4 1

### R CMD check

If you’d like to use `dotty` in your CRAN package, you can avoid
`R CMD check` warnings by including a file called `R/zzz.R` with the
contents:

    .onLoad <- function(libname, pkgname) {
      dotty::dotify()
    }

This function patches
[codetools](https://cran.r-project.org/package=codetools) so that
variables usages in `.` expressions can be linted as though those were
regular bindings / assignments.
