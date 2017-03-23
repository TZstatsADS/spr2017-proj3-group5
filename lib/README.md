# Project: Labradoodle or Fried Chicken? 

### Code lib Folder

--MATLAB_sift
     how we generated SIFT features

--MATLAB_HOG
     how we generated HoG features

The lib directory contains various files with function definitions (but only function definitions - no code that actually runs).

Content

Main.Rmd: tune with HoG features

Main2.Rmd: tune with SIFT features

knn.RData: knn method, k=c(1,2,3,5,10), enter “tuneKNN” to see the results.

linear12510.RData: linear svm method, ranges = list(cost=c(1,2,5,10)), enter “best_svm” and “error_svm”

linear_svm.jpg: linear svm method, cost=9~243

folder kernel: there are still some doubts about how to tune it efficiently

