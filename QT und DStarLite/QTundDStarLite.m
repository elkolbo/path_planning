%% Setup
%define Vairables
mapsize=25.6;
start=[2 2 0];
goal=[24 24 0];
mapRes=10;    %resolution cells/meter
minRes=2;

%% prepare map
load exampleMaps.mat
map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
%map_binary=mapCreator(mapsize,start,goal,mapRes);
map=occupancyMap(map_binary,mapRes);

%% create QT
states=getstatesfrommap(map);
[nodes] = createQuadtree(states,map_binary,minRes);
%% D* Lite
%calculate inital path
tic
[path,nodes,startAdress,goalAdress,successors,allNodes,openList]=DStarLiteMain(nodes,start,goal,map_binary,mapRes,0.1);
toc
km=0;

%% plot initial path/nodes
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')  %plot the nodes
%plotEdges(nodes.states,nodes.neighbours)
plot(path(:,1),path(:,2),'-bx','LineWidth',2)
title('')
xlabel('X [Meter]')
ylabel('Y [Meter]')

%% add obstacle and detect changes

%map_binary(49:70,144:148)=1;
map_binary(140:168,144:148)=1;
map=occupancyMap(map_binary,mapRes);
[changedEdges] = detectChangedEdgesDStar(nodes,map_binary,mapRes,0.1);


%% plan new path
tic
[path,nodes,km,allNodes,openList] = DStarLiteMainReplanning(nodes,startAdress,goalAdress,changedEdges,km,successors,allNodes,openList);
toc

%% plot new path
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')
%plotEdges(nodes.states,nodes.neighbours)
plot(path(:,1),path(:,2),'-bx','LineWidth',2)
title('')
xlabel('X [Meter]')
ylabel('Y [Meter]')
