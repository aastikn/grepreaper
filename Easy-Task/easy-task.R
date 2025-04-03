library(ggplot2)
library(data.table)

# Loading the diamonds dataset
data(diamonds)

# Using grep function to find rows with VS in the data table 
matching_rows <- diamonds[apply(diamonds, 1, function(row) {
  any(grepl("VS", as.character(row)))
}), ]

# Counting rows that have the pattern
pattern_count <- nrow(matching_rows)

print(paste("Number of rows containing 'VS':", pattern_count))
