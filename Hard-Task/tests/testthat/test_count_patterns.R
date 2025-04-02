library(testthat)
library(countrows)
library(data.table)

test_that("count_rows_with_pattern handles valid input", {
  df <- data.frame(text = c("apple", "banana", "apple pie", "orange"))
  expect_equal(count_rows_with_pattern("apple", data = df), 2L)
  expect_equal(count_rows_with_pattern("APPLE", data = df, ignore_case = TRUE), 2L)
  expect_equal(count_rows_with_pattern("grape", data = df), 0L)
  expect_equal(count_rows_with_pattern("^apple", data = df), 1L)
})

test_that("count_rows_with_pattern handles data.table input", {
  dt <- data.table(text = c("apple", "banana", "apple pie", "orange"))
  expect_equal(count_rows_with_pattern("apple", data = dt), 2L)
})

test_that("count_rows_with_pattern handles default diamonds data", {
  skip_if_not_installed("ggplot2")
  library(ggplot2)
  expect_equal(count_rows_with_pattern("VS", data = diamonds), 29150L)
  expect_equal(count_rows_with_pattern("Ideal", data = diamonds), 21551L)
})


test_that("count_rows_with_pattern handles missing ggplot2", {
  with_mock(
    `requireNamespace` = function(package, quietly) FALSE,
    {
      expect_error(
        count_rows_with_pattern("a", data = NULL),
        "Default dataset requires `ggplot2`. Please install it or provide your own `data`."
      )
    }
  )
})