function [path,nodes,startAdress,goalAdress,successors,allNodes,openList] = DStarLiteMain(nodes,start,goal,mapBinary,mapRes,validationDistance)
%Main loop of the D*Lite algorithm
%bezieht sich auf Paper: D* Lite, Koenig


%Preparing

%Adding start and goal to the tree

%calculate start and goal Neighbours
[neighbour_start,distance_neighbour_start,neighbour_goal,distance_neighbour_goal] = includeStartAndGoal(nodes.states,start,goal,mapBinary,mapRes,validationDistance);

nodes.states=[nodes.states;start;goal];
nodes.neighbours=[nodes.neighbours ;{neighbour_start' ,distance_neighbour_start'; ...
    neighbour_goal' ,distance_neighbour_goal'}];

goalAdress=size(nodes.states,1);
successors=cell(size(nodes.states,1),2);

%check if goal and start got connected to the tree
if isempty(neighbour_goal)||isempty(neighbour_start)
    path=[]; %if they are not connected no path existst
    return
end

%transfer neighbourhood of goal and start
for v=1:size(nodes.neighbours{goalAdress,1},2)
    nodes.neighbours{nodes.neighbours{goalAdress,1}(1,v),1}=[ nodes.neighbours{nodes.neighbours{goalAdress,1}(1,v),1} goalAdress];
    %Übertragen der Kosten
    nodes.neighbours{nodes.neighbours{goalAdress,1}(1,v),2}=[ nodes.neighbours{nodes.neighbours{goalAdress,1}(1,v),2} nodes.neighbours{goalAdress,2}(1,v)];
end

for v=1:size(nodes.neighbours{goalAdress-1,1},2)
    nodes.neighbours{nodes.neighbours{goalAdress-1,1}(1,v),1}=[ nodes.neighbours{nodes.neighbours{goalAdress-1,1}(1,v),1} goalAdress-1];
    %Übertragen der Kosten
    nodes.neighbours{nodes.neighbours{goalAdress-1,1}(1,v),2}=[ nodes.neighbours{nodes.neighbours{goalAdress-1,1}(1,v),2} nodes.neighbours{goalAdress-1,2}(1,v)];
end   




startAdress=goalAdress-1;

[km,allNodes,openList] = initialize(goalAdress,start,goal,nodes.states);
[successors,allNodes,openList]=computeShortestPath(km,startAdress,nodes.neighbours,nodes.states,goal,successors,allNodes,openList);

pathAdresses=[startAdress];
path=nodes.states(startAdress,:);
nextAdress=startAdress;
while nextAdress ~=goalAdress
    if isempty(successors{nextAdress,1})
        path=[];
        disp('Kein Pfad gefunden. (D*Lite)')
        return
    end
    [nextAdress,~]=nextStep(successors{nextAdress,:},allNodes);
    path(end+1,:)=nodes.states(nextAdress,:);
    pathAdresses(end+1,:)=nextAdress;
end

if size(path,1)==1
    path=[];
end

end

