function vNew=saturate(v,nearestState,maxConnectionDistance)
%position v_new on the line between v and nearestState so that v_new is
%maxConnectionDistance away from nearestState

direction=v-nearestState;
direction=direction/norm(direction);
vNew=nearestState+maxConnectionDistance*direction*0.999;


   
end

