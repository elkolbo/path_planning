function [heuristic] = calculateHeuristic(nodes,goal)
%Returns the value of the heuristic function h(x) for every node. h(x) is
%the euclidian distance from the node to the goal.

    heuristic=sqrt((nodes(1,1)-goal(1,1))^2+(nodes(1,2)-goal(1,2))^2);
end

