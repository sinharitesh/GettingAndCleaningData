# This is a project for the course Getting and Cleaning data. This has five following requirememnts 

#REQUIREMENT 1: Merges the training and the test sets to create one data set.
#REQUIREMENT 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#REQUIREMENT 3: Uses descriptive activity names to name the activities in the data set
#REQUIREMENT 4: Appropriately labels the data set with descriptive variable names. 
#REQUIREMENT 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

extracted.data.file <- "tidy_data.txt"

activities <- c(1, 2, 3, 4, 5, 6)
activity.names <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

# returns features filename given a dataset name.
features.filename <- function(name) {
  paste("X_", name, ".txt", sep = "")
}

# returns activities filename given a dataset name.
activities.filename <- function(name) {
  paste("y_", name, ".txt", sep = "")
}

# returns subjects filename given a dataset name.
subjects.filename <- function(name) {
  paste("subject_", name, ".txt", sep = "")
}

# used for getting the dataset test and train separately as they are in different directories

get.dataset <- function(dir, name, feature_indices, feature_names) {
  current.dir <- file.path(dir, name)
  features.filename <- file.path(current.dir, features.filename(name))
  activities.filename <- file.path(current.dir, activities.filename(name))
  subjects.filename <- file.path(current.dir, subjects.filename(name))
  print(paste("dataset dir:", current.dir))
  
  # Read the features table.
  print(paste("feature indices:", length(feature_indices)))
  print(paste("reading data from:" , features.filename))
  all.features <- read.table(features.filename)
  
  extracted <- all.features[,feature_indices]
  # REQUIREMENT 4 - Using appropriate labels for features
  colnames(extracted) <- feature_names
  
  return.data <- extracted
    # Read the activities list.
  print(paste("reading activities from file:", activities.filename))
  df.activities <- read.table(activities.filename)
  #head(df.activities)
  names(df.activities) <- c("activity")
  # REQUIREMENT 3 - Using descriptive activity names.
  df.activities$activity <- factor(df.activities$activity, levels = activities, labels = activity.names)
  return.data <- cbind(return.data, activity = df.activities$activity)
  
  
  # Read the subjects list.
  print(paste("reading subjects from file:" , subjects.filename))
  df.subjects <- read.table(subjects.filename)
  names(df.subjects) <- c("subject")
  return.data <- cbind(return.data, subject = df.subjects$subject)
  return.data
}


summarizedata <- function(){
  print("Reading test and train datasets.")
  dir <- getwd()
  r <- read.table("features.txt")
  # REQUIREMENT 2: Extracting only the required features.
  feature_indices <- c(r[grepl("std", r$V2), c(1)], r[grepl("mean", r$V2), c(1)])
  a <- r[grepl("mean", r$V2),c(2)]
  b <- r[grepl("std", r$V2),c(2)]
  feature_names <- c(as.character(a),as.character(b))
  
  #df <- data.frame(feature_indices, feature_names)
  #for (counter in 1:nrow(df)) {print(paste('feature:',feature_names[counter], ' column index:', feature_indices[counter]))}
    
  test <- get.dataset(dir, "test", feature_indices, feature_names)
  train <- get.dataset(dir, "train", feature_indices, feature_names)
  colnames(test)
  colnames(train)
  print("Combining datasets.")
  all.data <- rbind(test, train) # REQUIREMENT 1, joining test and train datasets completed.

print("Melting.")
all.data <- melt(all.data, id = c("subject", "activity"))
# REQUIREMENT 5: 
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject. 
# For this reshape package's melt and dcast function is used.
all.data <- dcast(all.data, subject + activity ~ variable, mean)
print(paste("Writing to:", extracted.data.file))
write.table(all.data, extracted.data.file, row.names = FALSE, quote = FALSE)
print("Completed.")
}

#setwd("C:/Users/Ritesh/Downloads/r-scripts/Coursera-Samsung-Getting-Cleaning-Data/UCI HAR Dataset")
# Set this directory to the root of data directory. This directory should contain test and train directories and 
# other files such as feautres.txt, actvity_labels.txt, etc.
summarizedata()
