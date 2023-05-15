%%
%Prepare Planning
ss = stateSpaceSE2;
clear nodes
sv = validatorOccupancyMap(ss);
load exampleMaps.mat



%%
%prepare simulation
numIterations=input('Wie viele Iterationen sollen durchgeführt werden?');
randomMap=input('Soll bei jeder Iteration eine neue Karte erstellt werden?');

lengthFQT=zeros(numIterations,1);
minClearanceFQT=zeros(numIterations,1);
avgAngleFQT=zeros(numIterations,1);
timeFQT=zeros(numIterations,1);

lengthQT=zeros(numIterations,1);
minClearanceQT=zeros(numIterations,1);
avgAngleQT=zeros(numIterations,1);
timeQT=zeros(numIterations,1);

timeRRTX=zeros(numIterations,1);
lengthRRTX=zeros(numIterations,1);
minClearanceRRTX=zeros(numIterations,1);
avgAngleRRTX=zeros(numIterations,1);

timeRRTStar=zeros(numIterations,1);
lengthRRTStar=zeros(numIterations,1);
minClearanceRRTStar=zeros(numIterations,1);
avgAngleRRTStar=zeros(numIterations,1);

lengthQTDStar=zeros(numIterations,1);
minClearanceQTDStar=zeros(numIterations,1);
avgAngleQTDStar=zeros(numIterations,1);
timeQTDStar=zeros(numIterations,1);
%%
%Prepare Map
mapsize=51.2;
res=10;    %resolution cells/meter
minRes=2;
minResFrame=2;

if ~randomMap
    map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
    map=occupancyMap(map_binary,res);
    sv.Map = map;
    sv.ValidationDistance = 0.1;
    ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];
    %create RRTStarPlanner
    RRTStar=plannerRRTStar(ss,sv);
    RRTStar.ContinueAfterGoalReached=false;
end
%%
%simulate Planning
for k=1:numIterations
    disp(['Iteration ',num2str(k),' von ',num2str(numIterations),'.'])
    %%
    %Prepare map
    if randomMap
        goal=[0.8+(mapsize-1.6)*rand(1,2) 0]; %start and goal are located within ther frame of the map
        start=[0.8+(mapsize-1.6)*rand(1,2) 0];
        map_binary=mapCreator(mapsize,start,goal,res);
        map=occupancyMap(map_binary,res);
        sv.Map = map;
        sv.ValidationDistance = 0.1;
        ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];
%         figure
%         map.show
%         hold on
        %create RRTStarPlanner
        RRTStar=plannerRRTStar(ss,sv);
        RRTStar.ContinueAfterGoalReached=false;
    else
        %Prepare Start and Goal
        goalValid=false;
        startValid=false;
        while ~goalValid
            goal=[0.8+(mapsize-1.6)*rand(1,2) 0];
            goalValid=stateValidatorBinary(goal,map_binary,res);
        end
        
        while ~startValid
            start=[0.8+(mapsize-1.6)*rand(1,2) 0];
            startValid=stateValidatorBinary(start,map_binary,res);
            
        end
        % figure
        %hold on
        %map.show
    end
    
    
    %%
    %Plan path FQT+D*Lite
    if k>1 && ~randomMap
        
        cd 'FQT und DStarLite'
        tic
        pathFQT=DStarLiteMain(nodesFQT,start,goal,map_binary,res,0.1);
        timeFQT(k)=toc;
    else
        
        cd 'FQT und DStarLite'
        tic
        states=getstatesfrommap(map);
        [nodesFQT] = createFramedQuadtree(states,map_binary,minRes,minResFrame);
        pathFQT=DStarLiteMain(nodesFQT,start,goal,map_binary,res,0.1);
        timeFQT(k)=toc;
    end
    %%
    %Plan path QT+A*
    if k>1 && ~randomMap
       
        cd ..\.
        cd 'QT und AStar'
        tic
        pathQT=A_Star(nodesQT,start,goal,map_binary,res,0.1);
        timeQT(k)=toc;
    else
        
        cd ..\.
        cd 'QT und AStar'
        tic
        states=getstatesfrommap(map);
        
        [nodesQT] = createQuadtree(states,map_binary,minRes);
        
        pathQT=A_Star(nodesQT,start,goal,map_binary,res,0.1);
        timeQT(k)=toc;
    end
    %%
    %Plan path QT+D*Lite
    if k>1 && ~randomMap
        cd ..\.
        cd 'QT und DStarLite'
        tic
        pathQTDStar=DStarLiteMain(nodesQTDStar,start,goal,map_binary,res,0.1);
        timeQTDStar(k)=toc;
    else
        
        cd ..\.
        cd 'QT und DStarLite'
        tic
        states=getstatesfrommap(map);
        
        [nodesQTDStar] = createQuadtree(states,map_binary,minRes);
        
        pathQTDStar=DStarLiteMain(nodesQTDStar,start,goal,map_binary,res,0.1);
        timeQTDStar(k)=toc;
    end
    %%
    %Plan path RRTX
    cd ..\.
    cd 'RRTX'
    iterations=1500;
    maxConnectionDistance=15;
    validationDistance=0.1;
    tic
    [pathRRTX,nodes,~,~,~,~] = RRTXMain(map_binary,start(1:2),goal(1:2),maxConnectionDistance,res,validationDistance,iterations);
    timeRRTX(k)=toc;
    %%
    %Plan path with RRTStar
    RRTStar.MaxConnectionDistance=15;
    RRTStar.MaxIterations=5000;
    tic
    [pathRRTStar, planningInfo] = plan(RRTStar,start,goal);
    timeRRTStar(k)=toc;
    pathRRTStar=[pathRRTStar.States];
    
    if ~planningInfo.IsPathFound
        pathRRTStar=[];
    end
    
    %%
    %Evaluate paths
    cd ..\.
    
    if isempty(pathQT)
        lengthQT(k)=NaN;
        avgAngleQT(k)=NaN;
    else
        [lengthQT(k),avgAngleQT(k)] = evaluatePath(pathQT);
        % plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathQTDStar)
        lengthQTDStar(k)=NaN;
        avgAngleQTDStar(k)=NaN;
    else
        [lengthQTDStar(k),avgAngleQTDStar(k)] = evaluatePath(pathQTDStar);
        % plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathFQT)
        lengthFQT(k)=NaN;
        avgAngleFQT(k)=NaN;
    else
        [lengthFQT(k),avgAngleFQT(k)] = evaluatePath(pathFQT);
        % plot(pathFQT(:,1),pathFQT(:,2),'-gx','LineWidth',1)
    end
    
    if isempty(pathRRTX)
        lengthRRTX(k)=NaN;
        avgAngleRRTX(k)=NaN;
    else
        %add a third column to the path (necessary for evaluatePath function)
        pathRRTX(:,3)=0;
        [lengthRRTX(k),avgAngleRRTX(k)] = evaluatePath(pathRRTX);
        %plot(pathRRTX(:,1),pathRRTX(:,2),'-bx','LineWidth',1)
        
    end
    
    if isempty(pathRRTStar)
        lengthRRTStar(k)=NaN;
        avgAngleRRTStar(k)=NaN;
    else
        [lengthRRTStar(k),avgAngleRRTStar(k)] = evaluatePath(pathRRTStar);
        %plot(pathRRTStar(:,1),pathRRTStar(:,2),'-yx','LineWidth',1)
    end
    
    
