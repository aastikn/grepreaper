library(testthat)
library(myPackage)

test_that("count_rows_with_pattern_parallel works correctly", {
  result <- count_rows_with_pattern_parallel("VS", ignore_case = TRUE)
  expect_is(result, "numeric")
  expect_gt(result, 0)  # Assuming there are rows matching the pattern
})

