clear;
clc;

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set
% 
for i=1:length(modelBoxes)
    % showHOG(models{i}.model.w);
    % imagesc(im)
    source='../../data/voc2007/';
    imagename=models{i}.I;
    I=rgb2gray(imread([source,imagename]));
    imshow(I);
    hold on;
    
    w=modelBoxes{i}(3)-modelBoxes{i}(1);
    h=modelBoxes{i}(4)-modelBoxes{i}(2);
    rectangle('Position',[modelBoxes{i}(1),modelBoxes{i}(2),w,h],'EdgeColor','r');
    hold off;
    
end
 
%% Creating 2 segmentations
% FOR image 12


source='../../data/voc2007/';
imagename='000195.jpg';
I=rgb2gray(imread([source,imagename]));


w=modelBoxes{i}(3)-modelBoxes{i}(1);
h=modelBoxes{i}(4)-modelBoxes{i}(2);
ratio=w/h;
model=models(i);
modelBox=modelBoxes(i);
save('Im_leftsegment','modelBox','model','mask_left','BW_left','maskedImage_left');


