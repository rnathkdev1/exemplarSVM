clear;
clc;

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set

i=67;

    % showHOG(models{i}.model.w);
    % imagesc(im)
    source='../../data/voc2007/';
    imagename=models{i}.I;
    I=im2double(imread([source,imagename]));
    imshow(I);
    hold on;
    
    w=modelBoxes{i}(3)-modelBoxes{i}(1);
    h=modelBoxes{i}(4)-modelBoxes{i}(2);
    rectangle('Position',[modelBoxes{i}(1),modelBoxes{i}(2),w,h],'EdgeColor','r');
    hold off;

[X0,Y0,Z0]=meshgrid(1:size(I,2),1:size(I,1),1:size(I,3));
rect=modelBoxes{i};

[X,Y,Z]=meshgrid(rect(1):rect(3),rect(2):rect(4),1:3);
RectIm=interp3(X0,Y0,Z0,I,X,Y,Z);
RectIm=rgb2gray(RectIm);

imageSegmenter

model=models(i);
modelBox=modelBoxes(i);

save('Im_rightsegment','modelBox','model','mask','BW','maskedImage');



