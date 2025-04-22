# GrepReaper

A project demonstrating different approaches to pattern matching in R with increasing levels of complexity.

## Tasks Overview

This repository contains implementations of three tasks with increasing difficulty, all focused on counting rows of data that match a specific pattern:

1. **Easy**: Using R's native `grep()` function
2. **Medium**: Using `data.table`'s `fread()` with a command-line grep statement
3. **Hard**: Creating a full R package with Rd files, tests, and vignettes

## Easy Task: Using R's Native grep() Function

This approach uses R's built-in `grep()` function to identify rows in the diamonds dataset that match the pattern 'VS'.

```r
# Load required packages
library(ggplot2)
library(data.table)

# Load the diamonds dataset
data(diamonds)

# Convert the data to a character format for pattern matching
diamonds_text <- apply(diamonds, 1, paste, collapse = ",")

# Use grep to find rows with pattern 'VS'
matching_rows <- grep("VS", diamonds_text)

# Count the matching rows
count_vs <- length(matching_rows)
print(count_vs)
```

This approach is straightforward but requires loading all the data into memory and performing the matching within R, which can be memory-intensive for large datasets.

## Medium Task: Using fread() with Command-line grep

This approach leverages the system's grep command through `data.table::fread()` for improved performance:

```r
# Load required packages
library(data.table)
library(ggplot2)

# Load the diamonds dataset
data(diamonds)

# Write the data to a temporary CSV file
tmp_file <- tempfile(fileext = ".csv")
write.csv(diamonds, file = tmp_file, row.names = FALSE)

# Use fread with cmd parameter to count rows with 'VS'
vs_rows <- fread(cmd = paste0("grep 'VS' ", tmp_file))

# Count the rows
count_vs <- nrow(vs_rows)
print(count_vs)

# Clean up
unlink(tmp_file)
```

This method is more efficient for large datasets as it leverages the system's grep command, which is optimized for pattern matching operations.

## Hard Task: Creating an R Package

For the hard task, I've created a full R package called `countrows` that provides a function to efficiently count rows matching a pattern using system commands.

### Package Structure

```
├── countrows
│   ├── countrows.Rproj
│   ├── cran-comments.md
│   ├── DESCRIPTION
│   ├── Hard-Task.Rproj
│   ├── man
│   │   └── count_rows_with_pattern.Rd
│   ├── NAMESPACE
│   ├── NEWS.md
│   ├── R
│   │   └── count_pattern.R
│   ├── tests
│   │   ├── testthat
│   │   │   └── test_count_patterns.R
│   │   └── testthat.R
│   └── vignette
│       └── introduction.Rmd
└── DESCRIPTION
```

### Installation

```r
# Install from the local directory
install.packages("/home/gnaran/code/grepreaper/Hard-Task", repos = NULL, type = "source")

# Or using devtools
# devtools::install_local("/home/gnaran/code/grepreaper/Hard-Task")
```

### Usage

```r
library(countrows)
library(ggplot2)

# Load the diamonds dataset
data(diamonds)

# Count rows with 'VS' pattern
vs_count <- count_rows_with_pattern("VS", diamonds)
print(vs_count)

# Case-insensitive search
vs_count_case_insensitive <- count_rows_with_pattern("vs", diamonds, ignore_case = TRUE)
print(vs_count_case_insensitive)
```
### Code: 
```
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
```

### Key Features

- **Memory Efficient**: Writes data to a temporary file and uses the system's grep command for pattern matching.
- **Fast**: Leverages optimized system utilities instead of in-memory R operations.
- **Flexible**: Supports case-insensitive searching and works with any data frame.

### Package Details

The main function `count_rows_with_pattern()` performs the following operations:
1. Validates the input parameters
2. Writes the data frame to a temporary file
3. Uses the system's `grep -o` command to count occurrences of the pattern
4. Cleans up the temporary file
5. Returns the count as an integer

This approach combines the best of R's data manipulation capabilities with the efficiency of system commands for pattern matching.

## Comparing the Approaches

| Approach | Memory Usage | Performance | Complexity | Best For |
|----------|--------------|-------------|------------|----------|
| Easy | High | Slow for large datasets | Low | Small datasets, quick analyses |
| Medium | Medium | Better for large datasets | Medium | Medium to large datasets |
| Hard | Low | Most efficient | High | Production environments, very large datasets |


```
