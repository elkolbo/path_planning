function [length] = calculatePathLength(path)
%calcualte the length of a path
length=0;
pLast=path(1,1:2);
for k=2:size(path,1)
    segmentLength=sqrt(((path(k,1)-pLast(1))^2)+((path(k,2)-pLast(2))^2));
    length=length+segmentLength;
    pLast=path(k,1:2);
end

