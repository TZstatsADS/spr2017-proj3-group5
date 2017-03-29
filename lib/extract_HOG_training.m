% Using synthetic images is convenient and it
% enables the creation of a variety of training samples without having to
% manually collect them.
% Load training and test data using 

syntheticDir=fullfile('C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_HOG','images') ;

handwrittenDir=fullfile('C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_HOG','images_testing') ;
%recursively scans the directory tree containing the
% images. Folder names are automatically used as labels for each image.
trainingSet = imageSet(syntheticDir,  'recursive' );
testSet     = imageSet(handwrittenDir, 'recursive');
 
%%
% Show training samples
figure;
imshow(trainingSet(1).ImageLocation{3});

%%
% Prior to training and testing a classifier, a pre-processing step is
% applied to remove noise artifacts introduced while collecting the image
% samples. This provides better feature vectors for training the
% classifier.

% Show pre-processing results
exTrainImage = read(trainingSet(1), 3);
lvl = graythresh(exTrainImage);
processedImage = im2bw(exTrainImage,lvl);

figure;

subplot(1,2,1)
imshow(exTrainImage)

subplot(1,2,2)
imshow(processedImage)

%% Using HOG Features
% The data used to train the classifier are HOG feature vectors extracted
% from the training images. Therefore, it is important to make sure the HOG
% feature vector encodes the right amount of information about the object.
% The |extractHOGFeatures| function returns a visualization output that can
% help form some intuition about just what the "right amount of
% information" means. By varying the HOG cell size parameter and
% visualizing the result, you can see the effect the cell size parameter
% has on the amount of shape information encoded in the feature vector:

img = read(trainingSet(1), 3);


        if size(img,1) > 200
        img = imresize(img, [480 480]);
        level = graythresh(img);
        img = im2bw(img,level);
        end
% Extract HOG features and HOG visualization
%[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
%[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);
%[hog_16x16, vis16x16] = extractHOGFeatures(img,'CellSize',[16 16]);
%%
% Show the original image
figure; 
imshow(img);
%%

% Visualize the HOG features
% subplot(2,3,4);  
% plot(vis2x2); 
% title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});
% 
% subplot(2,3,5);
% plot(vis4x4); 
% title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});

 plot(vis8x8); 
 title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

% plot(vis16x16);
% title({'CellSize = [16 16]'; ['Feature length = ' num2str(length(hog_16x16))]});
%%
% The visualization shows that a cell size of [16 16] does not encode much
% shape information, while a cell size of [4 4] encodes a lot of shape
% information but increases the dimensionality of the HOG feature vector
% significantly. A good compromise is a 8-by-8 cell size. This size setting
% encodes enough spatial information to visually identify a digit shape
% while limiting the number of dimensions in the HOG feature vector, which
% helps speed up training. In practice, the HOG parameters should be varied
% with repeated classifier training and testing to identify the optimal
% parameter settings.

% cellSize = [16 16];
% hogFeatureSize = length(hog_16x16);

cellSize = [8 8];
hogFeatureSize = length(hog_8x8);

% Start by extracting HOG features from the training set. These features
% will be used to train the classifier.

trainingFeatures=[];
trainingLabels=[];
numImages=trainingSet(1).Count;
features=zeros(numImages,hogFeatureSize,'single');
    for i = 1:numImages
        img=read(trainingSet(1), i);
         if size(img,2) >=80
         img = imresize(img, [480 480]);
         level = graythresh(img);
         img = im2bw(img,level);
         end
        
       features(i,:) = extractHOGFeatures(img, 'CellSize', cellSize);
    end
    labels=repmat(trainingSet(1).Description,numImages,1);
    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels;   labels  ];   %#ok<AGROW>     
%%
%using PCA to reduce the dimension of training features to make it
%computationally feasible
[coeff,score,latent]=pca(trainingFeatures);

%%
%write the principal component matrix into a csv file for classification in
%R
csvwrite('C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_HOG\score8_8.csv', score);
