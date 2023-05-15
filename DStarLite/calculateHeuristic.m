function [heuristic] = calculateHeuristic(node,start)
%Returns the value of the heuristic function h(x) for every node. h(x) is
%the euclidian distance from the node to the goal.

    heuristic=sqrt((node(1,1)-start(1,1))^2+(node(1,2)-start(1,2))^2);
end

