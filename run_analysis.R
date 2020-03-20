fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

# If file does not exist, download to working directory.
if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}

# If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

# check if data.table and reshape2 packages are installed
if (!"data.table" %in% installed.packages()) {
  install.packages("data.table")
}
if (!"reshape2" %in% installed.packages()) {
  install.packages("reshape2")
}
library("data.table")
library("reshape2")


# Read Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt") 

#1. Merge train and test datasets
data <- rbind(X_train, X_test)

#2. Extract only mean and standard deviation measurements
Mean_Std <- grep("mean()|std()", features[, 2]) 
data <- data[,Mean_Std]

# 4. Appropriately labels the data set with descriptive activity names.
FeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(data) <- FeatureNames[Mean_Std]

# combine test and train of subject data and activity data, assign descriptive lables
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

# combine subject, activity, and mean and std only data set to create final data set.
data <- cbind(subject,activity, data)


#3. Uses descriptive activity names to name the activities in the data set
# group the activity column of dataSet, re-name lable of levels with activity_levels, and apply it to dataSet.
act_group <- factor(data$activity)
levels(act_group) <- activity_labels[,2]
data$activity <- act_group

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# melt data and cast means
MeltData <- melt(data,(id.vars=c("subject","activity")))
TidyDataSet <- dcast(MeltData, subject + activity ~ variable, mean)
names(TidyDataSet)[-c(1:2)] <- paste("[mean of]", names(TidyDataSet)[-c(1:2)])
  
# Write to "tidy_data.txt" file
write.table(TidyDataSet, "tidy_data.txt", sep = ",")