# Code Book

This document describes the variables, data, and transformations performed to tidy the data associated with the course project.

The code is annotated with steps (e.g. Step 1, Step 2, etc.) and substeps (e.g 1.1, 1.2, etc) that correspond to the project description steps.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Step 0: Load the necessary R libraries
This project makes use of the following R libraries:

* library(data.table)
* library(dplyr)
* library(dtplyr)

## Step 1: Merging training and test datasets

### 1.1 Get the zip file Url to download from.
Variable | Description 
---------|-------------
fileUrl | "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

### 1.2 Download zip file.
File | Description
-----|------------
human_activity_data.zip | zipped project data

### 1.3 Unzip to "UCI HAR Dataset" directory
See the UCI HAR Dataset/README.txt file for details about the dataset.

The train subdirectory contains the training data, labels, and subjects.
The test subdirectory contains the test data, labels, and subjects.

### 1.4 Create variables to point to files of interest.
Name | Filepath | Description
-----|----------|------------
train_data_file | ./UCI HAR Dataset/train/X_train.txt | training data
train_labels_file | ./UCI HAR Dataset/train/y_train.txt | training labels
train_subjects_file | ./UCI HAR Dataset/train/subject_train.txt | training subjects 
test_data_file | ./UCI HAR Dataset/test/X_train.txt | test data
test_labels_file | ./UCI HAR Dataset/test/y_train.txt | test labels
test_subjects_file | ./UCI HAR Dataset/test/subject_train.txt | test subjects 
features_file | ./UCI HAR Dataset/features.txt | feature indices and names
activity_labels_file | ./UCI HAR Dataset/activity_labels.txt | activity indices and names

### 1.5 Read in the training data
Using R function read.table() with stringsAsFactors = FALSE

Variable | Description | Class
---------|-------------|------
trd | training data | data.frame
trl | training labels | data.frame
trs | training subjects | data.frame

### 1.6 Apply the descriptive column names "activity" and "subject" to the trl and trs data frames.
Using R function colnames().

### 1.7 Merge the training subjects, labels, and data by column. 
Using R function cbind().

Variable | Description | Class
---------|-------------|------
trlsd | column merged training labels, subjects, data  | data.frame

### 1.8 Add a type column to the training data. 
Used to distinguish from test data.
Using dplyr function mutate() and R function cbind().

Variable | Description | Class
---------|-------------|------
trlsd | column merged training type, labels, subjects, data  | data.frame

### 1.9 Read in the test data
Using R function read.table() with stringsAsFactors = FALSE

Variable | Description | Class
---------|-------------|------
ted | training data | data.frame
tel | training labels | data.frame
tes | training subjects | data.frame

### 1.10 Apply the descriptive column names "activity" and "subject" to the tel and tes data frames.
Using R function colnames().

### 1.11 Merge the test subjects, labels, and data by column.
Using R function cbind().

Variable | Description | Class
---------|-------------|------
telsd | column merged test labels, subjects, data  | data.frame

### 1.12 Add a type column to the test data. Used to distinguish from training data.
Using dplyr function mutate() and R function cbind().

Variable | Description | Class
---------|-------------|------
telsd | column merged test type, labels, subjects, data  | data.frame

### 1.13 Merge the training and test data by row.
Using R function rbind().

Variable | Description | Class
---------|-------------|------
lsd | row merged training (trlsd) and test (tesld) data | data.frame

## Step 2: Extract only the measurements for mean and std
The general strategy is to extract the needed indices and labels from the features.txt file included with the dataset.

### 2.1 Get feature names and indices
Using R function read.table() with stringsAsFactors = FALSE

Variable | Description | Class
---------|-------------|------
feat | index and name for each feature in the dataset | data.frame

### 2.2 Convert feat data.frame to a data.table in preparation for further processing.
Using data.table function as.data.table().

Variable | Description | Class
---------|-------------|------
feat_table | table of index and name for every feature in the dataset | data.table data.frame

### 2.3 Extract indices for mean and std features.
Subsetting using the R function grep() with arguments pattern="mean|std" and ignore.case=TRUE
 
Variable | Description | Class
---------|-------------|------
msidx | table of index and name for mean and std features in the dataset | data.table data.frame

### 2.4 Subset the data to include only the fixed variable (type, activity, subject), mean, and std columns.
Using R subsetting and cbind().

Variable | Description | Class
---------|-------------|------
lsdsubset | mean/std subset of training/test data | data.frame

## Step 3: Add Descriptive Activity Names
The general strategy is to extract the needed indices and names from the activity_labels.txt file included with the dataset.

