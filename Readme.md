# Getting and Cleaning Data — Coursera Course Project
yisong  
July 25, 2015  

##The instructions of this project:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

===================================================================================

The script run_analysis.R will download the data file, run the required analysis, create and save the tidy dataset.

The codes in the scripts are:

###Download the file.
The data file used in this project was downloaded on 07-25-2015.

```r
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, "data.zip", method = "curl")
unzip("data.zip")
```

###Read in data.

```r
library(data.table)

df <- read.table("UCI HAR Dataset/train/X_train.txt")
dtXtrain <- data.table(df)
dtYtrain <- fread("UCI HAR Dataset/train/y_train.txt")
dtSubtrain <- fread("UCI HAR Dataset/train/subject_train.txt")

df <- read.table("UCI HAR Dataset/test/X_test.txt")
dtXtest <- data.table(df)
dtYtest <- fread("UCI HAR Dataset/test/y_test.txt")
dtSubtest <- fread("UCI HAR Dataset/test/subject_test.txt")
```

###Merge training and test datasets.

```r
dtSub <- rbind(dtSubtrain, dtSubtest)
setnames(dtSub, "V1", "subject")
dtY <- rbind(dtYtrain, dtYtest)
setnames(dtY, "V1", "activityNum")
dtX <- rbind(dtXtrain,dtXtest)

dt <- cbind(dtSub, dtY, dtX)
setkey(dt,subject,activityNum)
```

###Extract only the measurements on the mean and standard deviation for each measurement.

```r
dtFeature <- fread("UCI HAR Dataset/features.txt")
setnames(dtFeature, names(dtFeature), c("featureNum", "feature"))
dtFeatureMeanSd <- dtFeature[grepl("mean\\(\\)|std\\(\\)", feature)]
dtFeatureMeanSd$Code <- dtFeatureMeanSd[, paste0("V", featureNum)]
dtMeanSd <- dt[, c(key(dt), dtFeatureMeanSd$Code), with = FALSE]
```

###Label the data set with descriptive variable names.

```r
dtActivityLabel <- fread("UCI HAR Dataset/activity_labels.txt")
setnames(dtActivityLabel, names(dtActivityLabel), c("activityNum", "activityName"))

dtMeanSd <- merge(dtMeanSd, dtActivityLabel, by="activityNum", all.x = TRUE)
setkey(dtMeanSd, subject, activityNum, activityName)

library(reshape2)
dtMeanSd <- data.table(melt(dtMeanSd, key(dtMeanSd), variable.name="Code"))
dtMeanSd <- merge(dtMeanSd,dtFeatureMeanSd[, list(featureNum, Code, feature)], by = "Code", all.x = TRUE)

dtMeanSd$feature <- as.factor(dtMeanSd$feature)
dtMeanSd$activityName <- as.factor(dtMeanSd$activityName)

temp1 <- matrix(seq(1, 2), nrow=2)
temp2 <- matrix(c(grepl("^t", dtMeanSd$feature), grepl("^f", dtMeanSd$feature)), ncol=2)
dtMeanSd$fDomain <- factor(temp2 %*% temp1, labels=c("Time", "Freq"))
temp2 <- matrix(c(grepl("Acc", dtMeanSd$feature), grepl("Gyro", dtMeanSd$feature)), ncol=2)
dtMeanSd$fDevice <- factor(temp2 %*% temp1, labels=c("Accelerometer", "Gyroscope"))
temp2 <- matrix(c(grepl("BodyAcc", dtMeanSd$feature), grepl("GravityAcc", dtMeanSd$feature)), ncol=2)
dtMeanSd$fAcceleration <- factor(temp2 %*% temp1, labels=c(NA, "Body", "Gravity"))
temp2 <- matrix(c(grepl("mean()", dtMeanSd$feature), grepl("std()", dtMeanSd$feature)), ncol=2)
dtMeanSd$fVariable <- factor(temp2 %*% temp1, labels=c("Mean", "SD"))

dtMeanSd$fJerk <- factor(grepl("Jerk", dtMeanSd$feature), labels=c(NA, "Jerk"))
dtMeanSd$fMagnitude <- factor(grepl("Mag", dtMeanSd$feature), labels=c(NA, "Magnitude"))

temp1 <- matrix(seq(1, 3), nrow=3)
temp2 <- matrix(c(grepl("-X", dtMeanSd$feature), grepl("-Y", dtMeanSd$feature), grepl("-Z", dtMeanSd$feature)), ncol=3)
dtMeanSd$fAxis <- factor(temp2 %*% temp1, labels=c(NA, "X", "Y", "Z"))
```

###Create a tidy dataset.

```r
setkey(dtMeanSd, subject, activityName, fDomain, fAcceleration, fDevice, fJerk, fMagnitude, fVariable, fAxis)
dtTidy <- dtMeanSd[, list(count = .N, average = mean(value)), by = key(dtMeanSd)]
```

A tidy dataset called dtTidy containing the average of each variable for each activity and each subject should be created in memory now.


```r
write.table(dtTidy, "TidyData.txt", quote = FALSE, sep = "\t", row.names = FALSE)
```
The dtTidy dataset is now saved to a tab separated txt file called TidyData.txt in the same directory as the downloaded original data file data.zip.


```r
library(knitr)
knit("Codebook.Rmd", quiet = TRUE)
```

```
## [1] "Codebook.md"
```

```r
markdown::markdownToHTML("Codebook.md", "Codebook.html")
```
