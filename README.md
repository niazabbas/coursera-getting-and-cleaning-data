# Getting and Cleaning Data Course Project

The attached R script performs the following activities:

1. Loads Activity labels
2. Loads Subjects
3. Loads Test data
4. Merges Test data with corresponding Activity labels and Subjects
5. Loads Train data
6. Merges Train data with corresponding Activity labels and Subjects
7. Cleanup variable names
8. Remove all variables other than Means and Stds
9. Merges Test and Train data and creates a new data set
10. Calculates means of all variables for each Subject and Activity pair and creates a new data set
11. Write mean data set into a file "meanData.txt"