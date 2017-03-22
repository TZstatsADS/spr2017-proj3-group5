Remarks for the codes:
In order to run the codes, you need to download VLFeat 0.9.20 from http://www.vlfeat.org;
Put the 2000 training images in the folder /images;
After you run the codes, the output matrix will be saved in folder /output2/sift_pf-hists.mat.

About SIFT features:
As I mentioned on the lecture, the 3 steps that we generate feature are (check the pipeline in my presentation):
 
1, we extract raw SIFT feature from 2000 raw images, with contrast threshold and edge threshold both as 10, and then sample 50000 from them to save execution time
 
2, we run k-means with 5000 clusters over the key points , the final clusters (code book) is an 5000*128 matrix
 
3, we turn SIFT points from each image into new features by the code book (count the frequency), in another word, you can think each image is represented as 5000 dimensional vector and that is the feature you are going to feed into GBM, so that results 2000*5000 matrix
 
If you go through this procedure you will see that the feature we provided should be added up to one for each image, it is a probability representation for each image in the code book