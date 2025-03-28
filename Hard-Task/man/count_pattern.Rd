\name{count_rows_with_pattern_parallel}
\alias{count_rows_with_pattern_parallel}
\title{Count Rows Containing a Specific Pattern Using grep in Parallel}
\description{
    This function counts the number of rows in the `diamonds` dataset where the user-specified pattern is found.
    It uses a temporary buffer and processes the data in parallel to speed up the operation.
}
\usage{
count_rows_with_pattern_parallel(pattern, ignore_case = FALSE, num_cores = detectCores())
}
\arguments{
  \item{pattern}{A character string specifying the pattern to search for within the dataset rows.}
  \item{ignore_case}{Whether to ignore case (default: FALSE).}
  \item{num_cores}{The number of cores to use for parallel processing (default: number of available cores).}
}
\value{
  An integer representing the number of rows in the `diamonds` dataset where the user-specified pattern is found.
}
\examples{
count_rows_with_pattern_parallel("VS")
}

