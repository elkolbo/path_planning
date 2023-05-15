function [neighbour_start,distance_neighbour_start,neighbour_goal,distance_neighbour_goal] = includeStartAndGoal(states,start,goal,mapBinary,mapRes,validationDistance)
%This function adds a node for the start and the goal and connects it with
%the nearest neighbours
%   The start and goal node are not part of the quadtree, because they are
%   not respected in the decomposition. With the minimal euclidian distance
%   to the states of the existing nodes the nearest nodes are found.

[distance_neighbour_start, neighbour_start]=mink(sqrt(((states(:,1)-start(1)).^2)+((states(:,2)-start(2)).^2)),4);

[distance_neighbour_goal, neighbour_goal]=mink(sqrt(((states(:,1)-goal(1)).^2)+((states(:,2)-goal(2)).^2)),4);

indexStart=[];
indexGoal=[];
for k=1:4 %check if connection to the neighbours is valid
    valid=motionValidatorBinary(start,states(neighbour_start(k),:),mapBinary,mapRes,validationDistance);
    
    if ~valid
      indexStart=[indexStart,k];
    end
    
    valid=motionValidatorBinary(goal,states(neighbour_goal(k),:),mapBinary,mapRes,validationDistance);
    
    if ~valid
        indexGoal=[indexGoal,k];
    end
end
 
distance_neighbour_start(indexStart)=[];
neighbour_start(indexStart)=[];
distance_neighbour_goal(indexGoal)=[];
neighbour_goal(indexGoal)=[];
end

