## Course Project for Getting and Cleaning Data through Coursera
## Course by Jeff Leek, PhD, Roger D. Peng, PhD, and Brian Caffo, PhD

## License: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
## Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a 
## Multiclass Hardware-Friendly Support Vector Machine. International Workshop 
## of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

### Queue Working Directory and Libraries ###

##  assumes setwd("UCI HAR Dataset")
library(data.table)
library(dplyr)
library(tidyr)

########################################################################
### 1. Merges the training and the test sets to create one data set. ###
########################################################################

### Load Initial Variables ###
features <- read.table("features.txt")

## 'train/X_train.txt': Training set. ##
X_train <- data.frame()
X_train <- read.table('train/X_train.txt', header = FALSE, 
                      stringsAsFactor = FALSE)

## 'test/X_test.txt': Test set. ##
X_test <- data.frame()
X_test <- read.table('test/X_test.txt', header = FALSE, 
                     stringsAsFactor = FALSE)

## actual binding
df <- rbind(X_train, X_test)


#######################################################
### 2. Extracts only the measurements on the mean   ###
###    and standard deviation for each measurement. ###
#######################################################

## Labels : features.txt ##
features <- read.table("features.txt")
names(df) <- as.vector(features[,2])
feat2 <- as.vector(features[,2])
STDvar <- grepl("std()", feat2)              
MEANvar <- grepl("mean()", feat2)
GOODvar <- as.logical(MEANvar + STDvar)
MEAN_STD_DF <- df[,GOODvar]

#######################################################
### 3. Uses descriptive activity names to name the  ###
###    activities in the data set                   ###
#######################################################

## Combine Y data sets ##
y_train <- read.table('train/y_train.txt', header = FALSE, 
                      stringsAsFactor = FALSE)
y_test <- read.table('test/y_test.txt', header = FALSE, 
                     stringsAsFactor = FALSE)
y <- rbind(y_train, y_test)
names(y) = "Num"

## Join Activity Labels ##
activity_labels <- read.table('activity_labels.txt')
names(activity_labels) = c("Num", "Activity")
act <- left_join(y, activity_labels, by = "Num")

MEAN_STD_DF$Activity <- act$Activity

#############################################################################
### 4. Appropriately labels the data set with descriptive variable names. ###
#############################################################################

##### NAMES IN PLACE FROM STEP 1 AND STEP 2 ######

## Load Initial Variables (Step 1)              ##
## features <- read.table("features.txt")       ##

## Labels : features.txt (Step 2)               ##
## features <- read.table("features.txt")       ##
## names(df) <- as.vector(features[,2])         ##
## feat2 <- as.vector(features[,2])             ##

############ ADD SUBJ DATA  ######################

subject_train <- read.table('train/subject_train.txt', header = FALSE, 
                            stringsAsFactor = FALSE)
subject_test <- read.table('test/subject_test.txt', header = FALSE, 
                           stringsAsFactor = FALSE)
subject <- rbind(subject_train, subject_test)
MEAN_STD_DF$Subject <- subject
names(MEAN_STD_DF[,81]) <- "Subject"



########################################################################
### 5. creates a second, independent tidy data set with the average  ###
###    of each variable for each activity and each subject.          ###
########################################################################

df2 <- MEAN_STD_DF

df2 %>%
group_by(Subject) %>%
group_by(Activity)
## summarize_each(funs(mean)) %>%

write.table(df2, "tidydata.txt", row.name=FALSE)

