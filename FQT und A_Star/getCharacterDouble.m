function [value] = getCharacterDouble(index,place)
%Get the value of a double var at a specific position.Position is counted
%from the right

value=mod(index,10^place);
while value>=10
    
    value=floor(value/10);
    
end
end

