function [nodes,openList] = updateObstacles(nodes,openList,vBot,epsilon,r,mapBinary,mapRes,validationDistance)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
orphanNodes=[];
if false %insert case for disappearing obstacles here

end

if true %only appearing obstacles will be watched
    [nodes,orphanNodes,openList] = detectChangedEdges(nodes,mapBinary,mapRes,validationDistance,openList,orphanNodes);
    [orphanNodes,nodes,openList] = propagateDescendants(orphanNodes,nodes,openList);
    openList=verifyQueue(vBot,openList,nodes);
    [openList,nodes]=reduceInconsistency(openList,nodes,vBot,epsilon,r,orphanNodes);
end

end

