function [key2] = calculateKey2(node)
%calculate key(2)
%nodes are built in columns like this: adress, g, rhs,
%heuristic,key(1),key(2)

key2=min([node(1,1),node(1,2)]);

end
