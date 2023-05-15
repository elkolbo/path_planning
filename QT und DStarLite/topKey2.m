function [lowestKey] = topKey2(openListKeys)
%calculate the lowest priority of all the nodes on the open list
%the key has two components: it is checked for k(2).
if isempty(openListKeys)
    lowestKey=Inf;
else
lowestKey=min(openListKeys(:,1));
end
end
