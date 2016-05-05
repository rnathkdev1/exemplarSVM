clear;
clc

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set
% load('../../data/bus_data.mat'); % This is the test set
load('gtImages_right');
params = esvm_get_default_params();
source='../../data/voc2007/';

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages_right, models, params);

%% Cleaning up the bounding boxes
cleanedBoxes=[];

for i=1:length(gtImages_right)
    
    boxes=boundingBoxes{i};
    I=find(boxes(:,end)>=0);
    
    if isempty(I)
        w=boxes(:,3)-boxes(:,1);
        h=boxes(:,4)-boxes(:,2);
        
        ratio=w./h;
        I=find(ratio>1.1);
        
    end
    
    box=boxes(I,:);
    cleanedBoxes=cat(1,cleanedBoxes,box);
    I=imread([source,gtImages_right{i}]);
%     figure;
%     showboxes(I,box);
    
end

%% Transferring segmentation

load('Im_rightsegment.mat','mask','maskedImage');

for i=1:length(gtImages_right)
    thismodel=models{78};
    img=imread([source,gtImages_right{i}]);
    box=cleanedBoxes(i,:);
    
    w=box(:,3)-box(:,1);
    h=box(:,4)-box(:,2);
    
    % Reshaping the segmentation to size of bounding box
    
    thisSegmentation=imresize(mask,[h,w]);
    
    % Creating a blank template
    template=zeros(size(img,1),size(img,2));
    
    % Placing the bounding box in it
    template(round(box(2)):round(box(2))+size(thisSegmentation,1)-1,round(box(1)):round(box(1))+size(thisSegmentation,2)-1)=thisSegmentation;
    
    newImage=imfuse(img,template);
    
    figure;
    subplot(2,2,1);
    imshow(maskedImage);
    title('Exemplar')
    subplot(2,2,2);
    imshow(mask);
    title('Exemplar mask');
    subplot(2,2,3);
    imshow(newImage);
    title('Segmentation Transfer')
    subplot(2,2,4);
    imagesc(showHOG(thismodel.model.w));
    title('HOG');
    
end
