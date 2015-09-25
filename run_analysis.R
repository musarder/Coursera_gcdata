## Set the working directory
if (!dir.exists("gcdata")) {
  dir.create("gcdata")
} 
setwd("gcdata/")

## Download and unzip the file
if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
}
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

## Read the datasets
 
training_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
training_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
training_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_labels <-read.table("./UCI HAR Dataset/activity_labels.txt")

## Merge training and test sets
subjects <- rbind(training_subject, test_subject)
activity <- rbind(training_y, test_y)
datatable <- rbind(training_x, test_x)

## Add the activity names column
activity$ActivityName <- activity_labels[activity$V1, 2]

## Add column names
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(datatable) <- features$V2

## Merge all the tables
activity_subjects <- cbind(activity, subjects)
colnames(activity_subjects) <- c("Activity No.","Activity Name","Subject")
datatable <- cbind(activity_subjects, datatable)

## Extract the mean and standard deviation
features.mean.std <- grep("mean\\(\\)|std\\(\\)", features$V2, value=TRUE)
features.mean.std <- union(c("Activity No.","Activity Name","Subject"), features.mean.std)
datatable1 <- subset(datatable, select = features.mean.std)

## Appropriately labels the data set with descriptive variable names
names(datatable1) <- gsub("std()", "SD", names(datatable1))
names(datatable1) <- gsub("mean()", "MEAN", names(datatable1))
names(datatable1) <- gsub("^t", "Time_", names(datatable1))
names(datatable1) <- gsub("^f", "Frequency_", names(datatable1))
names(datatable1) <- gsub("Acc", "Accelerometer_", names(datatable1))
names(datatable1) <- gsub("Gyro", "Gyroscope_", names(datatable1))
names(datatable1) <- gsub("Mag", "Magnitude_", names(datatable1))
names(datatable1) <- gsub("BodyBody", "Body_", names(datatable1))

## Create a tidy data set
write.table(datatable1, "tidydata.txt", row.name=FALSE)

