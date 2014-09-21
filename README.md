==================================================================
Getting and Cleaning data Project
==================================================================
Download the files from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
After download

Set you working directory where the data file is extracted.
Keep the run_analysis.R program in the same directory where you have extracted the file.

Below are libaries that are needed for this R program
library("tcltk")
library("sqldf")
library("reshape")

run_analysis gets the data from 8 file to generate the data
X_test.txt        				:Provided the test data
subject_test.txt		:Subject for the test set of data
y_test.txt					:provided the acitivity the test subjects performed 
X_train.txt					:Provided the training data
subject_train.txt		:Subject for the training set of data 
y_train.txt					:provided the acitivity the training subjects performed 
features.txt				:Column labels of the data
activity_labels.txt : Actitity description

first generate the data set by adding subject and activity to the test and training data set
once that is done row merge the test and training data set into one

For the full data change the activity code to activity description using the data from activity desription file

then do the average for all the measurement for the subject by activity.

