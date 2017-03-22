%extract_sift_testing

function extract_sift_poddleVsChicken()
run('D:\vlfeat\vlfeat-0.9.20\toolbox\vl_setup')
conf.calDir = './' ; % calculating directory
conf.dataDir = './images_testing/' ; % data (image) directory 
conf.outDir = './output2_testing/'; % output directory
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
%                                           Compute spatial histograms
% --------------------------------------------------------------------
cd 'C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_sift\output2'
load sift_pf-vocab.mat
cd 'C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_sift'
model.vocab=vocab;
if strcmp(model.quantizer, 'kdtree')
  model.kdtree = vl_kdtreebuild(vocab) ;
end

imagefilesAll = dir(strcat(conf.dataDir,'*.jpg'));      
nfilesALL = length(imagefilesAll);


%ads3 calculate 5000*200
cd 'C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_sift\output2_testing'
csvwrite('sift_pf_hists.csv',sift_pf-hists.mat)
cd 'C:\Users\wangsong\Documents\applied data science\spr2017-proj3-group5\doc\MATLAB_sift'

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
  csvwrite('./output2_testing/hists_sparse_full.csv',hists_sparse);

else
  load(conf.histPath);
end
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

end

function im = standarizeImage(im)
% -------------------------------------------------------------------------

im = im2single(im) ;
if size(im,1) > 480, im = imresize(im, [480 NaN]) ; end
end
