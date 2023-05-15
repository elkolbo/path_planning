function [km,allNodes,openList] = initialize(goalAdress,start,goal,states)
%Initialize planning with D* Lite

allNodes=nan(size(states,1),5);
km=0;

allNodes(1:end,1:2)=Inf; %rhs and g 
allNodes(goalAdress,2)=0;
openList=goalAdress;
for k=1:size(states,1)
   allNodes(k,3)=calculateHeuristic(start,states(k,:));
end

allNodes(goalAdress,4:5)=[calculateHeuristic(start,goal),0]; %calcualte keys of the goal
end

