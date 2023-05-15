function [] = updateKey(nodeAdress,k_new)
%Set the key of a node to a new value
global allNodes

allNodes(nodeAdress,5:6)=k_new;

end

