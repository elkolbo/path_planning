function [openList] =verifyQueue(v,openList,nodes)
%structure of open-list: adress,key(1) key(2)

if ~isempty(openList)
    pos=find(openList(:,1)==v);
else
    pos=[];
end
    
if ~isempty(pos)
    openList(pos,2:3)=[min(nodes.values(v,1),nodes.values(v,2)),nodes.values(v,1)];
else
    openList(end+1,:)=[v,min(nodes.values(v,1),nodes.values(v,2)),nodes.values(v,1)];
end
end