### 3.1 Read in the activity_labels.txt file
Using R function read.table() with stringsAsFactors = FALSE

Variable | Description | Class
---------|-------------|------
actlabels | table of activity indices and names | data.frame

### 3.2 Replace the activity indices with the descriptive activity names as factors.
Using dplyr function mutate().

Variable | Description | Class
---------|-------------|------
lsdsubset$activity | factor variable with descriptive activity names | factor

Index | Factor
------|-------
1 | WALKING
2 | WALKING_UPSTAIRS
3 | WALKING_DOWNSTAIRS
4 | SITTING
5 | STANDING
6 | LAYING

## Step 4: Add Descriptive Variable Names
The general strategy here is to extract the names from the msidx table created in step 2.3.
Non-alphanumeric characters are stripped from the variable names to avoid issues related to special characters.

### 4.1 Get rid of all the non-alphanumeric characters in the names of the features.
Using the R function gsub().

Variable | Description | Class
---------|-------------|------
msidx | table of indices and names for mean and std features in the dataset | data.table data.frame

msidx detail:
idx | feature
------|------------
1 | tBodyAccmeanX
2 | tBodyAccmeanY
3 | tBodyAccmeanZ
4 | tBodyAccstdX
5 | tBodyAccstdY
6 | tBodyAccstdZ
41 | tGravityAccmeanX
42 | tGravityAccmeanY
43 | tGravityAccmeanZ
44 | tGravityAccstdX
45 | tGravityAccstdY
46 | tGravityAccstdZ
81 | tBodyAccJerkmeanX
82 | tBodyAccJerkmeanY
83 | tBodyAccJerkmeanZ
84 | tBodyAccJerkstdX
85 | tBodyAccJerkstdY
86 | tBodyAccJerkstdZ
121 | tBodyGyromeanX
122 | tBodyGyromeanY
123 | tBodyGyromeanZ
124 | tBodyGyrostdX
125 | tBodyGyrostdY
126 | tBodyGyrostdZ
161 | tBodyGyroJerkmeanX
162 | tBodyGyroJerkmeanY
163 | tBodyGyroJerkmeanZ
164 | tBodyGyroJerkstdX
165 | tBodyGyroJerkstdY
166 | tBodyGyroJerkstdZ
201 | tBodyAccMagmean
202 | tBodyAccMagstd
214 | tGravityAccMagmean
215 | tGravityAccMagstd
227 | tBodyAccJerkMagmean
228 | tBodyAccJerkMagstd
240 | tBodyGyroMagmean
241 | tBodyGyroMagstd
253 | tBodyGyroJerkMagmean
254 | tBodyGyroJerkMagstd
266 | fBodyAccmeanX
267 | fBodyAccmeanY
268 | fBodyAccmeanZ
269 | fBodyAccstdX
270 | fBodyAccstdY
271 | fBodyAccstdZ
294 | fBodyAccmeanFreqX
295 | fBodyAccmeanFreqY
296 | fBodyAccmeanFreqZ
345 | fBodyAccJerkmeanX
346 | fBodyAccJerkmeanY
347 | fBodyAccJerkmeanZ
348 | fBodyAccJerkstdX
349 | fBodyAccJerkstdY
350 | fBodyAccJerkstdZ
373 | fBodyAccJerkmeanFreqX
374 | fBodyAccJerkmeanFreqY
375 | fBodyAccJerkmeanFreqZ
424 | fBodyGyromeanX
425 | fBodyGyromeanY
426 | fBodyGyromeanZ
427 | fBodyGyrostdX
428 | fBodyGyrostdY
429 | fBodyGyrostdZ
452 | fBodyGyromeanFreqX
453 | fBodyGyromeanFreqY
454 | fBodyGyromeanFreqZ
503 | fBodyAccMagmean
504 | fBodyAccMagstd
513 | fBodyAccMagmeanFreq
516 | fBodyBodyAccJerkMagmean
517 | fBodyBodyAccJerkMagstd
526 | fBodyBodyAccJerkMagmeanFreq
529 | fBodyBodyGyroMagmean
530 | fBodyBodyGyroMagstd
539 | fBodyBodyGyroMagmeanFreq
542 | fBodyBodyGyroJerkMagmean
543 | fBodyBodyGyroJerkMagstd
552 | fBodyBodyGyroJerkMagmeanFreq
555 | angletBodyAccMeangravity
556 | angletBodyAccJerkMeangravityMean
557 | angletBodyGyroMeangravityMean
558 | angletBodyGyroJerkMeangravityMean
559 | angleXgravityMean
560 | angleYgravityMean
561 | angleZgravityMean

