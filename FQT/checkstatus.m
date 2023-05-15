function [status] = checkstatus(map,minRes)
%check if a square is compeltely part of C_free down to a defined
%resolution
%   Evaluate all states in a square until an occupied state is found
% It is also possible to determine if all states are occupied
% The status of ther first state determines which search is done

[numx,numy,~]=size(map);
if numx<=minRes || numy<=minRes
    status=2; %minimum size reached
    return
end

mode=map(1,1);

if mode == 0    %%search if everything is vaild
     status=1;  %vaild
    for k=1:numx
        for v=1:numy
        if map(k,v) == 1
            status=0; %undecideable
            return
        end
        end
    end
   
    
else
    status=2; %invalid
    for k=1:numx
        for v=1:numy
        if map(k,v)==0
            status=0; %undecideable
            return      
        end
        end
    end
    
end

