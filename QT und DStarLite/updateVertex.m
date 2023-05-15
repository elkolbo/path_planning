function [validSuccessor,openList,node] = updateVertex(adress,km,openList,node)
%Update the values of a vertex
%nodes are built in columns like this: g,rhs,heuristic,key(1),key(2)
%open list contains the adresses of the nodes on the open list


validSuccessor=false;
if isempty(openList)
    isOnOpenList=0;
else
    isOnOpenList=any(openList==adress,1);
end

if node(1,1)~=node(1,2) && isOnOpenList
    key=min([node(1,1)+node(1,3)+km,node(1,2)+node(1,3)+km]);
    node(1,4:5)=[key,min([node(1,1),node(1,2)])];
    validSuccessor=true;
elseif node(1,1)~=node(1,2) && ~isOnOpenList
    openList(end+1,1)=adress;
    key=min([node(1,1)+node(1,3)+km,node(1,2)+node(1,3)+km]);
    node(1,4:5)=[key,min([node(1,1),node(1,2)])];
    validSuccessor=true;
elseif node(1,1)==node(1,2) && isOnOpenList
    openList(openList==adress,:)=[];
    validSuccessor=false;
end

end

