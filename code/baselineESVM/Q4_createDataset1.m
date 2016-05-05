% create left bus list
clear;
clc;
% gtImages_left{1}='000195.jpg';
gtImages_left{1}='000288.jpg';
% gtImages_left{3}='001626.jpg';
gtImages_left{2}='004530.jpg';
gtImages_left{3}='004544.jpg';
gtImages_left{4}='004910.jpg';
gtImages_left{5}='006218.jpg';
% gtImages_left{6}='007074.jpg';
gtImages_left{6}='007095.jpg';
gtImages_left{7}='009734.jpg';

load('../../data/bus_esvm.mat');
models_left{1}=models{7};
models_left{2}=models{93};
models_left{3}=models{94};
models_left{4}=models{102};
models_left{5}=models{125};
% models_left{6}=models{140};
models_left{6}=models{141};
models_left{7}=models{224};


save('gtImages_left','gtImages_left','models_left');