end

%% evaluate paths
%process path values and compare them. QT is the base for the comparison

%evaluate the events where all algorithms were successful ->only the
%average of these is representive
index=~isnan(lengthQT(:,1))&~isnan(lengthFQT(:,1))&~isnan(lengthRRTX(:,1))&~isnan(lengthRRTStar(:,1))&~isnan(lengthQTDStar(:,1));
numAllSuccessful=sum(index);

evaluation=cell(4,6);
evaluation{1,1}='property/algorithm';
evaluation{2,1}='length';
evaluation{3,1}='time';
evaluation{4,1}='average angle';
evaluation{1,2}='QT und A*';
evaluation{1,3}='FQT und D* Lite';
evaluation{1,4}='RRTX';
evaluation{1,5}='RRT*';
evaluation{1,6}='QT und D* Lite';

evaluationAbs=evaluation;

%average angle
evaluationAbs{4,2}=sum(avgAngleQT(index,1))/numAllSuccessful;
[evaluation{4,2}] = (sum(avgAngleQT(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

[evaluation{4,3}] = (sum(avgAngleFQT(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;
evaluationAbs{4,3}=sum(avgAngleFQT(index,1))/numAllSuccessful;

evaluationAbs{4,4}=sum(avgAngleRRTX(index,1))/numAllSuccessful;
[evaluation{4,4}] = (sum(avgAngleRRTX(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

[evaluation{4,5}] = (sum(avgAngleRRTStar(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;
evaluationAbs{4,5}=sum(avgAngleRRTStar(index,1))/numAllSuccessful;

evaluationAbs{4,6}=sum(avgAngleQTDStar(index,1))/numAllSuccessful;
[evaluation{4,6}] = (sum(avgAngleQTDStar(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

%length
[evaluation{2,2}] = (sum(lengthQT(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,2}=sum(lengthQT(index,1))/numAllSuccessful;

[evaluation{2,3}] = (sum(lengthFQT(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,3}=sum(lengthFQT(index,1))/numAllSuccessful;

[evaluation{2,4}] = (sum(lengthRRTX(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,4}=sum(lengthRRTX(index,1))/numAllSuccessful;

[evaluation{2,5}] = (sum(lengthRRTStar(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,5}=sum(lengthRRTStar(index,1))/numAllSuccessful;

[evaluation{2,6}] =(sum(lengthQTDStar(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,6}=sum(lengthQTDStar(index,1))/numAllSuccessful;

%time
[evaluation{3,2}] = (sum(timeQT(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,2}=sum(timeQT(index,1))/numAllSuccessful;

[evaluation{3,3}] = (sum(timeFQT(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,3}=sum(timeFQT(index,1))/numAllSuccessful;

[evaluation{3,4}] = (sum(timeRRTX(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,4}=sum(timeRRTX(index,1))/numAllSuccessful;

[evaluation{3,5}] = (sum(timeRRTStar(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,5}=sum(timeRRTStar(index,1))/numAllSuccessful;

[evaluation{3,6}] = (sum(timeQTDStar(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,6}=sum(timeQTDStar(index,1))/numAllSuccessful;


cd 'Ergebnisse'
save(['StaticComparison_Iterations_',num2str(numIterations),'_',date,'_randomMap',num2str(randomMap),'_mapsize',num2str(floor(mapsize))])