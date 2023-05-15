function [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,v)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

index=openList(:,1)==v;
openList(index,:)=[];

orphanNodes(end+1,1)=v;

end

