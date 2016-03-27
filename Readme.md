
Once the files are downladed and extarcted to a folder set the value of the script varialbe
UCI_HAR_DatasetFiles to the location

steps
. read the files subject, test, train
. merge the files
. renames colums as it would be difficult to work with column names such as Vx in different tables
. use the features.txt to find the column names and then extrace mean and std



## Variables

* UCI_HAR_DatasetFiles = Folders where the extracted files are


* subjectTrain = train data for subject
* xTrain = x train data
* yTrain y train data


* subjectTest  = subject test data
* yTest  = y test data
* xTest  = x test data


* mergedSubject = merged subject ( train + test )
* mergedY = merged Y 
* mergedX = merged X
