function [nodeAdresses] = near(v,r,states)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
nodeAdresses=[];
for k=1:size(states,1)
    distance=norm(v-states(k,:));
    if distance<=r
        nodeAdresses(end+1,1)=k;
        nodeAdresses(end,2)=distance;
    end
end
end

