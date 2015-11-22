install.packages("gsubfn")

## To read files

train <- read.csv(file="~/0RProg/Project/UCI HAR Dataset/train/X_train.txt", sep="", header = FALSE)
train_activities <- read.csv("~/0RProg/Project/UCI HAR Dataset/train/Y_train.txt", sep="", header = FALSE)
train_subjects<- read.csv("~/0RProg/Project/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)


test <- read.csv("~/0RProg/Project/UCI HAR Dataset/test/X_test.txt", sep="", header = FALSE)
test_activities <- read.csv("~/0RProg/Project/UCI HAR Dataset/test/Y_test.txt", sep="", header = FALSE)
test_subjects <- read.csv("~/0RProg/Project/UCI HAR Dataset/test/subject_test.txt", sep="", header = FALSE)

activityLabels <- read.csv("~/0RProg/Project/UCI HAR Dataset/activity_labels.txt", sep="", header = FALSE)

## To read & rename features 

features <- read.csv("~/0RProg/Project/UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] <- gsub('-mean', 'Mean', features[,2])
features[,2] <- gsub('-std', 'Std', features[,2])
features[,2] <- gsub('[-()]', '', features[,2])

## To merge data

Data <- rbind(train, test)

## To get mean and deviation data

cols_wanted <- grep(".*Mean.*|.*Std.*", features[,2])

## Set features with only columns wanted

features <- features[cols_wanted,]

## To add columns at end for activity and subject

cols_wanted <- c(cols_wanted, 562, 563)

## To remove the unwanted columns 
Data <- Data[,cols_wanted]

## To add the column names Data(data frame)

colnames(Data) <- c(features$V2, "Activity", "Subject")
colnames(Data) <- tolower(colnames(Data))

currentActivity <- 1
for (currentActivityLabel in activityLabels$V2) {
  Data$activity <- gsub(currentActivity, currentActivityLabel, Data$activity)
  currentActivity <- currentActivity + 1
}

Data$activity <- as.factor(Data$activity)
Data$subject <- as.factor(Data$subject)

tidy <- aggregate(Data, by=list(activity = Data$activity, subject=Data$subject), mean)

## To remove subject and activity column

tidy[,90] <- NULL
tidy[,89] <- NULL

## To creat txt file for data table(tidy)
write.table(tidy, "tidy.txt", sep="\t")

View(tidy)





