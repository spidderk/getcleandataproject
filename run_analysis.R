# get the needed libraries -- if these are not installed, call:
# install.packages("data.table")
# install.packages("dplyr")
# install.packages("dtplyr")

library(data.table)
library(dplyr)
library(dtplyr)

# Additional Information:
# See the README.md file for additional details regarding this course project.
#
# See the CodeBook.md file for detailed description of the variables, data, 
# and transformations performed to clean up the data. 

# Step 1: Merge the training and test sets and create one data set

# 1.1 Get the URL for the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# The project instructions mention that scripts should assume that the data file should
# exist in the working directory, so don't create a separate data directory and just
# download the file to the current working directory.

# 1.2: If the data file does not yet exist locally, download the data, else skip
print("Downloading and unzipping data file if needed.")
if (!file.exists("./human_activity_data.zip")) {
  download.file(fileUrl,"./human_activity_data.zip",method="curl")
}

# 1.3: If the unzipped data file does not exist, unzip the file
if (!dir.exists("./UCI HAR Dataset")) {
  unzip("./human_activity_data.zip", exdir="./")
}

# At this point the extracted data has been unzipped to a directory tree
# structurre with the root directory of UCI HAR Dataset. Within this tree
# are the train and test directories which contain the training and test
# data and labels.

# 1.4: Create variables with paths to the files of interest
train_data_file <- "UCI HAR Dataset/train/X_train.txt"
train_labels_file <- "UCI HAR Dataset/train/y_train.txt"
train_subjects_file <- "UCI HAR Dataset/train/subject_train.txt"
test_data_file <- "UCI HAR Dataset/test/X_test.txt"
test_labels_file <- "UCI HAR Dataset/test/y_test.txt"
test_subjects_file <- "UCI HAR Dataset/test/subject_test.txt"
features_file <- "UCI HAR Dataset/features.txt"
activity_labels_file <- "UCI HAR Dataset/activity_labels.txt"

# 1.5 Read in the training data, labels, and subjects
print("Reading in and merging data")
trd <- read.table(train_data_file, sep="", stringsAsFactors = FALSE)
trl <- read.table(train_labels_file, sep="", stringsAsFactors = FALSE)
trs <- read.table(train_subjects_file, sep="", stringsAsFactors = FALSE)

# 1.6 Name labels column "activity" as this is more descriptive.
# Name the subjects column "subjects".
# The activity column is used later when giving the activities 
# more decriptive names (step 3).
colnames(trl) <- "activity"
colnames(trs) <- "subject"

# 1.7 Merge the training labels, subjects, and data by column.
# One aspect of tidy data is to place all the fixed variables to the left and measured
# or computed variables to the right. This merge order places the fixed variable columns
# (subject, activity, type) on the left. 
trlsd <- cbind(trl,trs,trd)

# 1.8 Add a "type" column to the data and set colname equal to "train".
# Since the training and test data will be merged, this introduces a means of 
# distinguishing training from test observations after the row merge below (1.13).
# Make this the leftmost column.
trlsd <- mutate(trlsd, type="train")
nc <- ncol(trlsd)
trlsd <- cbind(trlsd[nc],trlsd[1:nc-1])

# 1.9 Read in the test data, labels, and subjects and rename columns
ted <- read.table(test_data_file, sep="", stringsAsFactors = FALSE)
tel <- read.table(test_labels_file, sep="", stringsAsFactors = FALSE)
tes <- read.table(test_subjects_file, sep="", stringsAsFactors = FALSE)

# 1.10 Rename columns to match train dataset
colnames(tel) <- "activity"
colnames(tes) <- "subject"

# 1.11 Merge the test data, labels, and subjects by column
telsd <- cbind(tel, tes, ted)

# 1.12 Add a "type" column to the test data and set equal to "test"
telsd <- mutate(telsd, type="test")
nc <- ncol(telsd)
telsd <- cbind(telsd[nc],telsd[1:nc-1])

# 1.13 Merge the train and test data by row
lsd <- rbind(trlsd,telsd)

# Step 1 Result: lsd contains the merged training and test datasets

# Step 2: Extract only the measurements for mean and std for each measurement.
print("Extracting means and stds")

# 2.1 Read in the features.txt file to get feature names and column numbers.
# The indices will be useful in subsetting the data for the mean and std columns.
# The feature names will be used to name the data columns (Step 4) after a little tidying.
feat <- read.table(features_file, sep="", stringsAsFactors = FALSE)
colnames(feat) <- c("idx","feature")

# Select only the mean and std columns from the train/test data
# Note that we added 3 fixed variable columns to the original train/test data 
# (subject, activity, type), so also retain these (the 3 leftmost columns).

# 2.2 First, create a data.table from the feat data frame (so we can use grep to subset)
feat_table <- as.data.table(feat)

