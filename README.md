dotty
================

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
# compute on values in object -- this is probably too magical
.[total = sum(a)] <- list(a = 1:5)
total
```

    ## [1] 15

### R CMD check

If you’d like to use `dotty` in your CRAN package, you can avoid
`R CMD check` warnings by including a file called `R/zzz.R` with the
contents:

    dotty::dotify()

This function will search for usages of `dotty`, and call
`utils::globalVariables()` to assert to `R CMD check` that such
variables are valid for use.
