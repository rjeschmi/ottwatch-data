filenames<-list.files(pattern="*.csv")
filelist<-lapply(filenames, function(i){ read.csv( i, header=FALSE) }
