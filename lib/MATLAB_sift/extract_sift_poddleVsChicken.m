% Extract SIFT features for poddle vs. fried chicken image set
% Require vlfeat-0.9.20
% Adapted codes from http://www.vlfeat.org/applications/caltech-101-code.html
% run('~/Documents/MATLAB/vlfeat-0.9.20/toolbox/vl_setup')
function extract_sift_poddleVsChicken()

conf.calDir = './' ; % calculating directory
conf.dataDir = './images/' ; % data (image) directory 
conf.outDir = './output2/'; % output directory
conf.numWords = 5000 ; % vocabulary size
conf.numSpatialX = 1 ; % spatial histogram configuration
conf.numSpatialY = 1 ;
conf.quantizer = 'kdtree' ; % search structure

conf.prefix = 'sift_pf' ;
conf.randSeed = 1 ;

conf.descrPath = fullfile(conf.outDir,[conf.prefix '-descr.mat']);
conf.vocabPath = fullfile(conf.outDir, [conf.prefix '-vocab.mat']);
conf.histPath = fullfile(conf.outDir, [conf.prefix '-hists.mat']) ;
conf.modelPath = fullfile(conf.outDir, [conf.prefix '-model.mat']) ;
conf.resultPath = fullfile(conf.outDir, [conf.prefix '-result']) ;


conf.descrPath = fullfile(conf.outDir, [conf.prefix '-selectedDescr.mat']);
conf.framePath = fullfile(conf.outDir, [conf.prefix '-selectedFrame.mat']);

randn('state',conf.randSeed) ;
rand('state',conf.randSeed) ;
vl_twister('state',conf.randSeed) ;

model.numSpatialX = conf.numSpatialX ;
model.numSpatialY = conf.numSpatialY ;
model.quantizer = conf.quantizer ;
model.vocab = [] ;

% --------------------------------------------------------------------
%                                                     Train vocabulary
% --------------------------------------------------------------------

file = fopen('train_img_names.csv');
imagenames = textscan(file, '%s %*[^\n]');
fclose(file);
imagenames = imagenames{:};
imagenames = imagenames(2:end);
[nfiles, s] = size(imagenames);

if ~exist(conf.vocabPath)

  % Get some SIFT descriptors to train the dictionary
  descrs = {} ;
  frame = {};
  img_names = {};
  %for ii = 1:length(selTrainFeats)
  %for ii = 1:nfiles
  for ii = 1:nfiles
    fprintf('Processing dictionary %s (%.2f %%)\n', imagenames{ii}, 100 * ii /nfiles) ;
    currentFileName = imagenames{ii};
    imm = imread(fullfile(conf.dataDir,currentFileName));
    if length(size(imm)) == 3
        im = single(rgb2gray(imm));
    else
        im = single(imm);
    end
    if size(im,1) > 480
        im = imresize(im, [480 NaN]);
        fprintf('\tResize.\n');
    end
    
    
    
    %ads3 sift keypoints
    
    
    
    %im pixel matrix for a image
    % VL_SIFT  Scale-Invariant Feature Transform
%   [F,D] = VL_SIFT(I) computes the SIFT descriptors [1] as well. Each
%   column of D is the descriptor of the corresponding frame in F. A
%   descriptor is a 128-dimensional vector of class UINT8.
%
%   VL_SIFT() accepts the following options:
%
%   Octaves:: maximum possible
%     Set the number of octave of the DoG scale space.
%
%   Levels:: 3
%     Set the number of levels per octave of the DoG scale space.
%
%   FirstOctave:: 0
%     Set the index of the first octave of the DoG scale space.
%
%   PeakThresh:: 0
%     Set the peak selection threshold.
%
%   EdgeThresh:: 10
%     Set the non-edge selection threshold.
%
%   NormThresh:: -inf
%     Set the minimum l2-norm of the descriptors before
%     normalization. Descriptors below the threshold are set to zero.
%
%   Magnif:: 3
%     Set the descriptor magnification factor. The scale of the
%     keypoint is multiplied by this factor to obtain the width (in
%     pixels) of the spatial bins. For instance, if there are there
%     are 4 spatial bins along each spatial direction, the
%     ``side'' of the descriptor is approximatively 4 * MAGNIF.
%
%   WindowSize:: 2
%     Set the variance of the Gaussian window that determines the
%     descriptor support. It is expressend in units of spatial
%     bins.
%
%   Frames::
%     If specified, set the frames to use (bypass the detector). If
%     frames are not passed in order of increasing scale, they are
%     re-orderded.
%
%   Orientations::
%     If specified, compute the orientations of the frames overriding
%     the orientation specified by the 'Frames' option.
%
%   Verbose::
%     If specfified, be verbose (may be repeated to increase the
%     verbosity level).
%
%   REFERENCES::
%     [1] D. G. Lowe, Distinctive image features from scale-invariant
%     keypoints. IJCV, vol. 2, no. 60, pp. 91-110, 2004.
%
%   See also: <a href="matlab:vl_help('sift')">SIFT</a>
%   VL_UBCMATCH(), VL_DSIFT(), VL_HELP().

% Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

    
    
    
    
    
    [frame{ii}, descrs{ii}] = vl_sift(im, 'PeakThresh', 10,'EdgeThresh',10);
    %descrs{ii} A
    %descriptor is a 128-dimensional vector of class UINT8.
    [m1, m2] = size(frame{ii});%%%m2??? number of keypoints?
    img_names{ii} = repmat(ii, m2, 1);
  end
  
  
  %when testing,, skip the sampling cat(2,descrs{:}) to a matrix 
  %cat by column cat(2,)
  [descrsSelected, sel_ind] = vl_colsubset(cat(2, descrs{:}), 50000); % subsample features descriptor if having limited computational resource
  descrsSelected = single(descrsSelected);
  %50000 keypoints
  save(conf.descrPath, 'descrsSelected'); 
  % save the corresponding frames for feature visualization
  framesSelected = horzcat(frame{:});
  framesSelected = framesSelected(:,sel_ind).';
  save(conf.framePath, 'framesSelected');
  % save the correspond image index for feature visualization
  imgSelected = cat(1, img_names{:});
  imgSelected = imgSelected(sel_ind, :);
  
  csvwrite('./output2/frameSelected.csv', framesSelected);
  csvwrite('./output2/imgSelected.csv', imgSelected);
  % Quantize the descriptors to get the visual words
  [vocab, assign] = vl_kmeans(descrsSelected, conf.numWords, 'verbose', 'algorithm', 'elkan', 'MaxNumIterations', 100) ;
  save(conf.vocabPath, 'vocab');
  
  assign_tr = assign.';
  csvwrite('./output/sift_feature_assign.csv', assign_tr);
  
else
  load(conf.vocabPath) ;
end

model.vocab = vocab ;

if strcmp(model.quantizer, 'kdtree')
  model.kdtree = vl_kdtreebuild(vocab) ;
end

% --------------------------------------------------------------------
%                                           Compute spatial histograms
% --------------------------------------------------------------------

imagefilesAll = dir(strcat(conf.dataDir,'*.jpg'));      
nfilesALL = length(imagefilesAll);


%ads3 calculate 5000*2000


if ~exist(conf.histPath)
  fprintf('Compute spatial histogram\n');
  hists = {} ;
  % parfor ii = 1:nfilesALL
  for ii = 1:nfilesALL
    fprintf('Processing dictionary %s (%.2f %%)\n', imagefilesAll(ii).name, 100 * ii /nfilesALL) ;
    %im = imread(fullfile(conf.calDir, images{ii})) ;
    currentFileName = imagefilesAll(ii).name;
    imm = imread(fullfile(conf.dataDir,currentFileName));
    
    
    
    
    %%%%get image descriptor
    
    
    
    
    hists{ii} = getImageDescriptor(model, imm);
  end

  hists = cat(2, hists{:}) ;
  save(conf.histPath, 'hists');
  %csvwrite('./sift_features_train.csv',sift_pf-hists)
  % Save the sparse matrix for the use of R
  [row,col,v] = find(hists);
  hists_sparse = [row, col, v];
  csvwrite('./output2/hists_sparse_full.csv',hists_sparse);

else
  load(conf.histPath);
end


% for testing, get image descriptor
function hist = getImageDescriptor(model, imm)
% -------------------------------------------------------------------------
if length(size(imm)) == 3
        im = single(rgb2gray(imm));
else
    im = single(imm);
end

if size(im,1) > 480
    im = imresize(im, [480 NaN]);
    fprintf('\tResize.\n');
end
%im = standarizeImage(im) ;
width = size(im,2) ;
height = size(im,1) ;
numWords = size(model.vocab, 2) ;

% get sift features
[frames, descrs] = vl_sift(im) ;

% quantize local descriptors into visual words
switch model.quantizer
  case 'vq'
    [drop, binsa] = min(vl_alldist(model.vocab, single(descrs)), [], 1) ;
  case 'kdtree'
    binsa = double(vl_kdtreequery(model.kdtree, model.vocab, ...
                                  single(descrs), ...
                                  'MaxComparisons', 50)) ;
end

for i = 1:length(model.numSpatialX)
  binsx = vl_binsearch(linspace(1,width,model.numSpatialX(i)+1), frames(1,:)) ;
  binsy = vl_binsearch(linspace(1,height,model.numSpatialY(i)+1), frames(2,:)) ;

  % combined quantization
  bins = sub2ind([model.numSpatialY(i), model.numSpatialX(i), numWords], ...
                 binsy,binsx,binsa) ;
  hist = zeros(model.numSpatialY(i) * model.numSpatialX(i) * numWords, 1) ;
  hist = vl_binsum(hist, ones(size(bins)), bins) ;
  hists{i} = single(hist / sum(hist)) ;
end
hist = cat(1,hists{:}) ;
hist = hist / sum(hist) ;

function im = standarizeImage(im)
% -------------------------------------------------------------------------

im = im2single(im) ;
if size(im,1) > 480, im = imresize(im, [480 NaN]) ; end
