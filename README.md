
>
> The script perform these steps. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



How to execute the script
-------------------------------

1. Open the R script `run_analysis.r` using a text editor.
2. The Samsung data "Dataset.zip" is suposed to be downloaded in the working directory 
   (if not uncomment the lines : download.file(fileUrl, destfile = "./Dataset.zip") 
3. Run the R script `run_analysis.r`.


Outputs produced
----------------
* Tidy dataset file `dtTidy.txt` (tab-delimited text)
* The file is created in './data' directory 
