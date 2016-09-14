##########################################################################################################

## Coursera Getting and Cleaning Data Course Project

# run_analysis.R perform the following steps :
# download and unzip the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
# and export the the tidyData set

## Download data
if (!file.exists("data")) {dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
## Unzip the file : library(utils)
unzip(zipfile="./data/Dataset.zip",exdir="./data")
## The archive put the files in a folder named ./data/UCI HAR Dataset

## library(data)

## Read the subject files

subject_train <- fread("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- fread("./data/UCI HAR Dataset/test/subject_test.txt")

## Read the Test and Training labels files

activity_train_label <- fread("./data/UCI HAR Dataset/train/Y_train.txt")
activity_test_label <- fread("./data/UCI HAR Dataset/test/Y_test.txt")

## Read the Test and Training set files

test_set <- fread("./data/UCI HAR Dataset/test/X_test.txt")
train_set <- fread("./data/UCI HAR Dataset/train/X_train.txt")

## ------------------------------------------------------------------------

##        1.Merges the training and the test sets to create one data set

## -------------------------------------------------------------------------
## --------------------------------------------------
##  subjectId         activityId       V1, V2 ...
## --------------------------------------------------
## subject_train   | Y_train        | X_train
## subject_test    | Y_test         | X_test 
## --------------------------------------------------

## Merge Rows
subject <- rbind(subject_train, subject_test)
setnames(subject, "V1", "subjectId")

activity_label <- rbind(activity_train_label, activity_test_label)
setnames(activity_label, "V1", "activityId")

train_test_set <- rbind(train_set, test_set)

## Merge Columns
subject_activity <- cbind(subject, activity_label)
dt <- cbind(subject_activity, train_test_set)

## Set key
setkey(dt, subjectId, activityId)

## ------------------------------------------------------------------------

##        2.Extracts only the measurements on the mean and standard deviation for each measurement.

## -------------------------------------------------------------------------

## Read the Features files

features <- fread("./data/UCI HAR Dataset/features.txt")
setnames(features, "V1", "Num")
setnames(features, "V2", "Name")

# Extract rows containing the pattern "mean() or std()
var_mean_or_std <- features[grepl("mean\\(\\)|std\\(\\)", features$Name)]
var_mean_or_std$code <- features[,paste0("V", var_mean_or_std$Num)]

## Keep only varibles "measurements on the mean and standard deviation"
variables <- c("subjectId","activityId",var_mean_or_std$code)
dt1 <- dt[,variables, with = FALSE]

## ------------------------------------------------------------------------

##        3.Uses descriptive activity names to name the activities in the data set.

## -------------------------------------------------------------------------                         

## Read the activity names file : "activity_labels.txt"
activity_labels <- fread("./data/UCI HAR Dataset/activity_labels.txt") 
setnames(activity_labels, "V1", "activityId")
setnames(activity_labels, "V2", "activityName")

dt2 <- merge(dt1, activity_labels, by = "activityId",  all.x = TRUE)



# Add activityName as a key.

setkey(dt2,  activityId,subjectId,  activityName)


## ------------------------------------------------------------------------

##     4.Appropriately labels the data set with descriptive variable names.

## -------------------------------------------------------------------------

colNames <-  c("activityId","subjectId",var_mean_or_std$Name,"activityName")  

# Cleaning up the variable names
colNames <- gsub("\\()","",colNames)
colNames <- gsub("^(t)","time",colNames)
colNames <- gsub("AccMag","AccMagnitude",colNames)
colNames <- gsub("JerkMag","JerkMagnitude",colNames)
colNames <- gsub("GyroMag","GyroMagnitude",colNames)
colNames <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames)
colNames <- gsub("-mean","Mean",colNames)
colNames <- gsub("-std-","StdDev-",colNames)

## Assign column names to the data

 setnames(dt2, names(dt2), colNames)


 
## ------------------------------------------------------------------------

##  5.From the data set in step 4, creates a second, independent tidy data set  
##     with the average of each variable for each activity and each subject.

## -------------------------------------------------------------------------
 dt3 <- group_by(dt2,activityId,activityName,subjectId)
 dtTidy <- summarise_each(dt3,funs(mean))
 
 # Export the tidyData set 
 
 write.table(dtTidy, './data/dtTidy.txt',row.names=FALSE,sep='\t')
 
 
