#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


fit_train <- function(best_ntree, best_gamma, best_cost){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  

  ### Train with gradient boosting model
  
  gbm_train_time<-system.time(gbm.fit(x=sift_train, y=label_train,
                     n.trees=best_ntree,
                     shrinkage=.001,
                     n.minobsinnode=20,
                     distribution="bernoulli",
                     interaction.depth=depth, 
                     bag.fraction = 0.5,
                     verbose=FALSE))
  fit_gbm2 <- gbm.fit(x=sift_train, y=label_train,
                       n.trees=best_ntree,
                       shrinkage=.001,
                       n.minobsinnode=20,
                       distribution="bernoulli",
                       interaction.depth=depth, 
                       bag.fraction = 0.5,
                       verbose=FALSE)
  best_iter <- gbm.perf(fit_gbm233, method="OOB", plot.it = FALSE)
  
  
  ##train svm model(advanced)
  fit_svm2 <- svm(label_train~., data=hog_train_new, kernel="radial",scale=TRUE,cost=best_cost,gamma=best_gamma)
  svm_train_time<-system.time(svm(label_train~., data=hog_train_new, kernel="radial",scale=TRUE,cost=best_cost,gamma=best_gamma))
  
  return(list(fit_gbm2, fit_svm2, svm_train_time, gbm_train_time))
  
  
}
