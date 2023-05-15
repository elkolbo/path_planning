function [path] = planPathQT_AStar(map,map_binary,minRes,start,goal)

states=getstatesfrommap(map);

[nodes] = createQuadtree(states,map_binary,minRes);

path=A_Star(nodes,start,goal);
end

