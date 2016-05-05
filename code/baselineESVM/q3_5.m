clear
clc

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set 

K=35; % for K means
reshapeDim=100;
alpha=5000; % Choose alpha random pixels

allImages=[];
numCores = 4;
boxImStack=cell(1,length(modelBoxes));
try
    fprintf('Closing any pools...\n');
%   matlabpool close; 
    delete(gcp('nocreate'))
catch ME
    disp(ME.message);
end
source='../../data/voc2007/';
fprintf('Starting a pool of workers with %d cores\n', numCores);
% [filterBank] = createFilterBank();
gaborArray = gaborFilterBank(5,8,39,39);
parpool('local', numCores);
for i=1:length(modelBoxes)    
    
    X=models{i};
    fprintf('Processing the image: %s\n',X.I)
    I=im2double(imread(strcat('../../data/voc2007/',X.I)));
    [X0,Y0,Z0]=meshgrid(1:size(I,2),1:size(I,1),1:size(I,3));
    rect=modelBoxes{i};
    
    [X,Y,Z]=meshgrid(rect(1):rect(3),rect(2):rect(4),1:3);
    RectIm=interp3(X0,Y0,Z0,I,X,Y,Z);
    NormIm=imresize(RectIm,[reshapeDim,reshapeDim]);
    boxImStack{i}=NormIm;
    
    [filterResponses] = gaborFeatures(NormIm,gaborArray,4,4);
    allImages=[allImages;filterResponses];
    
end

%close the pool
fprintf('Closing the pool\n');
delete(gcp('nocreate'));

%Choosing the responses from alpha random pixels in every image
randIndex=randperm(size(allImages,2),25000);
toKMeans=allImages(:,randIndex);

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

%% Calculating the mean image from the clusterID
meanImages=[];

for i=1:K
    Ind=find(Idx==i);
    % imageIndex=unique(floor((Ind-1)/60)+1);
    Images=boxImStack(Ind);
    imMat=cat(4,Images{:});
    meanIm=mean(imMat,4);
    meanImages=cat(4,meanImages,meanIm);
%     MeanImg=mean(Images);
%     MeanImgReshape=reshape(MeanImg,[reshapeDim,reshapeDim]);
%     meanImages=cat(4,meanImages,MeanImgReshape);
    
end

imdisp(meanImages);

%% Selecting K exemplars
[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap] = evalAP(gtBoxes,boundingBoxes);

%% K=20

K=20;

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

meanImages=[];

[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap_20] = evalAP(gtBoxes,boundingBoxes);

%% K=25

K=25;

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

meanImages=[];

[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap_25] = evalAP(gtBoxes,boundingBoxes);

%% K=45

K=45;

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

meanImages=[];

[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap_45] = evalAP(gtBoxes,boundingBoxes);

%% K=55

K=55;

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

meanImages=[];

[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap_55] = evalAP(gtBoxes,boundingBoxes);

%% K=10

K=10;

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);

meanImages=[];

[~,index] = pdist2(toKMeans,dictionary,'euclidean','Smallest',1);
index=unique(index);

newmodels=models(index);
params = esvm_get_default_params(); 

load('../../data/bus_data.mat'); % This is the test set 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, newmodels, params);

% Evaluating the detection performance
[~,~,ap_10] = evalAP(gtBoxes,boundingBoxes);

figure;
plot([10 20 25 35 45 55],[ap_10,ap_20,ap_25,ap,ap_45,ap_55]);