# 2.3 Use grep to get indices of the features that contain "mean" or "std" (ignoring case).
msidx <- feat_table[grep("mean|std",feature,ignore.case=TRUE)]

# 2.4 Subset the data frame: first three columns plus all mean/std columns
# Use the idx from the msidx variable above to get the relevant column indices,
# but ofset by three to account for the first three fixed variable columns.
lsdsubset <- cbind(lsd[,1:3],lsd[,msidx$idx+3])

# At this point, the data contains only fixed variables and the mean and std data.
# Do a sanity check on dimensions. Note the bulk of the columns are not yet named.
print("Dimensions of dataset filtered for mean and std data:")
print(dim(lsdsubset))

# Safe to remove large table dls at this point.
rm("lsd")

# Step 2 Result: lsdsubset contains the dataset filtered for only the mean and std columns.

# Step 3: Add Descriptive Activity Names
print("Adding descriptive activity names")

# 3.1 Read in the activity_labels.txt file
actlabels <- read.table(activity_labels_file, sep="", stringsAsFactors = FALSE)
colnames(actlabels) <- c("idx","activity")

# 3.2 Replace the activity indices with the descriptive activity names as factors
lsdsubset <- mutate(lsdsubset, activity = factor(activity,labels=actlabels$activity))

# Step 3 Result: lsdsubset activities coulumn contains named factors

# Step 4: Add Descriptive Variable Names
print("Adding descriptive variable names")

# Note this was partially completed earlier by extracting the variable names from the 
# features.txt file. See steps 2.1-2.2 above.
# The variable names will be the original descriptive names provided with the data set
# as described in the features_info.txt file, minus any non-alphanumeric characters (as
# special characters can be problematic some R functions).

# 4.1 Get rid of all the non-alphanumeric characters in the names of the features
msidx$feature <- gsub("[^[:alnum:]]","",msidx$feature)

# 4.2 Apply the feature names as names of variable columns (retaining the names of the
# fixed variables in the first three columns).
colnames(lsdsubset) <- c("type", "activity", "subject", msidx$feature)

# List the variable names as a sanity check
print("Variables retained:")
print(names(lsdsubset))

# 4.3 While the instructions don't explicity require a specific ordering of the data,
# tidy principles dictate that it should be ordered by the fixed variables. Here it
# makes sense to order by type first, as in most real world analysis, one would want to
# separate the training and test data. Next, order by activity, as it seems likely that 
# the intent may be to use data across many subjects for a given activity to derive 
# some generalized modelfor that activity. Finally, order by subject. 
lsdsubset <- arrange(lsdsubset, desc(type), activity, subject)

# Step 4 Result: lsdsubset contains merged dataset with descriptive variable names
# At this point, the data set can be considered tidy:
# - Variables in columns.
# - Fixed variables to the left.
# - Observations in rows (sorted by type/activity/subject).
# - One type of observation (a statistical summary, e.g. mean or std) per table

# Step 5: Average for each variable by activity (6) and subject (30)
print("Creating summary data")

# 5.1 Group the data by subject and activity and generate summaries using dplyr.
# Remove any unnecessary grouping variables. Make use of pipeline operator (%>%).
sumbysub <- lsdsubset %>% group_by(subject) %>% 
            summarize_each(funs(mean(., na.rm=TRUE)), -type, -activity)
sumbyact <- lsdsubset %>% group_by( activity) %>%
            summarize_each(funs(mean(., na.rm=TRUE)), -type, -subject)

# 5.2 Make the grouping variable factors with descriptive names
sumbysub <- mutate(sumbysub, subject = factor(subject,labels=paste("Mean of Subject",seq(1:30))))
sumbyact <- mutate(sumbyact, activity = factor(activity,labels=paste("Mean of",actlabels$activity)))

# 5.3 Rename the grouping columns to "SummaryStatistic" so the tables can be joined 
# by row using rbind.
colnames(sumbysub)[1] <- "SummaryStatistic"
colnames(sumbyact)[1] <- "SummaryStatistic"

# 5.4 Combine the summary tables into a single table.
summarydata <- rbind(sumbyact,sumbysub)

# Here we have a tidy table, where the SummaryStatistic column gives a clear indication
# of what each row in the table represents (group means) and each remaining column provides the 
# values for the group means. 

# Note the submission instructions indicate that rownames not be included, so it does 
# not make sense to try to manipulate the data further (for example, changing to a data frame and 
# adding row names).

# The activity means are ordered as per the factor order described in
# activity_labels.txt and the subject means are order by subject number 1-30.

# 5.5 Write the output file as required for submission
outfile <- "./cleaning_data_project.txt"
write.table(summarydata, file=outfile, row.names=FALSE)

print("Summary data written to:")
print(outfile)

# Step 5 Result: The summary dataset has been written to cleaning_data_project.txt.

# To read the file back in for validation
#valdata <- read.table(outfile, header=TRUE)
