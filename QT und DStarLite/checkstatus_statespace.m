function [status] = checkstatus_statespace(states,validator)
%check if a square is compeltely part of C_free down to a defined
%resolution
%   Evaluate all states in a square until an occupied state is found
% It is also possible to determine if all stets are occuoied
% The status of ther first state determines which search is done
[numx,numy,numphi]=size(states);
if numx==2 || numy==2
    status=3; %minimum size reached
    return
end

    
mode=isStateValid(validator,[states(1,1,1) states(1,1,2) states(1,1,3)]);
numStates=size(states,1)*size(states,2);

if mode== 1    %%search if everything is vaild
     status=1;  %vaild
    for k=1:size(states,1)
        for v=1:size(states,2)
        if ~isStateValid(validator,[states(k,v,1) states(k,v,2) states(k,v,3)])
            status=0; %undecideable
            return
        end
        end
    end
   
    
else
    status=2; %invalid
    for k=1:size(states,1)
        for v=1:size(states,2)
        if isStateValid(validator,[states(k,v,1) states(k,v,2) states(k,v,3)])
            status=0; %undecideable
            return      
        end
        end
    end
    
end

