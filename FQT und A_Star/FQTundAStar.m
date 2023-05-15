%% Setup

%define variables
mapsize=25.6;
start=[1 1 0];
goal=[24 24 0];
res=10;    %resolution cells/meter
minRes=4;
minResFrame=minRes;

%define map
load exampleMaps.mat
map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
%map_binary=mapCreator(mapsize,start,goal,res);
map=occupancyMap(map_binary,res);


%% create FQT

states=getstatesfrommap(map);
tic
[nodes] = createFramedQuadtree(states,map_binary,minRes,minResFrame);

%% calculate path with A*
path=A_Star(nodes,start,goal,map_binary,res,0.1);
t=toc;

%% plot the path/nodes/edges
disp('Quadtree plotten:')
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')
%plotEdges(nodes.states,nodes.neighboursSameFrame,nodes.realNeighboursEqual);
plot(path(:,1),path(:,2),'-gx','LineWidth',2)
title(strcat('Planungsdauer: ',num2str(t),' s'));




