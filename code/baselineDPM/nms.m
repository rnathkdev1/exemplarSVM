function [refinedBBoxes] = nms(bboxes, bandwidth,K)

bboxes(:,5)=(bboxes(:,5)+5)*100;
stopThresh=0.01*bandwidth;
[CCenters,CMemberships] = MeanShift(bboxes,bandwidth,stopThresh);

numModes=size(CCenters,1);
modes=unique(CMemberships);
modeFreq = [modes,histc(CMemberships(:),modes)];
[~, I]=sort(modeFreq,'descend');
% showboxes(imread('q42_test.jpg'),  CCenters);
if numModes==1
    fprintf('Please adjust bandwidth. Only ONE bounding box found\n');
    refinedBBoxes=CCenters;
    return;
end
%Choosing the best K boxes

if numModes<K
    fprintf('Please adjust bandwidth. Only %d bounding boxes found\n',numModes);
    K=numModes;
end


bestIndices=I(1:K);
refinedBBoxes=CCenters(bestIndices,:);


end
