function [neighboursIndex_all] = findNeighboursSameSize(index)
%paper for context: A Practical Algorithm for Computing Neighbors in Quadtrees, Octrees, and Hyperoctrees 
%   This function returns the index of the same size neighbours in a
%   quadtree. It even returns them, if there are no neighbours of the same
%   size. The order of the directions in neighboursIndex_all is : R L D U
%   RD RU LD LU 
neighboursIndex_all=[];


%right neighbour
direction=1; %'R';
neighboursIndex=index;
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=2; %'L';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=3;%'D';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=4;%'U';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=5;%'RD';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=6;%'RU';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=7;%'LD';
for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)=neighboursIndex;
 
 neighboursIndex=index;
 direction=8;%'LU';
 for k=1:ceil(log10(index))
     [newIndex,direction]=newIndexAndDirection(getCharacterDouble(neighboursIndex,k),direction);
     [neighboursIndex] = changeCharacterDouble(neighboursIndex,k,newIndex);
     if isequal(direction,9)
         break
     end
 end
 neighboursIndex_all(end+1)= neighboursIndex;
 
 

end

