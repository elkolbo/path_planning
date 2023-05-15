function [nodes] = createQuadtree(states,map,minRes)
%Calculate a quadtree structure for a map. minRes is the smallest allowed
%size of a square, where a node gets added. Choose minRes==0 to get a node
%for every Pixel of the map.
%  The map is divided into smaller squares until a square is completely
%  free or completely occupied. If it is free a node gets added in the
%  middle. This works best, when the mapSize is a power of 2, beacuse then
%  the squares can be equally divided down to the map resolution.
%  Otherwise there will be some nodes, that reach the minRes earlyer than
%  others. If a mapsize of 2^n is not possible the map should at least be
%  quadratic.

equalStates=states;

[nodes.states,indexcodes_all,indexcodes_occupied] = divideAndReturnNodes(equalStates,flipud(map),minRes,0);



nodes.neighboursSameSize=[];
nodes.realNeighboursEqual={};
nodes.realNeighboursSmaller={};
nodes.realNeighboursBigger={};


for k=1:size(nodes.states,1)

nodes.neighboursSameSize(k,:)=findNeighboursSameSize(indexcodes_all(k,1));

[nodes.realNeighboursEqual{k,1},nodes.realNeighboursBigger{k,1}]=getAllNeighbours(nodes.neighboursSameSize(k,:),indexcodes_all(k,1),indexcodes_all,indexcodes_occupied);

%delete indices, that are stored twice
  nodes.realNeighboursBigger{k,1} = sort(nodes.realNeighboursBigger{k,1});
  nodes.realNeighboursBigger{k,1}(diff(nodes.realNeighboursBigger{k,1}) == 0) = [];
 
[nodes.realNeighboursBigger{k,2},nodes.realNeighboursEqual{k,2}] = calculateCostToNeighbours(nodes.realNeighboursBigger{k,1},nodes.realNeighboursEqual{k,1},nodes.states,k);
end
[nodes.realNeighboursSmaller,nodes.realNeighboursBigger] = transferNeighbourhoodFromBigToSmall(nodes.realNeighboursBigger);

[nodes] = restrucutreNodesStructQT(nodes);
end

