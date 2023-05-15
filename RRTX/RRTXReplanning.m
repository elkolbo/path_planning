function [path,nodes,openList] = RRTXReplanning(vBot,nodes,openList,epsilon,r,mapBinary,mapRes,validationDistance)
%UNTITLED2 Summary of this function goes here
%   %nodes.values contains g,lmc,parent

[nodes,openList] = updateObstacles(nodes,openList,vBot,epsilon,r,mapBinary,mapRes,validationDistance);

if isnan(nodes.values(2,3)) %check if start got connected to the tree
    path=[];
else
    path=calculatePath(nodes.values,nodes.states,vBot);
end
end

