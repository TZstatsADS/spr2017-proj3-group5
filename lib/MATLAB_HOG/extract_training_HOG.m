run('D:\vlfeat\vlfeat-0.9.20\toolbox\vl_setup')
pfx = fullfile('C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_sift','images','image_0001.jpg') ;
im = imread(pfx) ;
im=im2single(im);
im=imbinarize(im);
cellSize = 8 ;
hog = vl_hog(im, cellSize, 'verbose') ;
