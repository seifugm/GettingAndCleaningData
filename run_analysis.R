##load libraries
library(dplyr)
library(data.table)
library(tidyr)

##were are the files
## Please specify where the "UCI HAR Dataset" folder is
UCI_HAR_DatasetFiles = "TREPLACE_THIS_WITH_FOLDER/UCI HAR Dataset"
setwd(UCI_HAR_DatasetFiles)

#change folder to tran and read the training data
setwd("./train")
subjectTrain <- tbl_df(read.table("subject_train.txt"))
xTrain <- tbl_df(read.table("X_train.txt" ))
yTrain <- tbl_df(read.table("Y_train.txt"))

#change folder to  test and read the test data
setwd(UCI_HAR_DatasetFiles)
setwd("./test")
subjectTest  <- tbl_df(read.table("subject_test.txt" ))
yTest  <- tbl_df(read.table("Y_test.txt" ))
xTest  <- tbl_df(read.table("X_test.txt" ))

#back to the top folder
setwd(UCI_HAR_DatasetFiles)

########## merge train and test
mergedSubject <- rbind(subjectTrain, subjectTest)
mergedY<- rbind(yTrain, yTest)
mergedX <- rbind(xTrain, xTest)

setnames(mergedSubject, "V1", "subject")
setnames(mergedY, "V1", "activityCode")
#activity
activityLabels<- tbl_df(read.table(file.path(UCI_HAR_DatasetFiles, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityCode","activityName"))
#feature
featuresList <- tbl_df(read.table(file.path(UCI_HAR_DatasetFiles, "features.txt")))
setnames(featuresList, names(featuresList), c("featureCode", "feature"))
colnames(mergedX) <- featuresList$feature


## 1.Merges the training and the test sets to create one data set.
temp1<- cbind(mergedSubject, mergedY)
mergedX <- cbind(temp1, mergedX)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
featursMeanStd <- grep("mean\\(\\)|std\\(\\)",featuresList$feature,value=TRUE) 
featursMeanStd <- union(c("subject","activityCode"), featursMeanStd)
mergedX<- subset(mergedX,select=featursMeanStd) 

# 3. Uses descriptive activity names to name the activities in the data set
mergedX <- merge(activityLabels, mergedX , by="activityCode", all.x=TRUE)
mergedX$activityName <- as.character(mergedX$activityName)
mergedX$activityName <- as.character(mergedX$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = mergedX, mean) 
mergedX<- tbl_df(arrange(dataAggr,subject,activityName))

## 4.Appropriately labels the data set with descriptive variable names.
names(mergedX)<-gsub("^f", "frequency", names(mergedX))
names(mergedX)<-gsub("^t", "time", names(mergedX))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
write.table(mergedX, "TidyData.txt", row.name=FALSE)