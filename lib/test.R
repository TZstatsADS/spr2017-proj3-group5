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

fit_test <- function(test_gbm=sift_test, test_svm=hog_test, label=label_test){

    gbmtest_pre <- predict(fit_gbm2,test_gbm,n.tree=best_ntree,type="response")
    test_tmg <-system.time(gbmtest_pre <- predict(fit_gbm2,test_gbm,n.tree=best_ntree,type="response"))
    gbm_error<-mean(gbmtest_pre!=label)
    
    svmtest_pre <- predict(fit_svm2, newdata=test_svm, gamma=best_gamma,cost=best_cost,type="response")
    test_tms<-system.time(svmtest_pre <- predict(fit_svm2, newdata=test_svm, gamma=best_gamma,cost=best_cost,type="response"))
    svm_error<-mean(svmtest_pre!=label)
    
    return(c(test_tmg,gbm_error,test_tms,svm_error))
    
    
  }
    
  
  
 

