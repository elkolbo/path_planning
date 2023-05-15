function [nodes,vAdress] = extend(v,r,nodes,mapBinary,mapRes,validationDistance)
%extend a newly added node: find neighbours and parent
%   Detailed explanation goes here

nearNodeAdresses=near(v,r,nodes.states);
[parentDistance,parentAdress,lmcBest] = findParent(v,nearNodeAdresses,nodes,mapBinary,mapRes,validationDistance);

if isempty(parentAdress)
    vAdress=[];
    return
end
nodes.states(end+1,:)=v;
nodes.values(end+1,1:2)=[Inf ,lmcBest];
nodes.values(end,3:4)=[parentAdress,parentDistance];

vAdress=size(nodes.states,1);
%Add node to parents child set
nodes.childs=[nodes.childs;{[],[]}];
nodes.childs{parentAdress,1}(1,end+1)=vAdress;
nodes.childs{parentAdress,2}(1,end+1)=parentDistance;

%extend cell arrays


nodes.neighboursOutInitial=[nodes.neighboursOutInitial;{[],[]}];
nodes.neighboursInRunning=[nodes.neighboursInRunning;{[],[]}];
nodes.neighboursOutRunning=[nodes.neighboursOutRunning;{[],[]}];
nodes.neighboursInInitial=[nodes.neighboursInInitial;{[],[]}];

for k=1:size(nearNodeAdresses,1) %handle the neighbour relations
   
    if motionValidatorBinary(v,nodes.states(nearNodeAdresses(k,1),:),mapBinary,mapRes,validationDistance) %no differential constraints so edge is valid in both directions
        
    nodes.neighboursOutInitial{vAdress,1}(1,end+1)=nearNodeAdresses(k,1);
    nodes.neighboursInRunning{nearNodeAdresses(k,1),1}(1,end+1)=vAdress;
    nodes.neighboursOutRunning{nearNodeAdresses(k,1),1}(1,end+1)=vAdress;
    nodes.neighboursInInitial{vAdress,1}(1,end+1)=nearNodeAdresses(k,1);
    
    %store the cost to neighbours
    nodes.neighboursOutInitial{vAdress,2}(1,end+1)=nearNodeAdresses(k,2);
    nodes.neighboursInRunning{nearNodeAdresses(k,1),2}(1,end+1)=nearNodeAdresses(k,2);
    nodes.neighboursOutRunning{nearNodeAdresses(k,1),2}(1,end+1)=nearNodeAdresses(k,2);
    nodes.neighboursInInitial{vAdress,2}(1,end+1)=nearNodeAdresses(k,2);
    end
end


end

