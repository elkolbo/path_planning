function [lower] = keyLess(openList,nodeValues)
%Evaluate if the lowest key on the openList is lower than the key of a node
%v. Only the values of the node et passed on

%lowest k1
lowestKey=min(openList(:,2));

%calculate key of node

nodeKey1=min(nodeValues(1),nodeValues(2));

if lowestKey<nodeKey1
    lower=true;
elseif lowestKey>nodeKey1
    lower=false;
else
    index=openList(:,2)==lowestKey;
    lowestKey2=min(openList(index,3));
    nodeKey2=nodeValues(1);
    
    if lowestKey2<nodeKey2
        lower=true;
    else
        lower=false;
    end
end



end

