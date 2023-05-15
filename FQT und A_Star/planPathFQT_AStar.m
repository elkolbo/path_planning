function [path] = planPathFQT_AStar(map,map_binary,minRes,minResFrame,start,goal)

states=getstatesfrommap(map);

[nodes] = createFramedQuadtree(states,map_binary,minRes,minResFrame);

path=A_Star(nodes,start,goal);
end

