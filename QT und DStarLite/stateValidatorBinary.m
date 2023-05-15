function [valid] = stateValidatorBinary(state,mapBinary,res)
%Determine in which pixel of a map the state is located and if this pixel
%is occupied
%With the map and the resolution the states can be matched to a pixel in
%the matrix of the binary map. This pixel has either a value of 1 or 0.
%On the map the zero is located in the bottom left of the matrix.

%Calculate corresponding pixel

adressX=ceil(state(1)*res);
adressY=floor(state(2)*res);

valid=mapBinary(end-adressY,adressX);

valid= ~valid;

end

