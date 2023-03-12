## dotty

Destructuring assignments in R with the `.` object.


### Usage

```
# extract number of rows, number of columns from mtcars
.[nr, nc] <- dim(mtcars)

# extract first, last element of vector
.[first, .., last] <- c(1, 2, 3, 4, 5)
```


### R CMD check

If you'd like to use `dotty` in your CRAN package, you can avoid
`R CMD check` warnings by including a file called `R/zzz.R` with the contents:

```
dotty::dotify()
```

This function will search for usages of `dotty`, and call
`utils::globalVariables()` to assert to `R CMD check` that such variables
are valid for use.
