#' Count Rows Containing a Specific Pattern Using grep -c
#'
#' This function writes the input data frame to a temporary file,
#' uses the system's `grep -o` command to count the occurrences of the
#' user-specified pattern, and returns the count. It's designed to be
#' memory-efficient for large datasets compared to reading matches into R.
#'
#' @param pattern A character string specifying the pattern to search for within
#'   the dataset rows. Passed directly to `grep`.
#' @param data A data frame or data.table in which to search for the pattern.
#'   If `NULL` (the default), it will try to use `ggplot2::diamonds`.
#' @param ignore_case Logical. If `TRUE`, the `-i` flag is added to the `grep`
#'   command for case-insensitive matching (default: `FALSE`).
#'
#' @return An integer representing the number of rows in the data where the
#'   pattern is found. Returns `0L` if the pattern is not found or no matches are
#'   returned.
#'
#' @importFrom data.table fwrite as.data.table
#' @export
count_rows_with_pattern <- function(pattern, data = NULL, ignore_case = FALSE) {
  
  # --- Input Validation and Data Handling ---
  if (!is.character(pattern) || length(pattern) != 1 || nchar(pattern) == 0) {
    stop("`pattern` must be a non-empty character string.", call. = FALSE)
  }
  if (!is.logical(ignore_case) || length(ignore_case) != 1) {
    stop("`ignore_case` must be a single logical value (TRUE or FALSE).", call. = FALSE)
  }
  
  data_to_use <- data
  
  if (is.null(data)) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop("Default dataset requires `ggplot2`. Please install it or provide your own `data`.", call. = FALSE)
    }
    message("No data provided, using default ggplot2::diamonds dataset.")
    data_to_use <- ggplot2::diamonds
  }
  
  if (!is.data.frame(data_to_use)) {
    stop("`data` must be a data frame or NULL (to use default).", call. = FALSE)
  }
  
  # --- File Operations ---
  temp_file <- tempfile(fileext = ".txt")
  on.exit(unlink(temp_file, force = TRUE), add = TRUE)
  
  tryCatch({
    writeLines(paste(apply(data_to_use, 1, paste, collapse = ","), collapse = ""), temp_file)
  }, error = function(e) {
    stop("Error writing data to temporary file: ", e$message, call. = FALSE)
  })
  
  # --- Grep Command Execution ---
  grep_opts <- "-o" # Use -o to get only the matching parts
  if (ignore_case) {
    grep_opts <- paste(grep_opts, "-i")
  }
  
  cmd <- paste("grep", grep_opts, shQuote(pattern), shQuote(temp_file), "| wc -l")
  
  result_str <- tryCatch({
    system(cmd, intern = TRUE, ignore.stderr = TRUE)
  }, warning = function(w) {
    message("Warning during grep command execution: ", w$message)
    return("0")
  }, error = function(e) {
    stop("Error executing system command 'grep': ", e$message, "\nIs grep installed and in your system's PATH?", call. = FALSE)
  })
  
  if (length(result_str) != 1) {
    warning("grep command returned unexpected output. Assuming 0 matches.", call. = FALSE)
    return(0L)
  }
  
  result <- suppressWarnings(as.integer(result_str))
  
  if (is.na(result)) {
    warning("grep command did not return a valid integer count. Assuming 0 matches.", call. = FALSE)
    return(0L)
  }
  
  return(result)
}