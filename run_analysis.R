#loading initial data and tables
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
extract_features <- grepl("mean|std", features)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sbjTest <- read.table("./UCI HAR Dataset/test/sbjTest.txt")
#loading secondary data
names(X_test) = features
X_test = X_test[,extract_features]
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(sbjTest) = "subject"
test_data <- cbind(as.data.table(sbjTest), y_test, X_test)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(X_train) = features
sbjTrain <- read.table("./UCI HAR Dataset/train/sbjTrain.txt")
X_train = X_train[,extract_features]
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(sbjTrain) = "subject"
#Organizing data 
train_data <- cbind(as.data.table(sbjTrain), y_train, X_train)
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
structuredData = melt(data, id = id_labels, measure.vars = data_labels)
#showing tidy data
tidy_data   = dcast(structuredData, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")
