##Set working directory to location of UCI Activity data
setwd("C:/Users/Andrew/Desktop/Data/ProjectData")

##Read in each of the text files using read.table(). Store them with intuitive variable names.
X_train <- read.table("X_train.txt")
Y_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")
Y_test <- read.table("Y_test.txt")
subject_test <- read.table("subject_test.txt")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

##Combine training and test data sets using rbind(). Store results with inuitive variable names.
##Add column names to Subject and Activity datasets
X <- rbind(X_train,X_test)
Subject <- rbind(subject_train, subject_test)
colnames(Subject) <- c("subject")
Y <- rbind(Y_train, Y_test)
colnames(Y) <- c("activity")                

##Add column names to X observation data using "features.txt"

colnames <- as.character(features[,2])
names(X) <- colnames

##Create subset of data by extracting out only measurements on mean or standard deviation 
##for each instrument
new <- X[, as.vector(grep("mean|std", colnames(X),value=FALSE))]

##Combine all three elements of the data into a variable "data" using cbind()
data <- cbind(Subject, Y, new)


##Creating ideal column variable names is inherently subjective. Here, I've removed
##some non-alphanumeric characters and written out full words where possible. 
names(data) <- gsub("\\(|\\)", "", names(data))
names(data) <- gsub("f", "Frequency", names(data))
names(data) <- gsub("Acc", "Acceleration", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("-", "", names(data))
names(data) <- gsub("std", "_Standard_Dev", names(data))
names(data) <- gsub("mean", "_Mean", names(data))
names(data) <- gsub("tBody", "TimeBody", names(data))
names(data) <- gsub("tGravity", "TimeGravity", names(data))

data$activity[data$activity == 1] <- "WALKING"
data$activity[data$activity == 2] <- "WALKING_UPSTAIRS"
data$activity[data$activity == 3] <- "WALKING_DOWNSTAIRS"
data$activity[data$activity == 4] <- "SITTING"
data$activity[data$activity == 5] <- "STANDING"
data$activity[data$activity == 6] <- "LAYING"

##Create a new data set with averages of each variable for subject and activity
library(dplyr)
new_data <- data %>% group_by (subject, activity, add = TRUE) %>% summarise_each(funs(mean))
write.table(new_data, "Final_Tidy_Data.txt", row.name=FALSE)





