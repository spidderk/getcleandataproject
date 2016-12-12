# Course Project for Getting and Cleaning Data
## Introduction
This repo contains the R script and descriptions necessary to complete the course project for the [Getting and Cleaning Data]() course.

All of the code necessary to complete the project is contained in the [run_analysis.R](./run_analysis.R) script.

The script performs the following steps, as per the project guidelines:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

See the [./CodeBook.md](./CodeBook.md) file for additional information about the variables, data, and transformations used to complete the project.

## Instructions to Run
1. Clone this repo
2. Start R and source the script: 
```R
    source("run_analysis.R")
```
3. Look at final result at ./cleaning_data_project.txt


## Further Instructions for Assessors
The final (Step 5) summary data is included in the cleaning_data_project.txt file.
1. Copy this file to your working directory.
2. open the file in R with:
```R
    outfile <- "./cleaning_data_project.txt"
    sumdata <- read.table(outfile, header=TRUE)
```
3. See [CodeBook.md](./CodeBook.md) for a description of the data and variables.


