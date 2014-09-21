## Read data from test files into Data Frames
        test_set<-read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
        test_sub<-read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
        test_act<-read.table("./UCI HAR Dataset/test/y_test.txt", sep="")

## Read data from training files into Data Frames
        train_set<-read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
        train_sub<-read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
        train_act<-read.table("./UCI HAR Dataset/train/y_train.txt", sep="")

## Read from common files
        names<-read.table("./UCI HAR Dataset/features.txt", sep="")
        act_names<-read.table("./UCI HAR Dataset/activity_labels.txt", sep="")
## Assign column name to Activity files
        colnames(act_names)<-c("Act_Code", "Act_Desc")
##Create column name data set
##used reshape library to tranpose the rows to column
        namesrw<-t(names[2])

##Create column names to test files
        colnames(test_act)<-c("Activity")
        colnames(test_sub)<-c("Subject")
        colnames(test_set)<-namesrw

## Merge Activity and Subject to test data set
        test_comp<-cbind(test_set,test_sub,test_act)

##Create column names to test files
        colnames(train_act)<-c("Activity")
        colnames(train_sub)<-c("Subject")
        colnames(train_set)<-namesrw

## Merge Activity and Subject to test data set
        train_comp<-cbind(train_set,train_sub,train_act)


##Merge test and training data set
        full_data<-rbind(test_comp,train_comp)
## Assign descriptions for Activity
        full_data_act_desc<-sqldf("select full_data.*, act_names.act_desc from full_data , act_names where act_names.act_code=full_data.Activity")

##Uncomment next line to write the whole data file into a file
        ##write.table(full_data_act_desc,file="./full_data.txt", sep = " ", col.names = TRUE, row.names = FALSE)

##Get all the columns with Mean and get the sub set of data with column names as mean
        meancol<-grep("mean" ,namesr)
        meantest_set<-full_data_act_desc[,meancol]

##Get all the columns with STD and get the sub set of data with column names as STD
        stdcol<-grep("std",namesr)
        stdtest_set<-full_data_act_desc[,stdcol]
        
##Create subset with mean , std , subject and Activity description columns
##Second line from here writes the subset to the file - uncomment to write to file
        full_dat_mean_std_ss<-cbind(meantest_set,stdtest_set, full_data_act_desc["Subject"], full_data_act_desc["Act_Desc"])
        ##write.table(full_dat_mean_std_ss,file="./mean_std_data.txt", sep = " ", col.names = TRUE, row.names = FALSE)

##Prepare SQL statement to average of values group by subject & Activity
        mean_std_ss_col_names<-colnames(full_dat_mean_std_ss[1:79])
        mean_std_ss_col_spec<-paste("Avg( ",mean_std_ss_col_names," ) ")
        prep_sql<-paste(mean_std_ss_col_spec,collapse=",")
##Execute SQL statement to get the average of all the column and group by Subject and Activity Desc
        mean_std_ss_avg<-sqldf(paste("Select Subject , Act_Desc ,", prep_sql," From full_dat_mean_std_ss Group by Subject , Act_Desc"))
##Write the data set to the file
        write.table(mean_std_ss_avg,file="./mean_std_avg_data.txt", sep = " ", col.names = TRUE, row.names = FALSE)

