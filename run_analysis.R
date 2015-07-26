##run_analysis.R

##download file
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, "data.zip", method = "curl")
unzip("data.zip")

##read in data
library(data.table)

df <- read.table("UCI HAR Dataset/train/X_train.txt")
dtXtrain <- data.table(df)
dtYtrain <- fread("UCI HAR Dataset/train/y_train.txt")
dtSubtrain <- fread("UCI HAR Dataset/train/subject_train.txt")

df <- read.table("UCI HAR Dataset/test/X_test.txt")
dtXtest <- data.table(df)
dtYtest <- fread("UCI HAR Dataset/test/y_test.txt")
dtSubtest <- fread("UCI HAR Dataset/test/subject_test.txt")

##merge training and test datasets
dtSub <- rbind(dtSubtrain, dtSubtest)
setnames(dtSub, "V1", "subject")
dtY <- rbind(dtYtrain, dtYtest)
setnames(dtY, "V1", "activityNum")
dtX <- rbind(dtXtrain,dtXtest)

dt <- cbind(dtSub, dtY, dtX)
setkey(dt,subject,activityNum)

##extract mean and sd
dtFeature <- fread("UCI HAR Dataset/features.txt")
setnames(dtFeature, names(dtFeature), c("featureNum", "feature"))
dtFeatureMeanSd <- dtFeature[grepl("mean\\(\\)|std\\(\\)", feature)]
dtFeatureMeanSd$Code <- dtFeatureMeanSd[, paste0("V", featureNum)]
dtMeanSd <- dt[, c(key(dt), dtFeatureMeanSd$Code), with = FALSE]

##lebel dataset with descriptive vaiable names
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

##create tidy data and save to file
setkey(dtMeanSd, subject, activityName, fDomain, fAcceleration, fDevice, fJerk, fMagnitude, fVariable, fAxis)
dtTidy <- dtMeanSd[, list(count = .N, average = mean(value)), by = key(dtMeanSd)]
write.table(dtTidy, "TidyData.txt", quote = FALSE, sep = "\t", row.names = FALSE)
