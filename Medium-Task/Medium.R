# Use fread() from the data.table package with a command-line grep statement to count rows matching the 'VS' pattern.
library(data.table)
# Loading diamonds
data(diamonds)
# writing diamonds data so It cna be written to a file
diamonds_file_data <- as.data.frame(diamonds)

#setting working directory to write the csv
getwd()
setwd("/home/gnaran/code/grepreaper/Medium-Task")

#writing the csv
write.csv(diamonds_file_data,file='diamonds.csv')


#using fread with cmd grep to find matching rows
vs_rows<- fread(cmd = "grep 'VS' diamonds.csv")

#counting rows
count_vs<- nrow(vs_rows)
# 29150 rows containing vs
print(count_vs)
