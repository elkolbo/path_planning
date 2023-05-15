% Erkennen eines nachträglich zugefüghten Hindernis

ss = stateSpaceSE2;
tic

sv = validatorOccupancyMap(ss);

start = [2.5, 2.5,0];      %meter
goal = [0.3, 0.3,0];       %meter
mapsize=30;
res=10;    %resolution cells/meter

tic
load exampleMaps.mat
map_=mapCreator(mapsize,start,goal,res);
toc

map = occupancyMap(simpleMap,res);
sv.Map = map;

sv.ValidationDistance = 0.01;
ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];

planner = plannerRRTStar(ss,sv);
planner.ContinueAfterGoalReached = true;

%create RRT
planner1=plannerRRT(ss,sv);

planner.MaxIterations = 3000;
planner.MaxConnectionDistance = 0.4;
planner1.MaxConnectionDistance = 0.5;

%rng(100, 'twister') % repeatable result ; stellt zufallsgenerator ein
tic
[pthObj, solnInfo] = plan(planner,start,goal);
toc

tic
[pthObj1, solnInfo1] = plan(planner1,start,goal);
toc

subplot(1,4,1)
map.show;
hold on;

plot(solnInfo1.TreeData(:,1),solnInfo1.TreeData(:,2), '.-','Color','m'); % tree expansion
plot(pthObj1.States(:,1),pthObj1.States(:,2),'r-','LineWidth',2); % draw path

subplot(1,4,2)
map.show;
hold on;
plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2), '.-','Color','b'); % tree expansion
plot(pthObj.States(:,1),pthObj.States(:,2),'g-','LineWidth',2); % draw path

toc

%%hinzufügen eines Elements
simpleMap(:,11:14)=1;
map=occupancyMap(simpleMap,res);
sv.Map=map;


%%Prüfen, ob Pfad kollisionsfrei ist

for i = 1:size(pthObj.States,1)-1
    [isPathValid, lastValid] = isMotionValid(sv,pthObj.States(i,:),pthObj.States(i+1,:));
    if ~isPathValid
        subplot(1,4,3)
        map.show;
        hold on;
        plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2), '.-','Color','b'); % tree expansion
        plot(pthObj.States(:,1),pthObj.States(:,2),'g-','LineWidth',2); % draw path
        
        plot(lastValid(1),lastValid(2),'or')
        
        break
    end
end

%neuen Pfad freimachen
simpleMap(5:6,:)=0;
map=occupancyMap(simpleMap,res);
sv.Map=map;
planner = plannerRRTStar(ss,sv);
planner.ContinueAfterGoalReached = true;
planner.MaxIterations = 1500;
planner.MaxConnectionDistance = 0.5;
tic
%neuen Pfad planen
[pthObj2, solnInfo2] = plan(planner,start,goal);
toc
subplot(1,4,4)
map.show;
hold on;
plot(solnInfo2.TreeData(:,1),solnInfo2.TreeData(:,2), '.-','Color','b'); % tree expansion
plot(pthObj2.States(:,1),pthObj2.States(:,2),'g-','LineWidth',2); % draw path
