function [path] = calculatePath(values,states,vBot)
%calculate the path by going trough the parents beginning at the start
%until the goal is reachedcd ..\.

path=states(vBot,:);
nextStep=values(vBot,3);
while ~isnan(nextStep)
   path(end+1,:)=states(nextStep,:);
   nextStep=values(nextStep,3);
end

end

