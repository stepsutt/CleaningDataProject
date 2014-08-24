Original Source Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Description of Data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Transformation Steps
====================

Download Data
-------------
1. if a 'proj' directory does not exist below the working directory then it is created
2. if zip file containing source data dows not exist in 'proj' then ut is downloaded
3. if the root folder of the zip file (UCI HAR Dataset) does not exist in 'proj' then the file is unzipped

Read Data Labels
----------------
The measurement data labels are read into dataLabels
The activity descriptions are read into activityLabels

Create Training and Test Data
------------------------------
The measurement data is read from the x_train.txt file and the columns are labelled with those in dataLabels. The data is stored in train

The associated subject for each row in x_train.txt is read from subject_train.txt into a temporary variable (trainSubject).  The data is then stored in train$Subject.

The associated activity code for each row in x_train.txt is read from y_train.txt into a temporary variable (trainActivity).  The data is then stored in train$Activity.

A source column is created and set to train in case we wasnt to identify the source in the combined dataset.

The same steps are performed for the test data (variables are the same with test replacing train in the name).

Combine
-------
The test and train data are combined into a variable called combined

Measures
--------
Only measures that have mean() or std() in their description in activityLabels are included as we are only interested in means and standard deviations.

This subset of the data is stored in tidyData.

Rename Column Headings
----------------------
The column names are 
  converted to lowercase
  have duplicated Body references removed
  . is removed
  Converted to CamelCase for readability, final column names match the regular expresssion
	(Time|FFT)(Body|Gravity)(Gyroscope|Accelerometer)(Jerk|Magnitude){0,2}(Mean|STD)(X|Y|Z){0,1}

Final Tiday Data
----------------
For the final tidy dataset the tidyData is melted on Activity and subject and then the mean of all the measures calculated to give 6 (activities) x 30 (subjects) = 180 rows.

The format is as follows with each column seperated by ' ':

rownumber		enclosed in quotes
acivity			enclosed in quotes
subject			1:30
mean			mean of all 66 measurements with mean() or std()