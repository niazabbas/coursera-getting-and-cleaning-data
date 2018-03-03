#1. Loads Activity labels
#2. Loads Subjects
#3. Loads Test data
#4. Merges Test data with corresponding Activity labels and Subjects
#5. Loads Train data
#6. Merges Train data with corresponding Activity labels and Subjects
#7. Cleanup variable names
#8. Remove all variables other than Means and Stds
#9. Merges Test and Train data and creates a new data set
#10. Calculates means of all variables for each Subject and Activity pair and creates a new data set
#11. Write mean data set into a file "meanData.txt"

rm(list = ls(all = TRUE))
library(dplyr)
library(reshape2)

## Load Activity labels
activityLabels <- read.table("FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activityLabels) <- c("ActivityID", "ActivityName")

## Load test specific activity keys
testActivityKeys <- read.table("FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
names(testActivityKeys) <- c("ActivityID")

## Add activity labels to create key->value pairs for test data
testActivityData <- inner_join(testActivityKeys, activityLabels, by="ActivityID")
testActivityData <- subset(testActivityData, select = c(ActivityName))

## Load test specific subjects
subjectTest <- read.table("FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
names(subjectTest) <- c("Subject")

## Load features
allColumns <- read.table("FUCI HAR Dataset/UCI HAR Dataset/features.txt")
names(allColumns)[2] <- "Features"

## Tidy feature strings
allColumns$Features <- gsub("[-()]", "", allColumns$Features)
allColumns$Features <- gsub("mean", "Mean", allColumns$Features)
allColumns$Features <- gsub("std", "Std", allColumns$Features)

## Separate out only the Mean and Std features
filteredColumns <- grep(".*Mean.*|.*Std.*", allColumns[,2], value = TRUE)

## Load test data
testData <- read.table("FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

## Assign column names (features) to test data
names(testData) <- as.vector(allColumns$Features)

## Keep only the Mean and Std data for test
testData <- testData[,as.vector(filteredColumns)]

## Merge Subject and Activity columns with test data
testData <- cbind(testData, testActivityData)
testData <- cbind(testData, subjectTest)

## Load train data
trainActivityKeys <- read.table("FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
names(trainActivityKeys) <- c("ActivityID")

## Add activity labels to create key->value pairs for train data
trainActivityData <- inner_join(trainActivityKeys, activityLabels, by="ActivityID")
trainActivityData <- subset(trainActivityData, select = c(ActivityName))

## Load train specific subjects
subjectTrain <- read.table("FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
names(subjectTrain) <- c("Subject")

## Load train data
trainData <- read.table("FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

## Assign column names (features) to train data
names(trainData) <- as.vector(allColumns$Features)

## Keep only the Mean and Std data for train
trainData <- trainData[,as.vector(filteredColumns)]

## Merge Subject and Activity columns with train data
trainData <- cbind(trainData, trainActivityData)
trainData <- cbind(trainData, subjectTrain)

## Merge train and test data
mergedData <- rbind(trainData, testData)

## Calculate means for subject and activity
meltedData <- melt(mergedData, id = c("Subject", "ActivityName"))
meanData <- dcast(meltedData, Subject + ActivityName ~ variable, mean)

# Output
write.table(meanData, "meanData.txt", row.names = FALSE, quote = FALSE)