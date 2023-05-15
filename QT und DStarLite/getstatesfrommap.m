function [states] = getstatesfrommap(map)
%Get all States within a map at the reolution of the map
%  Make a linspace within the borders of the statespace
   
states=zeros(map.GridSize(1),map.GridSize(2),3);
   
xstate=linspace(0,map.XWorldLimits(2),map.GridSize(2));
states(:,:,1)=repmat(xstate,map.GridSize(1),1);

ystate=linspace(0,map.YWorldLimits(2),map.GridSize(1));
states(:,:,2)=repmat(ystate',1,map.GridSize(2));


    
end

