function [angle] = pathSmoothness(path)
%This function evaluates the average angle between path segments of a
%planned path. The angle is calculated as angle between 2 vectors. For each
%state these vectors result from the connecting vector from the state to
%the state before and the state after. The vector after a state is the
%vector before the next state. Only angles, that are not zero are used,
%so this function gives the average value of all angeled segments and not
%all segments!

angle=0;
numSegments=1;
%init v_after with first vector
v_after(1)=path(2,1)-path(1,1);
v_after(2)=path(2,2)-path(1,2);

for k=2:size(path,1)-1
    
    v_before=v_after;
    
    v_after(1)=path(k+1,1)-path(k,1);
    v_after(2)=path(k+1,2)-path(k,2);
    
    angle_new=real(acosd(dot(v_after / norm(v_after), v_before / norm(v_before))));
    
    if angle_new ~=0
        angle=angle+angle_new;
        numSegments=numSegments+1;
    end
    
end
angle=angle/numSegments;
end
