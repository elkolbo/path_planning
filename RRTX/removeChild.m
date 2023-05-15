function [allChilds,allChildsCost] = removeChild(allChilds,allChildsCost,invalidChild)
%If the parent of a node changes the node has to be removed from the child
%set of the old parent.

index=allChilds==invalidChild;
allChilds(index)=[];
allChildsCost(index)=[];


end

