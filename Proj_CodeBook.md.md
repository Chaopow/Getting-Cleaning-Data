---
title: "CodeBook"
author: "Chao Yu De"
date: "7/7/2020"
output: 
  html_document: 
    keep_md: yes
---


# Important variables  
test_data = data frame with test dataset  
train_data = data frame with train dataset  
full_dat_col = merged data including *test & train* datasets with *subject & activity*. Only columns with "Mean"/"mean"/"std" were included.  
mean_result = mean of each variable in each subject AND each activity  

### Downloading & Unzipping file  

```r
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "rawdat.zip")
unzip("rawdat.zip")
```
### Read & assign TEST data set    

```r
dat_test <- read.table("./UCI HAR Dataset/test/x_test.txt", header = FALSE)
```
### Read & assign TEST activity ID  

```r
test_actID <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
```
### Read & assign TEST subject ID  

```r
test_subjID <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
```
## Create Header for the TEST data set  
### Test dataset is a table with dim = 2947 x 561  

```r
header <- read.delim("./UCI HAR Dataset/features.txt", header = FALSE)
header_vector <- header[,1]
header_vector <- as.character(header_vector)
```
### Assign header to the TEST dataset  

```r
names(dat_test) <- header_vector
```
### Create header for the ACTIVITY & SUBJECT ID  

```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.6.2
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
test_actID <- rename(test_actID, "Act_ID" = "V1")
test_subjID <- rename(test_subjID, "Subj_ID" = "V1")
```
## Merge TEST dataset, activity and subject ID  

```r
test_data <- cbind(test_actID, test_subjID, dat_test)
```
## Add identifier as "TEST"  

```r
test_data$Data_ID <- "test"
```

## Read & assign TRAIN data set  

```r
dat_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
```
## Read & assign TRAIN activity ID  

```r
train_actID <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
```
## Read & assign TRAIN subject ID  

```r
train_subjID <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
```
TRAIN dataset is a table with dim = 7352 x 561  

### Assign header to the TRAIN dataset  

```r
names(dat_train) <- header_vector
```
### Create header for the ACTIVITY & SUBJECT ID  

```r
train_actID <- rename(train_actID, "Act_ID" = "V1")
train_subjID <- rename(train_subjID, "Subj_ID" = "V1")
```
### Merge TRAIN dataset, activity and subject ID  

```r
train_data <- cbind(train_actID, train_subjID, dat_train)
```
### Add identifier as "TRAIN"  

```r
train_data$Data_ID <- "train"
```
### Merge TEST & TRAIN data  

```r
full_dat <- rbind(test_data, train_data)
```
## Interested in only the columns for MEAN and STANDARD DEV (std)  
### Create a variable with only the interesting columns  

```r
interest_col <- grep("[Mm]ean|std", header_vector, value = TRUE)
```
### Subset interesting columns from full_dat  

```r
full_dat_col <- select(full_dat, c(Act_ID:Subj_ID, Data_ID, interest_col))
```

```
## Note: Using an external vector in selections is ambiguous.
## ℹ Use `all_of(interest_col)` instead of `interest_col` to silence this message.
## ℹ See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
## This message is displayed once per session.
```
## Change Act ID to descriptive variable  
i.e. 1 == "Walking", 2 == "Walking_upstairs", 3 == "Walking_downstairs", 4 == "Sitting",
     5 == "Standing", 6 == "Laying"  

```r
full_dat_col$Act_ID[full_dat_col$Act_ID == 1] <- "Walking"
full_dat_col$Act_ID[full_dat_col$Act_ID == 2] <- "Walking_upstairs"
full_dat_col$Act_ID[full_dat_col$Act_ID == 3] <- "Walking_downstairs"
full_dat_col$Act_ID[full_dat_col$Act_ID == 4] <- "Sitting"
full_dat_col$Act_ID[full_dat_col$Act_ID == 5] <- "Standing"
full_dat_col$Act_ID[full_dat_col$Act_ID == 6] <- "Laying"
```

## An independent dataset with average for each Activity and each Subject  
Assume looking for mean of each activity performed by each subject   
i.e. act1 + subj1, act1 + subj2, act1 + subj3, etc...  

### Copy same data set into new handle  

```r
mean_dat <- full_dat_col
```
### Select only mean rows  

```r
mean_col <- grep("[Mm]ean", header_vector, value = TRUE)
mean_dat <- select(mean_dat, c(Act_ID:Subj_ID, all_of(mean_col)))
```
### Group the data by acitivty THEN subject  

```r
mean_dat_grp <- group_by(mean_dat, Act_ID, Subj_ID)
```
### Calculate mean of each variable  

```r
mean_result <- summarise_all(mean_dat_grp, funs(mean(.)))
```

```
## Warning: `funs()` is deprecated as of dplyr 0.8.0.
## Please use a list of either functions or lambdas: 
## 
##   # Simple named list: 
##   list(mean = mean, median = median)
## 
##   # Auto named with `tibble::lst()`: 
##   tibble::lst(mean, median)
## 
##   # Using lambdas
##   list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```
