============================================================
Data Cleaning Project
Getting & Cleaning Data
============================================================
Chao Yu De
R version 3.6.1
============================================================


The dataset obtained in this project could be obtained from the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

There were a total of 561 variables representing a smaller number of features. The full list can be found in the zip file “./features.txt” and “./features_info.txt”.

In general, the dataset consists of two different types of data — 1) “Test” data 2) “Train” data. 
There were a total of 561 variables measured in this dataset and they were merged into a single dataset with subject ID and activity IDs. 

This was accomplished with the following pipeline:
1. Read dataset from “test” and “train” data.
2. Assign headers to all variables using the file “./features.txt”. There were a total 561 variables. 
3. The subject ID was retrieved and assigned to each observation from “./subject_test.txt” OR “./subject_train.txt”
4. The activity ID was retrieved and assigned to each observation from “./y_test.txt” OR “./y_train.txt”
5. rbind() was used to merge the two different datasets together. 

Only the variables that included the mean and standard deviation (std) were of interest and were then selected from the main dataset. This included only a total 86 “interesting” variables. 

============================================================

A second dataset was created to calculate ONLY the mean of each feature for each activity and subject. This was accomplished by the following pipeline:
1. Select only the variables with “mean” from the merged dataset above.
2. Group the dataframe by activity THEN subject. 
3. Summarise the data and apply mean to each column. 

For more information about the dataset, contact: activityrecognition@smartlab.ws

Chao Yu De. July 2020
