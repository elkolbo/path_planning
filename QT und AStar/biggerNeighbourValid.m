function [valid] = biggerNeighbourValid(index,direction)
%Implementation of the FSM of this Paper:A Practical Algorithm for Computing Neighbors in Quadtrees, Octrees, and Hyperoctrees
%In this Function it is checked, if there is a bigger neighbour possible in
%the search direction. The decision is based on the index and the search
%direction. A bigger neughbour can only exist, if the parent aquare is
%left.
index=char(index);
   valid=true;
switch direction
    case 1
       if index=='1' || index=='3'
                 valid=false;
       end
               
    case 2
        if index=='2' || index=='4'
                 valid=false;
       end
        
    case 3
        if index=='1' || index=='2'
                 valid=false;
       end
    case 4
        if index=='3' || index=='4'
                 valid=false;
       end
    case 6
        if index=='3'
                 valid=false;
       end
    case 5
        if index=='1'
           valid=false;
       end
    case 7
        if index=='2'
               valid=false;
       end
    case 8
        if index=='4'
                valid=false;
        end
end
end


