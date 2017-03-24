########################
### Cross Validation ###
########################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016

img_label <- read.csv("labels.csv")
img_hog_feature_raw <- read.csv("HOG8_8.csv",header = FALSE)
img_hog_feature_raw <- img_hog_feature_raw[,1:200]
img_hog_feature <- data.frame(img_hog_feature_raw)
img_hog_feature <- cbind(img_hog_feature,img_label)
names(img_hog_feature)[201]<-"label"
set.seed(1)
test_ind <- sample(1:5,2000,replace = T)
img_test <- img_hog_feature[which(test_ind==5),]
img_train <-img_hog_feature[which(test_ind!=5),]
img_train$label<-factor(img_train$label)
img_test$label<-factor(img_test$label)

cv.function <- function(modelname, data.train,k){
  if(modelname==gbm){
       library(gbm)
       tuneSVMkernel<-tune(modelname,label~.,data = img_train,kernel="radial",ranges = list(cost=c(1),gamma=c(0.0015,0.002,0.0025)),tunecontrol = tc,scale=T)
       best_kernel<-tuneSVMkernel$best.model
       kernel_predict<-predict(best_kernel,img_test[,-201])
       error_kernel<-mean(kernel_predict!=img_test[,201])
    }
  else if(modelname=svm){
    tc<-tune.control(cross=k)
    tuneSVMkernel<-tune(modelname,label~.,data = img_train,kernel="radial",ranges = list(cost=c(5,10,15,20),gamma=c(0.001,0.002,0.005)),tunecontrol = tc,scale=T)
    best_kernel<-tuneSVMkernel$best.model
    return(best_kernel)
     }
       
   }
cv.function <- function(X.train, y.train, d, K){
  
  n <- length(y.train)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- X.train[s != i,]
    train.label <- y.train[s != i]
    test.data <- X.train[s == i,]
    test.label <- y.train[s == i]
    
    par <- list(depth=d)
    fit <- train(train.data, train.label, par)
    pred <- test(fit, test.data)  
    cv.error[i] <- mean(pred != test.label)  
    
  }			
  return(c(mean(cv.error),sd(cv.error)))
  
}
