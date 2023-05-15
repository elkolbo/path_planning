function [distBigger,distEqual] = calculateCostToNeighbours(biggerNeighbours,equalNeighbours,states,k)
%Calculate the euclidian Distance from one node to its neighbours
%   Go through all nodes and store the distance to the neighbours in the
%   same row as the nodes and in the same order as the neighbours appear in
%   this row

numNeighbours2=size(biggerNeighbours,2);
numNeighbours3=size(equalNeighbours,2);
distBigger=inf(1,numNeighbours2);
distEqual=inf(1,numNeighbours3);


for v=1:numNeighbours2
    distBigger(1,v)=sqrt((states(k,1)-states(biggerNeighbours(1,v),1))^2+(states(k,2)-states(biggerNeighbours(1,v),2))^2);
end


for v=1:numNeighbours3
    distEqual(1,v)=sqrt((states(k,1)-states(equalNeighbours(1,v),1))^2+(states(k,2)-states(equalNeighbours(1,v),2))^2);
end

end

