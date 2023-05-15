function [smallerNeighbours,biggerNeighboursWithoutDoubles] = transferNeighbourhoodFromBigToSmall(biggerNeighbours)
%If 2 squares of different size are neighbours only the smaller one will
%have the bigger one detectet as a neighbour. This function assigns the
%smaller one as a neighbour of the bigger one.


smallerNeighbours=cell(size(biggerNeighbours,1),2);

for k=1:size(biggerNeighbours,1)
    
    
    for v=1:size(biggerNeighbours{k,1},2)
        smallerNeighbours{biggerNeighbours{k,1}(1,v),1}=[smallerNeighbours{biggerNeighbours{k,1}(1,v),1} k];
        
        %transfer the cost
        smallerNeighbours{biggerNeighbours{k,1}(1,v),2}=[smallerNeighbours{biggerNeighbours{k,1}(1,v),2} biggerNeighbours{k,2}(1,v)];
    end   
end

biggerNeighboursWithoutDoubles=biggerNeighbours;
end

