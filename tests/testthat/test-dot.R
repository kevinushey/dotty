
test_that("index-based destructuring works", {

  .[value] <- list(1L)
  expect_equal(value, 1L)

  .[nr, nc] <- dim(mtcars)
  expect_equal(nr, 32)
  expect_equal(nc, 11)

})

test_that("name-based destructuring works", {

  .[a = x, b = y] <- list(y = "y", x = "x")
  expect_equal(a, "x")
  expect_equal(b, "y")

})

test_that("we can use dotdot to drop unneeded values", {

  .[a, .., z] <- letters
  expect_equal(a, 'a')
  expect_equal(z, 'z')

})

test_that("we can capture a single value by name", {

  .[x = mpg] <- mtcars
  expect_equal(x, mtcars$mpg)

})

test_that("we can use a leading '..' to drop leading values", {

  .[.., z] <- letters
  expect_equal(z, 'z')

  .[.., y, z] <- letters
  expect_equal(y, 'y')
  expect_equal(z, 'z')

})

test_that("we can use a trailing '..' to drop trailing values", {

  .[a, ..] <- letters
  expect_equal(a, 'a')

  .[a, b, ..] <- letters
  expect_equal(a, 'a')
  expect_equal(b, 'b')

})

test_that("we can support arbitrary expressions", {

  .[a = mpg * 2] <- mtcars
  expect_equal(a, mtcars$mpg * 2)

  .[mpg_cyl = mpg * cyl] <- mtcars
  expect_equal(mpg_cyl, mtcars$mpg * mtcars$cyl)

})

test_that("we support recursive invocations", {

  .[a, .[b, .[c]]] <- list(1, list(2, list(3)))
  expect_equal(a, 1)
  expect_equal(b, 2)
  expect_equal(c, 3)

})

test_that("we can destructure R versions", {
  version <- getRversion()
  .[major, minor, patch] <- version
  expect_equal(major, unclass(version)[[1L]][[1L]])
  expect_equal(minor, unclass(version)[[1L]][[2L]])
  expect_equal(patch, unclass(version)[[1L]][[3L]])
})

test_that("dotify helps codetools understand dotty usages", {

  skip_if_not_installed("codetools")

  example <- function() {
    .[apple, banana] <- c(1, 2)
    c(apple, banana, cherry)
  }

  messages <- ""
  result <- codetools::checkUsage(example, report = function(x) {
    messages <<- paste(messages, x, sep = "")
  })

  expect_false(grepl("apple", messages))
  expect_false(grepl("banana", messages))
  expect_true(grepl("cherry", messages))

})

test_that("dotty doesn't create a variable called '..'", {
  
  .[a, .., z] <- letters
  expect_equal(a, "a")
  expect_equal(z, "z")
  expect_false(exists(".."))
  
})

test_that("we require all arguments to be named or unnamed", {
  
  expect_error({
    data <- list(w = 1, x = 2, y = 3, z = 4)
    .[apple = x, banana] <- data
  })
  
})
