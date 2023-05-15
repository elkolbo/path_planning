function [newIndex,newDir] = newIndexAndDirection(index,direction)
%Implementation of the FSM of this Paper:A Practical Algorithm for Computing Neighbors in Quadtrees, Octrees, and Hyperoctrees
%The order of the directions is : R L D U RD RU LD LU 
index=char(index);
    
switch direction
    case 1
       switch index
           case 1
               newIndex=2;
               newDir=9;
           case 2
                 newIndex=1;
               newDir=1;
           case 3
                 newIndex=4;
               newDir=9;
           case 4
                 newIndex=3;
               newDir=1;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
               
    case 2
        switch index
           case 1
               newIndex=2;
               newDir=2;
           case 2
                 newIndex=1;
               newDir=9;
           case 3
                 newIndex=4;
               newDir=2;
           case 4
                 newIndex=3;
               newDir=9;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
        
    case 3
        switch index
           case 1
               newIndex=3;
               newDir=9;
           case 2
                 newIndex=4;
               newDir=9;
           case 3
                 newIndex=1;
               newDir=3;
           case 4
                 newIndex=2;
               newDir=3;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
    case 4
        switch index
           case 1
               newIndex=3;
               newDir=4;
           case 2
                 newIndex=4;
               newDir=4;
           case 3
                 newIndex=1;
               newDir=9;
           case 4
                 newIndex=2;
               newDir=9;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
    case 6
        switch index
           case 1
               newIndex=4;
               newDir=4;
           case 2
                 newIndex=3;
               newDir=6;
           case 3
                 newIndex=2;
               newDir=9;
           case 4
                 newIndex=1;
               newDir=1;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
    case 5
        switch index
           case 1
               newIndex=4;
               newDir=9;
           case 2
                 newIndex=3;
               newDir=1;
           case 3
                 newIndex=2;
               newDir=3;
           case 4
                 newIndex=1;
               newDir=5;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
    case 7
        switch index
           case 1
               newIndex=4;
               newDir=2;
           case 2
                 newIndex=3;
               newDir=9;
           case 3
                 newIndex=2;
               newDir=7;
           case 4
                 newIndex=1;
               newDir=3;
           otherwise
               error('Dieser Quadrant existiert nicht!')
       end
    case 8
        switch index
           case 1
               newIndex=4;
               newDir=8;
           case 2
                 newIndex=3;
               newDir=4;
           case 3
                 newIndex=2;
               newDir=2;
           case 4
                 newIndex=1;
               newDir=9;
           otherwise
               error('Dieser Quadrant existiert nicht!')
        end
end
end


