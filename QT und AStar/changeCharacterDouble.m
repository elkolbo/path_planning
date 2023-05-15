function [newIndex] = changeCharacterDouble(index,place,newValue)
%Change a character within a number to a new value. Place is the counted
%from the right

oldValue=mod(index,10^place);
while oldValue>=10
    
    oldValue=floor(oldValue/10);
    
end
    
newIndex=index-oldValue*10^(place-1);
newIndex=newIndex+newValue*10^(place-1);


end

