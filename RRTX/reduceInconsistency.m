function [openList,nodes] = reduceInconsistency(openList,nodes,vBot,epsilon,r,orphanNodes)
%reduce inconsictency within the tree
%openList: adress, key(1) key(2)

while size(openList,1)>0 &&(nodes.values(vBot,1)~=nodes.values(vBot,2) || nodes.values(vBot,1)==Inf || any(openList(:,1)==vBot) ||keyLess(openList,nodes.values(vBot,:)))
    
    %find the node with lowest key
    lowestKey=min(openList(:,2));
    tempAdress=find(openList(:,2)==lowestKey);
    if length(tempAdress)>1
        [~,tempAdress1]=min(openList(tempAdress,3));
        adressOpenList=tempAdress(tempAdress1);
    else
        adressOpenList=tempAdress;
    end
    v=openList(adressOpenList,1);
    openList(adressOpenList,:)=[];
    
    if nodes.values(v,1)-nodes.values(v,2)>epsilon
        nodes=updateLMC(v,nodes,r,orphanNodes);
        [nodes,openList] = rewireNeighbours(v,nodes,epsilon,r,openList);
    end
    nodes.values(v,1)=nodes.values(v,2);
end

