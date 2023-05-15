function [motionValid] = motionValidatorBinary(v,u,mapBinary,mapRes,validationDistance)
%Decide if a motion between two states is valid
%

dir=(v-u)/sqrt((v(1)-u(1))^2+(v(2)-u(2))^2);

motionValid=true;

%check the v state
temp=v;
adressX=ceil(temp(1)*mapRes);
adressY=floor(temp(2)*mapRes);

valid=mapBinary(end-adressY,adressX);
valid= ~valid;   %negate, because the valid states in the map have the value 0 
if ~valid
    motionValid =false;
    return
end

temp=u;
while sqrt((v(1)-temp(1))^2+(v(2)-temp(2))^2)>validationDistance


adressX=ceil(temp(1)*mapRes);
adressY=floor(temp(2)*mapRes);

valid=mapBinary(end-adressY,adressX);
valid= ~valid;   %negate, because the valid states in the map have the value 0 
if ~valid
    motionValid =false;
    return
end
temp=temp+validationDistance*dir;

end
end

