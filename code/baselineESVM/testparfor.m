clear;
clc;

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set 
load('../../data/bus_data.mat'); % This is the test set 
params = esvm_get_default_params(); 

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, models, params);

% Evaluating the detection performance
[rec,prec,ap] = evalAP(gtBoxes,boundingBoxes);
K=35; % for K means
reshapeDim=100;
alpha=150;

allImages=[];
numCores = 4;
try
    fprintf('Closing any pools...\n');
%   matlabpool close; 
    delete(gcp('nocreate'))
catch ME
    disp(ME.message);
end
source='../../data/voc2007/';
fprintf('Starting a pool of workers with %d cores\n', numCores);
[filterBank] = createFilterBank();
parpool('local', numCores);
parfor i=1:length(boundingBoxes)    
    
    X=models{i};
    fprintf('Processing the image: %s\n',X.I)
    I=im2double(imread(strcat('../../data/voc2007/',X.I)));
    [X0,Y0,Z0]=meshgrid(1:size(I,2),1:size(I,1),1:size(I,3));
    rect=modelBoxes{i};
    
    [X,Y,Z]=meshgrid(rect(1):rect(3),rect(2):rect(4),1:3);
    RectIm=interp3(X0,Y0,Z0,I,X,Y,Z);
    NormIm=imresize(RectIm,[reshapeDim,reshapeDim]);
    
    [filterResponses] = extractFilterResponses(NormIm, filterBank);
    
    allImages=[allImages;filterResponses];
    
end

%close the pool
fprintf('Closing the pool\n');
delete(gcp('nocreate'));

%Choosing the responses from alpha random pixels in every image
randIndex=randperm(reshapeDim*reshapeDim,alpha);
toKMeans=allImages(:,randIndex);

fprintf('Calculating K means\n');
[Idx,dictionary]=kmeans(toKMeans,K);



% for i=1:10
% 
%     X=models{i};
%     XYrect=modelBoxes{i};
%     
%     figure;
%     imshow(imread(strcat('../../data/voc2007/',X.I)));
%     hold on
%     
%     
%     w=XYrect(3)-XYrect(1);
%     h=XYrect(4)-XYrect(2);
%     
%     rectangle('Position',[XYrect(1),XYrect(2),w,h],'EdgeColor','r');
%     hold off;
% end
