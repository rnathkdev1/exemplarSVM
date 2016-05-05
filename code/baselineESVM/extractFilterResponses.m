function [filterResponses] = extractFilterResponses(I, filterBank)

filterResponses=[];

for i=1:length(filterBank)
    
    filtered=imfilter(I,filterBank{i});
    R=filtered(:,:,1);
    G=filtered(:,:,2);
    B=filtered(:,:,3);
    
    filterResponses=cat(2,filterResponses,R(:)');
    filterResponses=cat(2,filterResponses,G(:)');
    filterResponses=cat(2,filterResponses,B(:)');

end