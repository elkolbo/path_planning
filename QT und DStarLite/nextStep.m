function [minSuccessorAdress,minSuccessorCost] = nextStep(successorsAdresses,successorsCosts,allNodes)
%Determine which step is the next in the path by comparing all successors
%of a node to each other

if isempty(successorsAdresses)
    minSuccessorAdress=nan;
    minSuccessorCost=Inf;
    return
end

%initialize
minSuccessorAdress= successorsAdresses(1,1);
minSuccessorCost=successorsCosts(1,1) + allNodes(minSuccessorAdress,1);

for k=2:length(successorsAdresses)
    adress=successorsAdresses(1,k);
    cost=successorsCosts(1,k) +allNodes(adress,1);
    
    if cost<minSuccessorCost
        minSuccessorAdress=adress;
        minSuccessorCost=cost;
    end 
    
end

end

