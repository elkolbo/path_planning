
%% initialize
%define variables
mapsize=25.6;
start=[2 10 0];
goal=[24 19 0];
res=10;    %resolution cells/meter
minRes=2;

%define map
load exampleMaps.mat
map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
%map_binary=mapCreator(mapsize,start,goal,res);
map=occupancyMap(map_binary,res);

%% create QT
states=getstatesfrommap(map);
tic
[nodes] = createQuadtree(states,map_binary,minRes);
t=toc;


%% plot QT
disp('Quadtree plotten:')
figure
map.show
hold on
plot(nodes.states(:,1),nodes.states(:,2),'or')
%plotEdges(nodes.states,nodes.realNeighboursSmaller,nodes.realNeighboursBigger,nodes.realNeighboursEqual);

%% calculate path with A*
tic
path=A_Star(nodes,start,goal,map_binary,res,0.1);
plot(path(:,1),path(:,2),'-bx','LineWidth',2)
t=t+toc;
title(strcat('Planungsdauer: ',num2str(t),' s'));
xlabel('x [Meter]')
ylabel('y [Meter]')
title('Framed Quadtree')