### 4.2 Apply the feature names as names of variable columns.
Using R function colnames().

### 4.3 Reorder the dataset.

_Aside: While the instructions don't explicity require a specific ordering of the data, 
tidy principles dictate that it should be ordered by the fixed variables. Here it makes 
sense to order by type first, as in most real world analysis, one would want to
separate the training and test data. Next, order by activity, as it seems likely that 
the intent may be to use data across many subjects for a given activity to derive 
some generalized model for that activity. Finally, order by subject._

Using the dplyr function arrange().

Variable | Description | Class
---------|-------------|------
lsdsubset | mean and std data ordered by type/activity/subject | data.frame

## Step 5: Average for each variable by activity and subject
Note there are 6 activities and 30 subjects.

### 5.1 Group the data by subject and activity and generate summaries 
Using dplyr functions group_by() and summary() and the pipeline operator %>%.

Variable | Description | Class
---------|-------------|------
sumbysub | table of means of variables grouped by subject | tbl_df tbl data.frame
sumbyact | table of means of variables grouped by activity | tbl_df tbl data.frame

### 5.2 Make the grouping variable a factor with descriptive names
Using dplyr function mutate and R function factor().

sumbyact$activity factors:
index | value
------|------
1 | Mean of WALKING
2 | Mean of WALKING_UPSTAIRS
3 | Mean of WALKING_DOWNSTAIRS
4 | Mean of SITTING
5 | Mean of STANDING
6 | Mean of LAYING

sumbysub$subject factors:
index | value
------|------
1 | Mean of Subject 1
2 | Mean of Subject 2
3 | Mean of Subject 3
4 | Mean of Subject 4
5 | Mean of Subject 5
6 | Mean of Subject 6
7 | Mean of Subject 7
8 | Mean of Subject 8
9 | Mean of Subject 9
10 | Mean of Subject 10
11 | Mean of Subject 11
12 | Mean of Subject 12
13 | Mean of Subject 13
14 | Mean of Subject 14
15 | Mean of Subject 15
16 | Mean of Subject 16
17 | Mean of Subject 17
18 | Mean of Subject 18
19 | Mean of Subject 19
20 | Mean of Subject 20
21 | Mean of Subject 21
22 | Mean of Subject 22
23 | Mean of Subject 23
24 | Mean of Subject 24
25 | Mean of Subject 25
26 | Mean of Subject 26
27 | Mean of Subject 27
28 | Mean of Subject 28
29 | Mean of Subject 29
30 | Mean of Subject 30


### 5.3 Rename the grouping columns to "SummaryStatistic" so the tables can be joined
Using R function colnames().

### 5.4 Combine the summary tables into a single table.
Using R function rbind().

Variable | Description | Class
---------|-------------|------
summarydata | combined table of grouped means | tbl_df tbl data.frame
summarydata[1:6,] | table of means of variables grouped by activity | tbl_df tbl data.frame
summarydata[7:36,] | table of means of variables grouped by subject | tbl_df tbl data.frame

summarydata$SummaryStatistic factor: 
index | value
------|------
1 | Mean of WALKING
2 | Mean of WALKING_UPSTAIRS
3 | Mean of WALKING_DOWNSTAIRS
4 | Mean of SITTING
5 | Mean of STANDING
6 | Mean of LAYING
7 | Mean of Subject 1
8 | Mean of Subject 2
9 | Mean of Subject 3
10 | Mean of Subject 4
11 | Mean of Subject 5
12 | Mean of Subject 6
13 | Mean of Subject 7
14 | Mean of Subject 8
15 | Mean of Subject 9
16 | Mean of Subject 10
17 | Mean of Subject 11
18 | Mean of Subject 12
19 | Mean of Subject 13
20 | Mean of Subject 14
21 | Mean of Subject 15
22 | Mean of Subject 16
23 | Mean of Subject 17
24 | Mean of Subject 18
25 | Mean of Subject 19
26 | Mean of Subject 20
27 | Mean of Subject 21
28 | Mean of Subject 22
29 | Mean of Subject 23
30 | Mean of Subject 24
31 | Mean of Subject 25
32 | Mean of Subject 26
33 | Mean of Subject 27
34 | Mean of Subject 28
35 | Mean of Subject 29
36 | Mean of Subject 30

### 5.5 Write the output file
Using R function write.table() with row.names=FALSE

Name | Description
-----|------------
cleaning_data_project.txt | Output file, includes summary data grouped by activity and subject.

Note to reviewers:
The output file can be read into R with:

```R
    outfile <- "./cleaning_data_project.txt"
    valdata <- read.table(outfile, header=TRUE)
```    