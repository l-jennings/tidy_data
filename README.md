# tidy_data
Course Project repo for Getting and Cleaning Data Course <br>
Libby Jennings

# README 

The UCI data files contain data describing the movement of 30 subjects performing different activities (laying, sitting, standing, walking, walking upstairs and walking downstairs), as measured by wearable tech devices. Some of the subjects are designated as training data, some as testing data.
## Tidying the data
This script reads in the raw UCI data and generates a single dataframe from the files provided. The variable names given in features.txt are lined up with the values in x_test and x_train. Then, only variables giving the mean and standard deviation values for each variable are kept to create a 'trimmed_data' dataframe. 
At this point, the activity is given as a number. These numbers are substituted for their corresponding description (laying, sitting, standing, walking, walkupstairs, walkdownstairs). 
<br>
To give variables descriptive titles, a separate csv file was created with old names (OldColName) and corresponding new descriptive names (NewColName). This file is named 'mean_std_names.csv'. This file was read and NewColName was used as the column names in the final dataframe (final_data). In this naming system
* Mean = mean 
* Std = standard deviation
* Gyro = measure by the gyroscope on the device
* Acc = measured by the accelerometer on the device
* Body = Accelerometer body signal
* Gravity = Accelerometer gravity signal
* Jerk = jerk - derived from body linear and angular velocity values
* Mag = magnitude of signals
* Time = time
* Freq = frequency - values have undergone Fast Fourier Transform
* X/Y/Z = dimension of measurement

## Generating a new dataframe of mean values
In the next step, the script generates a new dataframe that gives the mean values of each variable for each subject performing the different activities. The resulting dataframe (df) has the same column names as the previous, with one row per unique subject and activity combination. This is written into a .txt file. 
