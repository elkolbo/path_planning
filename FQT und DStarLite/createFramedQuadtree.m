function [nodes] = createFramedQuadtree(states,map,minRes,minResFrame)
%Calculate a quadtree structure for a map. minRes is the smallest allowed
%size of a square, where a node gets added. Choose minRes==0 to get a node
%for every Pixel of the map.
%  The map is divided into smaller squares until a square is completely
%  free or completely occupied. If it is free a frame of nodes is added to the square. This works best, when the mapSize is a power of 2, beacuse then
%  then the sqares can be equally divided down to the map resolution.
%  Otherwise there will be some nodes, that reach the minRes earlyer than
%  others. If a mapsize of 2^n is not possible the map should at least be
%  quadratic.

equalStates=states;
[mapsizex,mapsizey]=size(map);
[maxIndexLength] = getMaxIndexLength(mapsizex,mapsizey,minResFrame);
[nodes.states,indexcodes_all,~,nodes.neighboursSameFrame] = divideAndReturnNodes(equalStates,flipud(map),minRes,0,maxIndexLength,minResFrame);

[nodes.realNeighboursEqual]=getAllNeighbours(indexcodes_all);

for k=1:size(nodes.states,1)
[nodes.realNeighboursEqual{k,2},nodes.neighboursSameFrame{k,2}] = calculateCostToNeighbours(nodes.realNeighboursEqual{k,1},nodes.neighboursSameFrame{k,1},nodes.states,k);
end
[nodes] = restructureNodesStructFQT(nodes);
end

