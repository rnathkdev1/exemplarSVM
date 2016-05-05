function [CCenters,CMemberships] = MeanShift(data,bandwidth,stopThresh)

CCenters_=[];
CCenters=[];

regionCenters=[];
CMemberships=[];
regionCount=0;
% Extracting useful data
[N,F_]=size(data);
F=F_-1;

%% Begin clustering

for i=1:N
    i
    point=data(i,1:F);
    while(1)
        dist=pdist2(point, data(:,1:F));
        
%         figure(2)
%         scatter(data(:,1),data(:,2));
%         hold on;
%         axis equal;
%         scatter(point(1),point(2));
%         hold off;
%         
        
        % Checking for points in the bandwidth
        I=find(dist<bandwidth);
        
%         figure(1)
%         scatter(data(:,1),data(:,2));
%         hold on;
%         axis equal;
%         scatter(point(1),point(2));
%         circle(point(1),point(2),bandwidth);
%         hold off;
        
        wi=data(I,end);
        Xi=data(I,1:F);
        wi_=repmat(wi,[1,F]);
        
        %Finding weighted mean
        if length(I)~=1
            Xm = sum(Xi.*wi_)/sum(wi);
        else Xm = (Xi.*wi_)/sum(wi);
        end
        
        delta=pdist2(Xm,point);
        
        if delta < stopThresh
            CCenters_=cat(1,CCenters_,Xm);
            break;
        end
        point=Xm;
    end
    
   % After the point converges, we need to determine the region it belongs
   if isempty(regionCenters)
       regionCount=regionCount+1;
       regionCenters=cat(1,regionCenters,Xm);
       CMemberships=cat(1,CMemberships,regionCount);
   else
       distFromExistingCenters=pdist2(Xm,regionCenters);
       % This tells if the new point belongs to any of the existing clusters
       logicalBelong=distFromExistingCenters<0.75*bandwidth;
       % if any element of this is 1, then assign the ID. Else create a new
       % center
       J=find(logicalBelong==1);
       
       if isempty(J)
           regionCount=regionCount+1;
           regionCenters=cat(1,regionCenters,Xm);
           CMemberships=cat(1,CMemberships,regionCount);
       else 
           J=J(randperm(length(J),1));
           CMemberships=cat(1,CMemberships,J);
       end
   end
     
end


%Recalculating the region centers
for i=1:regionCount
    i
    K=CMemberships==i;
    points=CCenters_(K,:);
    if size(points,1)~=1
        CCenters=cat(1,CCenters,mean(points));
    else
        CCenters=cat(1,CCenters,points);
    end
      
end


end