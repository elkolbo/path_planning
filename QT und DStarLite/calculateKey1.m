function [key1] = calculateKey1(node,km)
%calculate key(1)
%nodes are built in columns like this: adress, g, rhs,
%heuristic,key(1),key(2)

key1=min([node(1,1)+node(1,3)+km,node(1,2)+node(1,3)+km]);

end
