## Downloading & Unzipping file 
## ------------------------------------------------------------------------
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "rawdat.zip")
unzip("rawdat.zip")

## Read & assign TEST data set
## ------------------------------------------------------------------------
dat_test <- read.table("./UCI HAR Dataset/test/x_test.txt", header = FALSE)

## Read & assign TEST activity ID
## ------------------------------------------------------------------------
test_actID <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

## Read & assign TEST subject ID
## ------------------------------------------------------------------------
test_subjID <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Create Header for the TEST data set
## Test dataset is a table with dim = 2947 x 561
## ------------------------------------------------------------------------
header <- read.delim("./UCI HAR Dataset/features.txt", header = FALSE)
header_vector <- header[,1]
header_vector <- as.character(header_vector)

## Assign header to the TEST dataset
## ------------------------------------------------------------------------
names(dat_test) <- header_vector

## Create header for the ACTIVITY & SUBJECT ID
## ------------------------------------------------------------------------
test_actID <- rename(test_actID, "Act_ID" = "V1")
test_subjID <- rename(test_subjID, "Subj_ID" = "V1")

## Merge TEST dataset, activity and subject ID
## ------------------------------------------------------------------------
test_data <- cbind(test_actID, test_subjID, dat_test)

## Add identifier as "TEST"
test_data$Data_ID <- "test"


## Read & assign TRAIN data set
## ------------------------------------------------------------------------
dat_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Read & assign TRAIN activity ID
## ------------------------------------------------------------------------
train_actID <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

## Read & assign TRAIN subject ID
## ------------------------------------------------------------------------
train_subjID <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## TRAIN dataset is a table with dim = 7352 x 561
## Assign header to the TRAIN dataset
## ------------------------------------------------------------------------
names(dat_train) <- header_vector

## Create header for the ACTIVITY & SUBJECT ID
## ------------------------------------------------------------------------
train_actID <- rename(train_actID, "Act_ID" = "V1")
train_subjID <- rename(train_subjID, "Subj_ID" = "V1")

## Merge TRAIN dataset, activity and subject ID
## ------------------------------------------------------------------------
train_data <- cbind(train_actID, train_subjID, dat_train)

## Add identifier as "TRAIN"
train_data$Data_ID <- "train"

## Merge TEST & TRAIN data
## ------------------------------------------------------------------------
full_dat <- rbind(test_data, train_data)

## Interested in only the columns for MEAN and STANDARD DEV (std)
## Create a variable with only the interesting columns
## ------------------------------------------------------------------------
interest_col <- grep("[Mm]ean|std", header_vector, value = TRUE)

## Subset interesting columns from full_dat
## ------------------------------------------------------------------------
full_dat_col <- select(full_dat, c(Act_ID:Subj_ID, Data_ID, interest_col))

## Change Act ID to descriptive variable
## i.e. 1 == "Walking", 2 == "Walking_upstairs", 3 == "Walking_downstairs", 4 == "Sitting",
##      5 == "Standing", 6 == "Laying"
full_dat_col$Act_ID[full_dat_col$Act_ID == 1] <- "Walking"
full_dat_col$Act_ID[full_dat_col$Act_ID == 2] <- "Walking_upstairs"
full_dat_col$Act_ID[full_dat_col$Act_ID == 3] <- "Walking_downstairs"
full_dat_col$Act_ID[full_dat_col$Act_ID == 4] <- "Sitting"
full_dat_col$Act_ID[full_dat_col$Act_ID == 5] <- "Standing"
full_dat_col$Act_ID[full_dat_col$Act_ID == 6] <- "Laying"


## An independent dataset with average for each Activity and each Subject
## Assume looking for mean of each activity performed by each subject 
## i.e. act1 + subj1, act1 + subj2, act1 + subj3, etc...

## Copy same data set into new handle
mean_dat <- full_dat_col

## Select only mean rows
mean_col <- grep("[Mm]ean", header_vector, value = TRUE)
mean_dat <- select(mean_dat, c(Act_ID:Subj_ID, all_of(mean_col)))

## Group the data by acitivty THEN subject
mean_dat_grp <- group_by(mean_dat, Act_ID, Subj_ID)

## Calculate mean of each variable
mean_result <- summarise_all(mean_dat_grp, funs(mean(.)))

## Save data
write.csv(full_dat_col, "full_data.csv")
write.csv(mean_result, "mean_data.csv")
write.table(mean_result, "mean_data.txt", row.names = FALSE)