
test_that("dot works", {

  .[nr, nc] <- dim(mtcars)
  expect_equal(nr, 32)
  expect_equal(nc, 11)

})
