# Getting and Cleaning Data Project

## run_analysis.R

The cleanup script (run_analysis.R) does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Running the script


To run the script, set the current directory as the `setwd("<Root of the data directory>")`
source `run_analysis.R`. After running, you will see the following output as the script works:

```
[1] "Reading test and train datasets."
[1] "dataset dir: <Root of the data directory>/test"
[1] "feature indices: 79"
[1] "reading data from: <Root of the data directory>/test/X_test.txt"
[1] "reading activities from file: <Root of the data directory>/test/y_test.txt"
[1] "reading subjects from file: <Root of the data directory>/test/subject_test.txt"
[1] "dataset dir: <Root of the data directory>/train"
[1] "feature indices: 79"
[1] "reading data from: <Root of the data directory>/train/X_train.txt"
[1] "reading activities from file: <Root of the data directory>/train/y_train.txt"
[1] "reading subjects from file: <Root of the data directory>/train/subject_train.txt"
[1] "Combining datasets."
[1] "Melting."
[1] "Writing to: tidy_data.txt"
[1] "Completed."```

## Process

1. For both the test and train datasets, produce an interim dataset:
    1. Extract the mean and standard deviation features (listed in CodeBook.md, section 'Extracted Features'). This is the `values` table.
    2. Get the list of activities.
    3. Put the activity *labels* (not numbers) into the `values` table.
    4. Get the list of subjects.
    5. Put the subject IDs into the `values` table.
2. Join the test and train interim datasets.
3. Put each variable on its own row.
4. Rejoin the entire table, keying on subject/acitivity pairs, applying the mean function to each vector of values in each subject/activity pair. This is the clean dataset.
5. Write the clean dataset to disk.

## Tidy Data

The resulting clean dataset is in the repository which is mentioned in the setwd() call.The name of the file is tidy_data.txt.

