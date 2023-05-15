%% Setup

%define variables
mapsize=25.6;
start=[5 3.3 0];
goal=[24 24 0];
res=10;    %resolution cells/meter
minRes=2;
minResFrame=minRes;
validationDistance=0.1;

%define map
load exampleMaps.mat
map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
%map_binary=mapCreator(mapsize,start,goal,res);
map=occupancyMap(map_binary,res);

%% create FQT
states=getstatesfrommap(map);
[nodes] = createFramedQuadtree(states,map_binary,minRes,minResFrame);

%% D* Lite

%plan initial path
tic
[path,nodes,startAdress,goalAdress,successors,allNodes,openList]=DStarLiteMain(nodes,start,goal,map_binary,res,validationDistance);
toc
km=0;

%% plot path/nodes
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')
plot(path(:,1),path(:,2),'-bx','LineWidth',2)
xlabel('x [Meter]')
ylabel('y [Meter]')
title('Framed Quadtree')

%% add obstacle and detect changed edges
map_binary(141:160,120:144)=1;
map=occupancyMap(map_binary,res);
[changedEdges] = detectChangedEdgesDStar(nodes,map_binary,res,validationDistance);

%% plan new path
tic
[path,nodes,km,allNodes,openList] = DStarLiteMainReplanning(nodes,startAdress,goalAdress,changedEdges,km,successors,allNodes,openList);
toc

%% plot new path/nodes
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')
plot(path(:,1),path(:,2),'-bx','LineWidth',2)