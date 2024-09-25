
# dotty 0.2.0  (UNRELEASED)

- Fixed an issue where invocations like `.[a, .., z] <- letters` would
  also create a binding called `..`. (#4)

- `dotty` now requires all arguments within a `.[]` invocation to be
  either named or unnamed -- that is, `.[a = a, b] <- c(a = "a", b = "b")`
  are now disallowed. This may be relaxed in a future release. (#3)

- `dotty::dotify()` is now exported for use by R packages which would
  like to use `dotty` internally. (#1)


# dotty 0.1.0

- Initial CRAN release.
