function [equalNeighbours] = getAllNeighbours(indexcodes_all)
%compute the existing neighbours of a square. These neighbours can only be
%found outside of the parent square,because all other sides are part of
%the frame and come from the same parent.The index of the same size
%neighbour is found by the FSM.
numNodes=size(indexcodes_all,1);

equalNeighbours=cell(numNodes,1);
for s=1:numNodes
    equalNeighboursNode=nan(1,8);
    
    index=indexcodes_all(s,1);
    validDirections=getValidSearchDirections(indexcodes_all(s,2));
    for v=1:size(validDirections,2)
        
            %find the index of the same size neighbour in this direction.
            direction=validDirections(1,v);
            neighboursIndex=index;
            indexLength=ceil(log10(index));
            for k=1:indexLength
                [newValue,direction]=newIndexAndDirection(getCharacterDouble(index,k),direction);
                neighboursIndex=changeCharacterDouble(neighboursIndex,k,newValue);
                if isequal(direction,9)
                    break
                end
            end
            %find the adress of the found Neighbour
           tempindex=find(indexcodes_all==neighboursIndex,1);
           if ~isempty(tempindex)
                equalNeighboursNode(1,v)=tempindex;
           end
    end
    equalNeighboursNode=rmmissing(equalNeighboursNode);
    equalNeighbours{s,1}=equalNeighboursNode;
end

