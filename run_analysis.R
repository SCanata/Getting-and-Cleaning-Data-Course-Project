setwd("/Users/stefano/Downloads/UCI HAR Dataset")

# Load necessary libraries
library(dplyr)

# Define the UNM color palette for future plots
UNM.palette <- c("#ba0c2f", "#007a86", "#a7a8aa", "#63666a", "#ffc600", "#ed8b00", "#c05131", "#d6a461", "#a8aa19", "#8a387c", "black")


# Load the datasets
features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# Merge the training and the test sets to create one data set
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Name the columns
colnames(X_data) <- features$V2
colnames(y_data) <- "Activity"
colnames(subject_data) <- "Subject"

# Merge all data into one data frame
complete_data <- cbind(subject_data, y_data, X_data)

# Extracts only the measurements on the mean and standard deviation for each measurement
selected_data <- complete_data %>%
  select(Subject, Activity, contains("mean"), contains("std"))

# Use descriptive activity names to name the activities in the data set
selected_data$Activity <- factor(selected_data$Activity, levels = activity_labels$V1, labels = activity_labels$V2)

# Appropriately labels the data set with descriptive variable names
names(selected_data) <- gsub("^t", "Time", names(selected_data))
names(selected_data) <- gsub("^f", "Frequency", names(selected_data))
names(selected_data) <- gsub("Acc", "Accelerometer", names(selected_data))
names(selected_data) <- gsub("Gyro", "Gyroscope", names(selected_data))
names(selected_data) <- gsub("Mag", "Magnitude", names(selected_data))
names(selected_data) <- gsub("BodyBody", "Body", names(selected_data))

# From the data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- selected_data %>%
  group_by(Subject, Activity) %>%
  summarise_all(mean)

# Save the tidy data set
write.csv(tidy_data_set, "./output/tidy_data_set.csv", row.names = FALSE)

# Note: This script assumes that the dataset is unzipped in a 'data' subdirectory of the current working directory.
