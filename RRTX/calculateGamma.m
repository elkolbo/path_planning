function [gamma] = calculateGamma(mapBinary,res)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
freePixelCount=0;
for k=1:(size(mapBinary,1)*size(mapBinary,2))
    if mapBinary(k)==0
        freePixelCount=freePixelCount+1;
    end
end
     

freeArea=freePixelCount*(1/res)^2;

gamma=4*(1+0.5)*freeArea;
end

