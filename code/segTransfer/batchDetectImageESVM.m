function [boundingBoxes] = batchDetectImageESVM(imageNames, models, params)

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
% matlabpool('local',numCores);
parpool('local', numCores);

l=length(imageNames);
boundingBoxes = cell(1,l);

parfor i=1:l
    fprintf('Processing the image %s\n', imageNames{i});
    image = imread([source, imageNames{i}]);
    boundingBoxes{i}=esvm_detect(image,models,params);
end

%close the pool
fprintf('Closing the pool\n');
delete(gcp('nocreate'));

end
