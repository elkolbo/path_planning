function [path] = A_Star(tree,start,goal,mapBinary,mapRes,validationDistance)
%path planning with A*
%The start and goal nodes are connected with the tree. Then the path is
%planned from start to goal


%Preparing
%Adding start and goal to the tree

%calculate start and goal neighbours
[neighbour_start,distance_neighbour_start,neighbour_goal,distance_neighbour_goal] = includeStartAndGoal(tree.states,start,goal,mapBinary,mapRes,validationDistance);

tree.states=[tree.states;start;goal];
tree.neighbours=[tree.neighbours ;{neighbour_start' ,distance_neighbour_start'; ...
                            neighbour_goal' ,distance_neighbour_goal'}];

goalAdress=size(tree.states,1);

%transfer neighbourhood of goal
for v=1:size(tree.neighbours{goalAdress,1},2)
        tree.neighbours{tree.neighbours{goalAdress,1}(1,v),1}=[ tree.neighbours{tree.neighbours{goalAdress,1}(1,v),1} goalAdress];
        
        %transfer costs
        tree.neighbours{tree.neighbours{goalAdress,1}(1,v),2}=[ tree.neighbours{tree.neighbours{goalAdress,1}(1,v),2} tree.neighbours{goalAdress,2}(1,v)];
end



openList=[];  %1. column=adress;2. column=parent; 3. column g(node)=distance to node; 4. column h(node); 5. column f(node)=g+h
closedList=nan(goalAdress,1); %First column=parent  %Line is the adress


path_found=false;
openList(1,1:4)=[goalAdress-1, NaN,0, calculateHeuristic(tree.states(goalAdress-1,:),goal)];  %goalAdress-1 is the adress of the start because it is added at the end
openList(1,5)=openList(1,4);
while size(openList)>0
    
    [~, tempAdressOpen]=min(openList(:,5));
    currentNode=openList(tempAdressOpen,:);
    openList(tempAdressOpen,:)=[];
    closedList(currentNode(1),1)=currentNode(2); %Keep track of all parents in the tree order
       
    %mark all visited nodes(optional)
    %plot(tree.states(currentNode(1),1),tree.states(currentNode(1),2),'bs')
    
   if currentNode(1)==goalAdress %goal is reached
       path_found=true;
       break
   end
    
    successors=[];
    %search for neighbours and their cost
    successors(:,1)=[tree.neighbours{currentNode(1),1}'];
    successors(:,2)=[tree.neighbours{currentNode(1),2}'];
    %Add current cost so the second column is the total path cost up to this
    %node
    successors(:,2)=successors(:,2)+currentNode(3);
   
    for k=1:size(successors,1)
        
        %check if successor is on the closed list
        if ~isnan(closedList(successors(k,1),1))
                continue
        end
        
        %check if succesor is already in the open list and if the new path is
        %faster; otherwise add successor to the open List
        tempAdressOpen=find(openList(:,1)==successors(k,1),1);
        if ~isempty(tempAdressOpen)
            if openList(tempAdressOpen,3) <= successors(k,2) %there is already a shorter path to this node
                continue
            else %this path is a shorter path to this node
                openList(tempAdressOpen,2)=currentNode(1);  %change parent
                openList(tempAdressOpen,3)=successors(k,2);  %change cost
                openList(tempAdressOpen,5)= openList(tempAdressOpen,3)+ openList(tempAdressOpen,4); %change overall Cost to goal
                continue
            end
        end
        %add successor to the open list
        openList(end+1,1)=successors(k,1);
        openList(end,2)=currentNode(1);
        openList(end,3)=successors(k,2);
        openList(end,4)=calculateHeuristic(tree.states(successors(k,1),:),goal);
        openList(end,5)=openList(end,3)+openList(end,4);
        
        
        
    end
    
end

if ~path_found
    path=[];
    disp('Kein Pfad gefunden')
    return
end

%preallocate path for speed with upper size limit
path=nan(size(closedList,1),3);
%create path by going back through the parents
path(1,:)=tree.states(currentNode(1),:);
parent=currentNode(2);
k=2;
while ~isnan(parent)
    path(k,:)=tree.states(parent,:);
    parent=closedList(parent);
    k=k+1;
end
path=rmmissing(path);
end



