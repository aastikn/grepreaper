#' Count Rows Containing a Specific Pattern Using grep in Parallel
#'
#' @param pattern A character string specifying the pattern to search for within the dataset rows.
#' @param data The dataset or dataframe in which to search for the pattern. (Default is `NULL`).
#' @param ignore_case Whether to ignore case (default: FALSE).
#' @param num_cores The number of cores to use for parallel processing (default: number of available cores).
#'
#' @return An integer representing the number of rows in the dataset where the user-specified pattern is found.
#'
#' @examples
#' count_rows_with_pattern_parallel("VS", data = diamonds)
#'
#' @import data.table ggplot2 parallel
#' @export
count_rows_with_pattern_parallel <- function(pattern, data = NULL, ignore_case = FALSE, num_cores = detectCores()) {
  # Default to diamonds dataset if no data is provided
  if (is.null(data)) {
    data <- ggplot2::diamonds
  }
  
  # Ensure the provided data is a data.table
  dt <- as.data.table(data)
  
  # Create an in-memory connection (temporary buffer)
  temp_conn <- rawConnection(raw(0), "r+")
  
  # Write the dataset to the temporary connection (in-memory)
  fwrite(dt, temp_conn)
  
  # Create a temporary file buffer and reset the pointer
  seek(temp_conn, 0)
  
  # Function to perform grep on a subset of the data
  grep_parallel_function <- function(data_chunk) {
    grep_cmd <- paste("grep", if (ignore_case) "-i" else "", shQuote(pattern))
    result <- fread(cmd = paste(grep_cmd, "<<<", shQuote(data_chunk)))
    return(nrow(result))
  }
  
  # Read data in chunks (simulate chunking by reading a portion of the file into a buffer)
  chunk_size <- 100000  # Adjust chunk size as needed
  data_chunks <- list()
  
  while (TRUE) {
    # Read the next chunk of data into the in-memory buffer
    data_chunk <- readBin(temp_conn, "character", n = chunk_size)
    if (length(data_chunk) == 0) break  # Exit if no data is left
    
    data_chunks <- append(data_chunks, list(data_chunk))
  }
  
  # Parallelize the grep processing across multiple chunks
  matching_rows <- mclapply(data_chunks, grep_parallel_function, mc.cores = num_cores)
  
  # Return the total number of matching rows
  return(sum(unlist(matching_rows)))
}
