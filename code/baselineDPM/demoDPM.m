clc; clear
%% setting path and load model
addpath(genpath('../utils'));
addpath(genpath('../lib/dpm'));
load('../../data/bus_dpm.mat');

%% Object detection via DPMs
I = imread('../../data/voc2007/001626.jpg');
% 009315.jpg'
detectionBoxes = imgdetect(I,model);
figure; showboxes(I,  detectionBoxes);      %% show detected bounding boxes.

%% Non-Maximum suppression
bestBBox = nms(detectionBoxes,200,1);
figure; hold on; image(I); axis ij; hold on;
showboxes(I,  bestBBox);

