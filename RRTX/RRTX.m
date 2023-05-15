%RRTX test

%%
%initialize variables
mapsize=25.6;
start=[0.8+(6)*rand(1) 19+1.5*rand(1) ];
goal=[mapsize-6.8+(6)*rand(1) 19+1.5*rand(1) ];
res=10;
iterations=1500;
maxConnectionDistance=15;
validationDistance=0.1;

%%
%define map
load exampleMaps.mat
map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
%map_binary=mapCreator(mapsize,start,goal,res);
map=occupancyMap(map_binary,res);
figure
map.show
hold on

%% 
%plan initial path
tic
[path,nodes,openList,vBot,epsilon,r] = RRTXMain(map_binary,start,goal,maxConnectionDistance,res,validationDistance,iterations);
toc

%plot initial path
plot(nodes.states(:,1),nodes.states(:,2),'rx')
plotTreeParent(nodes)
plot(path(:,1),path(:,2),'g','LineWidth',2)

%%
%add obstacle
map_binary(49:80,132:134)=1; %index defines size and locatin of the obstacle
map=occupancyMap(map_binary,res);

%%
%replan path
tic
[path,nodes,openList] = RRTXReplanning(vBot,nodes,openList,epsilon,r,map_binary,res,validationDistance);
toc

%%
%plot the new path
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'rx')
plotTreeParent(nodes)
plot(path(:,1),path(:,2),'g','LineWidth',2)