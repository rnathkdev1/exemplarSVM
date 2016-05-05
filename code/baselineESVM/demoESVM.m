addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
I = imread('../../data/voc2007/000207.jpg');
load('../../data/bus_esvm.mat');

params = esvm_get_default_params(); %get default detection parameters
detectionBoxes = esvm_detect(I,models,params);

% for i=1:10
%     
%     X=models{i};
%     
%     figure;
%     imshow(imread(strcat('../../data/voc2007/',X.I)));
%     hold on
%     
%     XYrect=X.gt_box;
%     w=XYrect(3)-XYrect(1);
%     h=XYrect(4)-XYrect(2);
%     
%     rectangle('Position',[XYrect(1),XYrect(2),w,h],'EdgeColor','r');
%     hold off;
% end


showboxes(I,detectionBoxes);