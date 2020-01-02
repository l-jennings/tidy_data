### STEP ONE - merging the data into one df ###

library(tibble)

## read test files 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")

## read labels file and convert to vector
labels <- read.table("./UCI HAR Dataset/features.txt", header = F)
labels <- as.vector(labels[,2])

## bind subject number, activity and dataframe then rename columns with variables
all_test <- cbind(subject_test, test_y, test_data)
colnames(all_test) <- c("subject", "activity", labels)

## add column indicating this is testing data
all_test <- add_column(all_test, group = "test", .before = 1)

## do the same for training files
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
all_train <- cbind(subject_train, train_y, train_data)
colnames(all_train) <- c("subject", "activity", labels)
all_train <- add_column(all_train, group = "training", .before = 1)

## bind together testing and training data
all_data <- rbind(all_train, all_test)

### STEP TWO extract only the mean and std variables ###

## determine which columns contain mean and sd values
means <- grep("mean", colnames(all_data))
mean_freqs <- grep("meanFreq", colnames(all_data)) # get rid of 'meanFreq' variables, just keep means
not_freqs <- !means %in% mean_freqs
means <- means[not_freqs]


stand_devs <- grep("std", colnames(all_data))
selected_columns <- sort(append(means, c(1,2,3, stand_devs), after = length(means)))

## create df with only mean and std values
trimmed_data <- all_data[ , selected_columns]

### STEP THREE give descriptive activity names ###
activity_nums <- trimmed_data$activity

activity_nums <- sub("1", "walking", activity_nums)
activity_nums <- sub("2", "walkupstairs", activity_nums)
activity_nums <- sub("3", "walkdownstairs", activity_nums)
activity_nums <- sub("4", "sitting", activity_nums)
activity_nums <- sub("5", "standing", activity_nums)
activity_words <- sub("6", "laying", activity_nums)

trimmed_data$activity <- activity_words

### STEP FOUR give variables descriptive names ###
# read in csv file with old and new names, extract new names and apply to dataframe
new_col_names <- read.csv("./mean_std_names.csv", header= T)
new_col_names <- new_col_names$NewColName

colnames(trimmed_data) <- new_col_names
final_data <- trimmed_data


### STEP FIVE create a second dataframe with average of each variable for each activity ###

split_by_subject <- split(final_data, final_data$subject) # split data into each subject
activity_list <- as.list(c("laying", "sitting", "standing", "walkdownstairs", "walking", "walkupstairs"))
df <- NULL 

for(i in 1:30){
        subject_df <- NULL #set up empty df for each subject 
        activity_list <- as.list(c("laying", "sitting", "standing", "walkdownstairs", "walking", "walkupstairs"))
        
        for(j in activity_list){ # loop to build a dataframe with means for each activity for one subject
                subject_num <- split_by_subject[[i]] #select subject
                split_activity <- split(subject_num, subject_num$activity) #split by activity
                activity <- split_activity[[j]]
                activity_means <-  colMeans(activity[,4:69], na.rm = F, dims = 1) #calculate means for that activity
                activity_means <- t(activity_means)
                
                row <- cbind(group = activity[1,1], subject = activity[1,2], activity = activity[1,3], activity_means )
                #this gives a single-row matrix with the correct group, subject and activity as well as mean data
                
                subject_df <- rbind(subject_df, row) #bind the row into the df
        }
        df <- rbind(df, subject_df) #bind each subject df into one large one
}

## write the final df into a txt file

write.table(df, file = "run_analysis.txt", row.names = F)
