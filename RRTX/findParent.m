function [parentDistance,parentAdress,lmcBest] = findParent(v,nearNodeAdresses,nodes,mapBinary,mapRes,validationDistance)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
lmcBest=Inf;
parentDistance=[];
parentAdress=[];
for k=1:size(nearNodeAdresses,1)
    distance=norm(nodes.states(nearNodeAdresses(k,1),:)-v);
    
    if nodes.values(nearNodeAdresses(k,1),2)+distance<lmcBest && motionValidatorBinary(v,nodes.states(nearNodeAdresses(k,1),:),mapBinary,mapRes,validationDistance)
    lmcBest=nodes.values(nearNodeAdresses(k,1),2)+distance;
    parentAdress=nearNodeAdresses(k,1);
    parentDistance=distance;
    
    end
    
end
end

