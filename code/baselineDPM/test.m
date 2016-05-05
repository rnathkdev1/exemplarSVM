clear; clc
load('baselineDPM/q21_data.mat');


bandwidth =30;  % This is an example. You may need to adjust this value
threshold = bandwidth*0.01; % This is an example. You may need to adjust this value
[clusterCenters,clusterMemberships] = MeanShift(data,bandwidth,threshold);

figure(2)
scatter(data(:,1),data(:,2),20,clusterMemberships);
hold on;
axis equal;
scatter(clusterCenters(:,1),clusterCenters(:,2));
hold off;
