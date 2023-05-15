function [maxIndexLength] = getMaxIndexLength(mapsizex,mapsizey,minres)
%determine the maximum index length possible by dividing the width and
%height of the map until one value is smaller than the minimum resolution.

maxIndexLength=0;

while mapsizex>minres && mapsizey>minres
    
    maxIndexLength=maxIndexLength+1;
    
    mapsizex=floor(mapsizex/2);
    mapsizey=floor(mapsizey/2);
 
end

end

