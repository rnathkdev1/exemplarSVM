addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_esvm.mat'); % This is the trained set 
load('../../data/bus_data.mat'); % This is the test set 
params = esvm_get_default_params(); 

%% Case 1: LPO=3
params.detect_levels_per_octave=3;

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, models, params);

% Evaluating the detection performance
[~,~,ap3] = evalAP(gtBoxes,boundingBoxes);

%% Case 1: LPO=5
params.detect_levels_per_octave=5;

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, models, params);

% Evaluating the detection performance
[~,~,ap5] = evalAP(gtBoxes,boundingBoxes);

%% Case 1: LPO=10
params.detect_levels_per_octave=10;

% Getting the bounding boxes for the test set
[boundingBoxes] = batchDetectImageESVM(gtImages, models, params);

% Evaluating the detection performance
[~,~,ap10] = evalAP(gtBoxes,boundingBoxes);

figure;
plot([3, 5, 10],[ap3,ap5,ap10]);
title('Plot of LPO versus AP');
xlabel('LPO');
ylabel('AP');

