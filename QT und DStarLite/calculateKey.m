function [key,node] = calculateKey(node,km)
%calculate key to order the priority queue
%nodes are built in columns like this: adress, g, rhs,
%heuristic,key(1),key(2)

key=min([node(1,1)+node(1,3)+km,node(1,2)+node(1,3)+km]);

node(1,4:5)=[key,min([node(1,1),node(1,2)])];
end

