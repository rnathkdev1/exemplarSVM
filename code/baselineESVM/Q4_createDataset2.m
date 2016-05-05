% create right bus list

clear;
clc;

gtImages_right{1}='000971.jpg';%23
% gtImages_right{2}='002278.jpg';%47
gtImages_right{2}='006290.jpg';%126
gtImages_right{3}='008966.jpg';%200
gtImages_right{4}='009627.jpg';%221
gtImages_right{5}='009685.jpg';%223
gtImages_right{6}='004552.jpg';%95

load('../../data/bus_esvm.mat');
models_right{1}=models{23};
% models_right{2}=models{47};
models_right{2}=models{126};
models_right{3}=models{200};
models_right{4}=models{221};
models_right{5}=models{223};
models_right{6}=models{95};


save('gtImages_right','gtImages_right','models_right');