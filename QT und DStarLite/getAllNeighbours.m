function [equalNeighbours,biggerNeighbours] = getAllNeighbours(SameSizeNeighbours,index,indexcodes_all,indexcodes_occupied)
%compute existing neigbours from same size neigbours
%   The function findNeighboursSameSize returns all same size neigbours of
%   a node. All of the 8 directions are searched. First it is checkend if a
%   neighbour in the same size exists. Then it is checked if a bigger
%   neighbour exists.


equalNeighbours=[];
biggerNeighbours=[];
for k=1:8
    
    %looking for same size neighbours
    tempindex=find(indexcodes_all==SameSizeNeighbours(k),1);
    if ~isempty(find(indexcodes_occupied==SameSizeNeighbours(k),1))
        continue
    end
    
  
    %check, if bigger neighbour can exist
    
    [~,newdir]=newIndexAndDirection(getCharacterDouble(index,1),k);
    
    
    if isempty(tempindex)
        if newdir~=9 %9 equals 'halt' --> there can't be a bigger neighbour in this direction
            
            temp2=SameSizeNeighbours(k)/int64(10);
            while temp2~=0
                biggerNeighbourindex=find(indexcodes_all==temp2,1);
                if ~isempty(biggerNeighbourindex) 
                    biggerNeighbours=[biggerNeighbours biggerNeighbourindex];
                    break %bigger neighbour is found
                elseif ~isempty(find(indexcodes_occupied==temp2,1))
                    break
                end
                temp2=temp2/int64(10);
            end
            
            
        end
        
    
    else
        equalNeighbours=[equalNeighbours tempindex];
    end
  
end

