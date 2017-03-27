########################
### Cross Validation ###
########################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016

#for baseline gbm
# depth <- 1   #set interaction.depth
# n_trees <- seq(1000, 2000, 100)
# shrinkage <- 0.001
# model_label_gbm = paste("GBM with n_trees =", n_trees)

#for advanced svm_radial
# cost <- seq(5,20,5)
# gamma <- seq(0.001,0.009,0.002)
# model_labels_svm = paste("svm with cost=",cost," gamma=",gamma)

cv.function <- function(K,n_trees, cost, gamma){
  ##gbm cv  
    gbm_grid<-expand.grid(.n.trees=n_trees,.interaction.depth=1,.shrinkage=.001,.n.minobsinnode=20)
    bootcontrol<-trainControl(number = K)
    gbm_fit2<-train(sift_train[,1:5000],label_train,method = "gbm",trControl = bootcontrol,verbose=FALSE,bag.fraction=0.5,tuneGrid = gbm_grid)
    best_ntree <- unlist(unname(gbm_fit2$bestTune))[1]
  ##svm cv
    tc<-tune.control(cross=K)
    tuneSVMkernel<-tune(svm,label_train~.,data=hog_train_new,kernel="radial",ranges = list(cost=cost,gamma=gamma),tunecontrol = tc,scale=T)
    best_cost <- unlist(unname(tuneSVMkernel$best.parameters)[1])
    best_gamma<- unlist(unname(tuneSVMkernel$best.parameters)[2])
    
  ##print results  
    print("Baseline model cv results:")
    print(gbm_fit2$results)
    print("Advanced model cv results:")
    print(tuneSVMkernel$performances)
    
  ##return the best models
    return(c(best_ntree, best_gamma, best_cost))
    }


