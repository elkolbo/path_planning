function [map] = mapCreator(size,start,goal,res)
%create a random map of the specified size and resolution


map=randn(size*res)-0.07; %substract to create more free space

%movmean to create smoother structures
map=movmean(movmean(map,15,1),15,2);
map=movmean(movmean(map,5,1),5,2);
map=movmean(movmean(map,7,1),7,2);

%add a frame
map(1:8,:)=1;
map(end-8:end,:)=1;
map(:,1:8)=1;
map(:,end-8:end)=1;

%clear a are around the start and the goal
map(ceil(abs(start(2)*res-5:start(2)*res+5)+1),floor(abs(start(1)*res-5:start(1)*res+5)+1)) = 0;
map(ceil(abs(goal(2)*res-5:goal(2)*res+5)+1),floor(abs(goal(1)*res-5:goal(1)*res+5)+1)) = 0;



%convert to a binary map
map(map<0)=0;
map=flipud(logical(map));

end

