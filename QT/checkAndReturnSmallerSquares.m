function [smallNeighbourIndex] = checkAndReturnSmallerSquares(index,dir)
%Calculating the index of smaller nodes in the search direction and checking if they are occupied


global indexcodes_occupied
smallNeighbourIndex=[];
for k=1:length(index)
    switch dir
        case 1 %searching for a neighbour to the right. Smaller neighbour to the right has to end with 1 or 3. Index of the same size neighbour gets a 1 and a 3 added to the end
            index1=[index*10+1, index*10+3];
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
            
        case 2
            index1=[index*10+2, index*10+4];
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
            
        case 3
            index1=[index*10+1, index*10+2];
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
            
        case 4
            index1=[index*10+3, index*10+4];
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
            
        case 5  %%Same size neighbour RD -> Add 1 to the index
            index1=index*10+1;
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
        case 6
            index1=index*10+3; %RU
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
        case 7
            index1=index*10+2; %LD
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
        case 8
            index1=index*10+4; %LU
            for v=1:length(index1)
                if isempty(find(index1(v)==indexcodes_occupied,1))
                    smallNeighbourIndex=[smallNeighbourIndex index1(v)];
                end
            end
    end
end
end

