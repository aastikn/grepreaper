library(ggplot2)
library(data.table)

# Loading the diamonds dataset
data(diamonds)

# Converting the dataset to a data table for better manipulation
diamonds_table <- as.data.table(diamonds)

# Using grep function to find rows with VS in the data table 
matching_rows <- diamonds_table[grep('VS', clarity)]

# Counting rows that have the pattern
pattern_count <- nrow(matching_rows)

print(paste("Number of rows containing 'VS':", pattern_count))
