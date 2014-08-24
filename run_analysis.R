##create directory for project data if it does not exist
if (!file.exists("proj")) {
    dir.create("proj")
}

##Download the zip file
pfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("proj/projdata.zip")) {
    download.file(pfileURL,"proj/projdata.zip")
}

##and unzip
if(!file.exists("proj/UCI HAR Dataset")) {
    unzip("proj/projdata.zip",exdir="proj")
}

##Get data column & activity labels
dataLabels <-  read.table("proj/UCI HAR Dataset/features.txt",
                          col.names=c("featureNo","featureLabel"))
activityLabels <-  read.table("proj/UCI HAR Dataset/activity_labels.txt",
                          col.names=c("activityNo","activityLabel"))


##Get training data
##Get data, the subject and then the activity foreach measurement
train <- read.table("proj/UCI HAR Dataset/train/x_train.txt",
                    col.names=dataLabels$featureLabel)
trainSubject <- read.table("proj/UCI HAR Dataset/train/subject_train.txt",
                           col.names="Subject")
train$Subject <- trainSubject[,1]
trainActivity <- read.table("proj/UCI HAR Dataset/train/y_train.txt",
                             col.names="Activity")
train$Activity <- trainActivity[,1]
##for merged data set the source in case we need to identify
train$Source <- "train"

##Get test data
##Get data, the subject and then the activity foreach measurement
test <- read.table("proj/UCI HAR Dataset/test/x_test.txt",
                    col.names=dataLabels$featureLabel)
testSubject <- read.table("proj/UCI HAR Dataset/test/subject_test.txt",
                            col.names="Subject")
test$Subject <- testSubject[,1]
testActivity <- read.table("proj/UCI HAR Dataset/test/y_test.txt",
                             col.names="Activity")
test$Activity <- testActivity[,1]
test$Source <- "test"

##Now merge the test and train data together
combined <- rbind(train, test)

##get column indices for the tidy data set
##add Subject, Activity and Source as well
tidyCols <- c(grep("(mean|std)\\(\\)", dataLabels[,2]), 562, 563, 564)

##Now extra these columns only
tidyData <- combined[,tidyCols]

##Change activity to description from code
tidyData$Activity <- tolower(as.character(activityLabels[tidyData$Activity,2]))

##tidy column names
##remove repitition of Body
names(tidyData) <- gsub("BodyBody","Body",names(tidyData))
##Now get rid of . 
names(tidyData) <- gsub("\\.","",names(tidyData))

##Going to user CamelCase
##using format (as regular expression) for all apart from Subject, Activity and Source
## (Time|FFT)(Body|Gravity)(Gyroscope|Accelerometer)(Jerk|Magnitude){0,2}(Mean|STD)(X|Y|Z){0,1}
names(tidyData) <- gsub("^t","Time",names(tidyData))
names(tidyData) <- gsub("^f","FFT",names(tidyData))
names(tidyData) <- gsub("Acc","Accelerometer",names(tidyData))
names(tidyData) <- gsub("Gyro","Gyroscope",names(tidyData))
names(tidyData) <- gsub("Mag","Magnitude",names(tidyData))
names(tidyData) <- gsub("std","STD",names(tidyData))
names(tidyData) <- gsub("mean","Mean",names(tidyData))

##Get 1 row per observation for an activity and subject
meltedtidyData2 <- melt(tidyData, id=c("Activity","Subject"), measure.vars=1:66)
tidyData2 <- ddply(meltedtidyData2,c("Activity","Subject"),summarise,mean=mean(value))

##Now write it out
write.table(tidyData2,"proj/tidyData2.txt",col.names=FALSE)