#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


fit_train <- function(best_ntree){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  
  
  ### Train with gradient boosting model
  label_y<- as.integer(label_train)-1
  gbm_train_time2<-system.time(gbm.fit(x=sift_train, y=label_y,
                                      n.trees=best_ntree,
                                      shrinkage=.01,
                                      n.minobsinnode=10,
                                      distribution="bernoulli",
                                      interaction.depth=depth,
                                      bag.fraction = 0.5,
                                      verbose=FALSE))
  fit_gbm22 <- gbm.fit(x=sift_train, y=label_y,
                      n.trees=1900,
                      shrinkage=.01,
                      n.minobsinnode=10,
                      distribution="bernoulli",
                      interaction.depth=depth, 
                      bag.fraction = 0.5,
                      verbose=FALSE)
  
  
  ##train svm model(advanced)
  hog_train_new<-cbind(hog_train,label_train)
  fit_svm22 <- svm(label_train~., data=hog_train_new, kernel="radial",scale=TRUE,cost=10)
  svm_train_time2<-system.time(svm(label_train~., data=hog_train_new, kernel="radial",scale=TRUE,cost=10))
  
  
  return(list(fit_gbm2=fit_gbm22, fit_svm2=fit_svm22, svm_train_time=svm_train_time2, gbm_train_time=gbm_train_time2))
  
  
}
