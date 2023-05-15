function [directions] = getValidSearchDirections(framePosition)
%Calculate which directions lead outside of the frame. In this directions neighbours of the same size can  be found.
%valid search directions, that lead outside of the frame
%R: 1,5,6 L:2,7,8; D:3,5,7 U: 4,6,8
%%The order of the directions is : R L D U RD RU LD LU 

switch framePosition
    case 1
        directions=[1,5,6];
    case 2
        directions=[2,7,8];
    case 3
        directions=[3,5,7];
    case 4
        directions=[4,6,8];
    case 5
        directions=[1,3,5,6,7];
    case 6
        directions=[1,4,5,6,8];
    case 7
        directions=[2,3,5,7,8];
    case 8
        directions=[2,4,6,7,8];
    otherwise
        error('Diese Richtung existiert nicht!')
end
        
end

