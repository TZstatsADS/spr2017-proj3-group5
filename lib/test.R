######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016
### 
### Fit the classfication model with testing data

### Input: 
###  - the fitted classification model using training data
###  -  processed features from testing images 
### Output: training model specification

### load libraries
library(gbm)
best_ntree<-1900
fit_test <- function(test_gbm=sift_test, test_svm=hog_test, label=label_test){
    label=as.integer(label_test)-1
    gbmtest_pre <- predict(fit_gbm2,newdata=test_gbm,n.tree=best_ntree,type="response")
    test_tmg2 <-system.time(gbmtest_pre <- predict(fit_gbm2,newdata=test_gbm,n.tree=best_ntree))
    gbm_error2<-mean(gbmtest_pre!=label)
    
    # svmtest_pre <- predict(fit_svm2, newdata=test_svm, gamma=best_gamma,cost=best_cost,type="response")
    svmtest_pre <- predict(fit_svm2, newdata=test_svm,cost=10,type="response")
    test_tms2<-system.time(svmtest_pre <- predict(fit_svm2, newdata=test_svm, cost=best_cost,type="response"))
    svm_error2<-mean(svmtest_pre!=label)
    
    return(c(test_tmg=test_tmg2, gbm_error=gbm_error2, test_tms=test_tms2, svm_error=svm_error2))
    
    
  }
    
  
  
 

