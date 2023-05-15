%%
%Prepare Planning
ss = stateSpaceSE2;
clear nodes
sv = validatorOccupancyMap(ss);
load exampleMaps.mat


%%
%prepare simulation
numIterations=input('Wie viele Iterationen sollen durchgeführt werden?');
randomMap=input('Soll bei jeder Iteration eine neue Karte erstellt werden? (Ja=1/Nein=0)');

lengthFQTDStar=nan(numIterations,2);
avgAngleFQTDStar=nan(numIterations,2);
timeFQTDStar=nan(numIterations,2);

lengthQT=nan(numIterations,2);
avgAngleQT=nan(numIterations,2);
timeQT=nan(numIterations,2);
timeRRTX=nan(numIterations,2);
lengthRRTX=nan(numIterations,2);
avgAngleRRTX=nan(numIterations,2);

timeRRTStar=nan(numIterations,2);
lengthRRTStar=nan(numIterations,2);
avgAngleRRTStar=nan(numIterations,2);

lengthQTDStar=nan(numIterations,2);
avgAngleQTDStar=nan(numIterations,2);
timeQTDStar=nan(numIterations,2);
%%
%Prepare Map
mapsize=25.6;
res=10;    %resolution cells/meter
minRes=2;
minResFrame=2;

if ~randomMap
    map_binary=logical(imresize([complexMap; flipud(complexMap(end-11:end,:))],[256,256],'nearest'));
    map_binaryInitial=map_binary;
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
        goal=[mapsize-6.8+(6)*rand(1) 0.8+(mapsize-1.6)*rand(1) 0]; %start and goal are located within the frame of the map;start is on the left side and goal on the right side
        start=[0.8+6*rand(1) 0.8+(mapsize-1.6)*rand(1) 0];
        map_binary=mapCreator(mapsize,start,goal,res);
        map=occupancyMap(map_binary,res);
        map_binaryInitial=map_binary;
        sv.Map = map;
        sv.ValidationDistance = 0.1;
        ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];
        %figure
        %map.show
        %hold on
        %create RRTStarPlanner
        RRTStar=plannerRRTStar(ss,sv);
        RRTStar.ContinueAfterGoalReached=false;
    else
        map_binary=map_binaryInitial;
        map=occupancyMap(map_binary,res);
        sv.Map = map;
        %Prepare Start and Goal
        goalValid=false;
        startValid=false;
        while ~goalValid
            goal=[mapsize-6.8+(6)*rand(1) 0.8+(mapsize-1.6)*rand(1) 0]; %start and goal are located within the frame of the map;start is on the left side and goal on the right side
            goalValid=stateValidatorBinary(goal,map_binary,res);
        end
        
        while ~startValid
            start=[0.8+6*rand(1) 0.8+(mapsize-1.6)*rand(1) 0];
            startValid=stateValidatorBinary(start,map_binary,res);
        end
        % figure
        hold on
        %map.show
    end
    
    
    %%
    %     %Plan path FQT+A*
    %     if k>1 && ~randomMap
    %         tic
    %         cd 'FQT und A_Star'
    %         pathFQT=A_Star(nodesFQT,start,goal,map_binary,res,0.1);
    %         timeFQT(k,1)=toc;
    %     else
    %         tic
    %         cd 'FQT und A_Star'
    %         states=getstatesfrommap(map);
    %        [nodesFQT] = createFramedQuadtree(states,map_binary,minRes,minResFrame);
    %         pathFQT=A_Star(nodesFQT,start,goal,map_binary,res,0.1);
    %         timeFQT(k,1)=toc;
    %     end
    %%
    %Plan path QT+A*
    
    cd 'QT und AStar'
    tic
    states=getstatesfrommap(map);
    
    [nodesQT] = createQuadtree(states,map_binary,minRes);
    
    pathQT=A_Star(nodesQT,start,goal,map_binary,res,0.1);
    timeQT(k,1)=toc;
    
    %%
    %Plan path QT+D*Lite
    cd ..\.
    cd 'QT und DStarLite'
    tic
    states=getstatesfrommap(map);
    
    [nodesQTDStar] = createQuadtree(states,map_binary,minRes);
    
    [pathQTDStar,nodesQTDStar,startAdressQTDStar,goalAdressQTDStar,successorsQTDStar,allNodesQTDStar,openListQTDStar]=DStarLiteMain(nodesQTDStar,start,goal,map_binary,res,validationDistance);
    timeQTDStar(k,1)=toc;
    
    
    %%
    %Plan path FQT+D*Lite
    
    
    cd ..\.
    cd 'FQT und DStarLite'
    tic
    states=getstatesfrommap(map);
    
    [nodesFQTDStar] = createFramedQuadtree(states,map_binary,minRes,minResFrame);
    
    [pathFQTDStar,nodesFQTDStar,startAdressFQTDStar,goalAdressFQTDStar,successorsFQTDStar,allNodesFQTDStar,openListFQTDStar]=DStarLiteMain(nodesFQTDStar,start,goal,map_binary,res,validationDistance);
    timeFQTDStar(k,1)=toc;
    
    %%
    %Plan path RRTX
    cd ..\.
    cd 'RRTX'
    iterations=1500;
    maxConnectionDistance=15;
    validationDistance=0.1;
    tic
    [pathRRTX,nodesRRTX,openListRRTX,vBotRRTX,epsilonRRTX,rRRTX] = RRTXMain(map_binary,start(1:2),goal(1:2),maxConnectionDistance,res,validationDistance,iterations);
    timeRRTX(k,1)=toc;
    
    %%
    %Plan path with RRTStar
    RRTStar.MaxConnectionDistance=15;
    RRTStar.MaxIterations=5000;
    tic
    [pathRRTStar, planningInfo] = plan(RRTStar,start,goal);
    timeRRTStar(k,1)=toc;
    pathRRTStar=[pathRRTStar.States];
    
    if ~planningInfo.IsPathFound
        pathRRTStar=[];
    end
    
    %%
    %Evaluate paths
    cd ..\.
    
    if isempty(pathQT)
        lengthQT(k,1)=NaN;
        avgAngleQT(k,1)=NaN;
    else
        [lengthQT(k,1),avgAngleQT(k,1)] = evaluatePath(pathQT);
        % plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathQTDStar)
        lengthQTDStar(k,1)=NaN;
        avgAngleQTDStar(k,1)=NaN;
    else
        [lengthQTDStar(k,1),avgAngleQTDStar(k,1)] = evaluatePath(pathQTDStar);
        % plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathFQTDStar)
        lengthFQTDStar(k,1)=NaN;
        avgAngleFQTDStar(k,1)=NaN;
    else
        [lengthFQTDStar(k,1),avgAngleFQTDStar(k,1)] = evaluatePath(pathFQTDStar);
        % plot(pathFQT(:,1),pathFQT(:,2),'-gx','LineWidth',1)
    end
    
    if isempty(pathRRTX)
        lengthRRTX(k,1)=NaN;
        avgAngleRRTX(k,1)=NaN;
    else
        %add a third column to the path (necessary for evaluatePath function)
        pathRRTX(:,3)=0;
        [lengthRRTX(k,1),avgAngleRRTX(k,1)] = evaluatePath(pathRRTX);
        %plot(pathRRTX(:,1),pathRRTX(:,2),'-bx','LineWidth',1)
    end
    
    if isempty(pathRRTStar)
        lengthRRTStar(k,1)=NaN;
        avgAngleRRTStar(k,1)=NaN;
    else
        [lengthRRTStar(k,1),avgAngleRRTStar(k,1)] = evaluatePath(pathRRTStar);
        %plot(pathRRTStar(:,1),pathRRTStar(:,2),'-yx','LineWidth',1)
    end
    
    %%
    %Add an obstacle in the middle of the path
    %check, if planning was successful with all algorithms
    if ~isempty(pathQT)&&~isempty(pathFQTDStar)&&~isempty(pathRRTX)&&~isempty(pathRRTStar)&&~isempty(pathQTDStar)
        %add a blockage in the middle of the path
        blockingPoint=pathQT(floor(size(pathQT,1)/2),:);
        map_binary(abs(ceil(mapsize*res-abs(blockingPoint(2)*res-20:blockingPoint(2)*res+20)))+1,abs(floor(abs(blockingPoint(1)*res-3:blockingPoint(1)*res+3)))+1) = 1;
        map=occupancyMap(map_binary,res);
        %                 figure
        %                 hold on
        %                 map.show
    else
        continue
    end
    %%
    %Replan path QT+A*
    cd 'QT und AStar'
    tic
    states=getstatesfrommap(map);
    
    [nodesQT] = createQuadtree(states,map_binary,minRes);
    
    pathQT=A_Star(nodesQT,start,goal,map_binary,res,0.1);
    timeQT(k,2)=toc;
    
    %%
    %Replan path QT+D*Lite
    cd ..\.
    cd 'QT und DStarLite'
    map_binary=map_binaryInitial;
    blockingPoint=pathQTDStar(floor(size(pathQTDStar,1)/2),:);
    map_binary(abs(ceil(mapsize*res-abs(blockingPoint(2)*res-20:blockingPoint(2)*res+20)))+1,abs(floor(abs(blockingPoint(1)*res-3:blockingPoint(1)*res+3)))+1) = 1;
    map=occupancyMap(map_binary,res);
    tic
    [changedEdgesQTDStar] = detectChangedEdgesDStar(nodesQTDStar,map_binary,res,validationDistance);
    pathQTDStar=DStarLiteMainReplanning(nodesQTDStar,startAdressQTDStar,goalAdressQTDStar,changedEdgesQTDStar,0,successorsQTDStar,allNodesQTDStar,openListQTDStar);
    timeQTDStar(k,2)=toc;
    
    %%
    %Replan path FQT+D*Lite
    
    cd ..\.
    cd 'FQT und DStarLite'
    map_binary=map_binaryInitial;
    blockingPoint=pathFQTDStar(floor(size(pathFQTDStar,1)/2),:);
    map_binary(abs(ceil(mapsize*res-abs(blockingPoint(2)*res-20:blockingPoint(2)*res+20)))+1,abs(floor(abs(blockingPoint(1)*res-3:blockingPoint(1)*res+3)))+1) = 1;
    map=occupancyMap(map_binary,res);
    tic
    [changedEdgesFQTDStar] = detectChangedEdgesDStar(nodesFQTDStar,map_binary,res,validationDistance);
    pathFQTDStar=DStarLiteMainReplanning(nodesFQTDStar,startAdressFQTDStar,goalAdressFQTDStar,changedEdgesFQTDStar,0,successorsFQTDStar,allNodesFQTDStar,openListFQTDStar);
    timeFQTDStar(k,2)=toc;
    
    %%
    %replan path RRTX
    cd ..\.
    cd 'RRTX'
    map_binary=map_binaryInitial;
    blockingPoint=pathRRTX(floor(size(pathRRTX,1)/2),:);
    map_binary(abs(ceil(mapsize*res-abs(blockingPoint(2)*res-20:blockingPoint(2)*res+20)))+1,abs(floor(abs(blockingPoint(1)*res-3:blockingPoint(1)*res+3)))+1) = 1;
    map=occupancyMap(map_binary,res);
    iterations=1500;
    maxConnectionDistance=15;
    validationDistance=0.1;
    tic
    [pathRRTX,~,~] = RRTXReplanning(vBotRRTX,nodesRRTX,openListRRTX,epsilonRRTX,rRRTX,map_binary,res,validationDistance);
    timeRRTX(k,2)=toc;
    
    %%
    %Replan path with RRTStar
    RRTStar.MaxConnectionDistance=15;
    RRTStar.MaxIterations=5000;
    map_binary=map_binaryInitial;
    blockingPoint=pathRRTStar(floor(size(pathRRTStar,1)/2),:);
    map_binary(abs(ceil(mapsize*res-abs(blockingPoint(2)*res-20:blockingPoint(2)*res+20)))+1,abs(floor(abs(blockingPoint(1)*res-3:blockingPoint(1)*res+3)))+1) = 1;
    map=occupancyMap(map_binary,res);
    tic
    [pathRRTStar, planningInfo] = plan(RRTStar,start,goal);
    timeRRTStar(k,2)=toc;
    pathRRTStar=[pathRRTStar.States];
    
    if ~planningInfo.IsPathFound
        pathRRTStar=[];
    end
    
    %%
    %Evaluate paths
    cd ..\.
    
    if isempty(pathQT)
        lengthQT(k,2)=NaN;
        avgAngleQT(k,2)=NaN;
    else
        [lengthQT(k,2),avgAngleQT(k,2)] = evaluatePath(pathQT);
        %plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathQTDStar)
        lengthQTDStar(k,2)=NaN;
        avgAngleQTDStar(k,2)=NaN;
    else
        [lengthQTDStar(k,2),avgAngleQTDStar(k,2)] = evaluatePath(pathQTDStar);
        % plot(pathQT(:,1),pathQT(:,2),'-rx','LineWidth',1)
    end
    
    if isempty(pathFQTDStar)
        lengthFQTDStar(k,2)=NaN;
        avgAngleFQTDStar(k,2)=NaN;
    else
        [lengthFQTDStar(k,2),avgAngleFQTDStar(k,2)] = evaluatePath(pathFQTDStar);
        % plot(pathFQTDStar(:,1),pathFQTDStar(:,2),'-gx','LineWidth',1)
    end
    
    if isempty(pathRRTX)
        lengthRRTX(k,2)=NaN;
        avgAngleRRTX(k,2)=NaN;
    else
        %add a third column to the path (necessary for evaluatePath function)
        pathRRTX(:,3)=0;
        [lengthRRTX(k,2),avgAngleRRTX(k,2)] = evaluatePath(pathRRTX);
        %plot(pathRRTX(:,1),pathRRTX(:,2),'-bx','LineWidth',1)
    end
    
    if isempty(pathRRTStar)
        lengthRRTStar(k,2)=NaN;
        avgAngleRRTStar(k,2)=NaN;
    else
        [lengthRRTStar(k,2),avgAngleRRTStar(k,2)] = evaluatePath(pathRRTStar);
        %plot(pathRRTStar(:,1),pathRRTStar(:,2),'-yx','LineWidth',1)
    end
    
    
end

%%
%display paths
% figure
% subplot(2,2,1)
% hold on
% grid on
% title('Pfadlänge')
% plot(lengthFQT,'-rx')
% plot(lengthQT,'-gx')
% plot(lengthRRTX,'-bx')
% plot(lengthRRTStar,'-yx')
% legend('FQT','QT','RRTX','RRT*')
%
% subplot(2,2,2)
% hold on
% grid on
% title('Rechenzeit [s]')
% plot(timeFQT,'-rx')
% plot(timeQT,'-gx')
% plot(timeRRTX,'-bx')
% plot(timeRRTStar,'-yx')
% legend('FQT','QT','RRTX','RRT*')
%
% subplot(2,2,3)
% hold on
% grid on
% title('Minimaler Abstand zu Hindernissen')
% plot(minClearanceFQT,'-rx')
% plot(minClearanceQT,'-gx')
% plot(minClearanceRRTX,'-bx')
% plot(minClearanceRRTStar,'-yx')
% legend('FQT','QT','RRTX','RRT*')
%
% subplot(2,2,4)
% hold on
% grid on
% title('Durchschnittlicher Winkel zwischen Pfadsegmenten [°]')
% plot(avgAngleFQT,'-rx')
% plot(avgAngleQT,'-gx')
% plot(avgAngleRRTX,'-bx')
% plot(avgAngleRRTStar,'-yx')
% legend('FQT','QT','RRTX','RRT*')

%%
%process path values and compare them. QT is the base for the comparison

%evaluate the events where all algorithms were successful ->only the
%average of these is representive
index=~isnan(lengthQT(:,1))&~isnan(lengthFQTDStar(:,1))&~isnan(lengthRRTX(:,1))&~isnan(lengthRRTStar(:,1))&~isnan(lengthQTDStar(:,1));
numAllSuccessful=sum(index);

evaluation=cell(4,6);
evaluation{1,1}='property/algorithm';
evaluation{2,1}='length';
evaluation{3,1}='time';
evaluation{4,1}='average angle';
evaluation{1,2}='QT und A*';
evaluation{1,3}='FQT und D*Lite';
evaluation{1,4}='RRTX';
evaluation{1,5}='RRT*';
evaluation{1,6}='QT und D* Lite';

evaluationAbs=evaluation;
evaluationReplanning=evaluation;
evaluationReplanningAbs=evaluationReplanning;

%average angle
evaluationAbs{4,2}=sum(avgAngleQT(index,1))/numAllSuccessful;
[evaluation{4,2}] = (sum(avgAngleQT(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

[evaluation{4,3}] = (sum(avgAngleFQTDStar(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;
evaluationAbs{4,3}=sum(avgAngleFQTDStar(index,1))/numAllSuccessful;

evaluationAbs{4,4}=sum(avgAngleRRTX(index,1))/numAllSuccessful;
[evaluation{4,4}] = (sum(avgAngleRRTX(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

[evaluation{4,5}] = (sum(avgAngleRRTStar(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;
evaluationAbs{4,5}=sum(avgAngleRRTStar(index,1))/numAllSuccessful;

evaluationAbs{4,6}=sum(avgAngleQTDStar(index,1))/numAllSuccessful;
[evaluation{4,6}] = (sum(avgAngleQTDStar(index,1)./avgAngleQT(index,1))/numAllSuccessful)*100;

%length
[evaluation{2,2}] = (sum(lengthQT(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,2}=sum(lengthQT(index,1))/numAllSuccessful;

[evaluation{2,3}] = (sum(lengthFQTDStar(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,3}=sum(lengthFQTDStar(index,1))/numAllSuccessful;

[evaluation{2,4}] = (sum(lengthRRTX(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,4}=sum(lengthRRTX(index,1))/numAllSuccessful;

[evaluation{2,5}] = (sum(lengthRRTStar(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,5}=sum(lengthRRTStar(index,1))/numAllSuccessful;

[evaluation{2,6}] =(sum(lengthQTDStar(index,1)./lengthQT(index,1))/numAllSuccessful)*100;
evaluationAbs{2,6}=sum(lengthQTDStar(index,1))/numAllSuccessful;

%time
[evaluation{3,2}] = (sum(timeQT(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,2}=sum(timeQT(index,1))/numAllSuccessful;

[evaluation{3,3}] = (sum(timeFQTDStar(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,3}=sum(timeFQTDStar(index,1))/numAllSuccessful;

[evaluation{3,4}] = (sum(timeRRTX(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,4}=sum(timeRRTX(index,1))/numAllSuccessful;

[evaluation{3,5}] = (sum(timeRRTStar(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,5}=sum(timeRRTStar(index,1))/numAllSuccessful;

[evaluation{3,6}] = (sum(timeQTDStar(index,1)./timeQT(index,1))/numAllSuccessful)*100;
evaluationAbs{3,6}=sum(timeQTDStar(index,1))/numAllSuccessful;

%%
%Evaluation of the replanning
index=~isnan(lengthQT(:,2))&~isnan(lengthFQTDStar(:,2))&~isnan(lengthRRTX(:,2))&~isnan(lengthRRTStar(:,2))&~isnan(lengthQTDStar(:,2));
numAllSuccessful=sum(index);

%average angle
evaluationReplanningAbs{4,2}=sum(avgAngleQT(index,2))/numAllSuccessful;
[evaluationReplanning{4,2}] = (sum(avgAngleQT(index,2)./avgAngleQT(index,2))/numAllSuccessful)*100;

[evaluationReplanning{4,3}] = (sum(avgAngleFQTDStar(index,2)./avgAngleQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{4,3}=sum(avgAngleFQTDStar(index,2))/numAllSuccessful;

evaluationReplanningAbs{4,4}=sum(avgAngleRRTX(index,2))/numAllSuccessful;
[evaluationReplanning{4,4}] = (sum(avgAngleRRTX(index,2)./avgAngleQT(index,2))/numAllSuccessful)*100;

[evaluationReplanning{4,5}] = (sum(avgAngleRRTStar(index,2)./avgAngleQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{4,5}=sum(avgAngleRRTStar(index,2))/numAllSuccessful;

evaluationReplanningAbs{4,6}=sum(avgAngleQTDStar(index,2))/numAllSuccessful;
[evaluationReplanning{4,6}] = (sum(avgAngleQTDStar(index,2)./avgAngleQT(index,2))/numAllSuccessful)*100;

%length
[evaluationReplanning{2,2}] = (sum(lengthQT(index,2)./lengthQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{2,2}=sum(lengthQT(index,2))/numAllSuccessful;

[evaluationReplanning{2,3}] = (sum(lengthFQTDStar(index,2)./lengthQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{2,3}=sum(lengthFQTDStar(index,2))/numAllSuccessful;

[evaluationReplanning{2,4}] = (sum(lengthRRTX(index,2)./lengthQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{2,4}=sum(lengthRRTX(index,2))/numAllSuccessful;

[evaluationReplanning{2,5}] = (sum(lengthRRTStar(index,2)./lengthQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{2,5}=sum(lengthRRTStar(index,2))/numAllSuccessful;

[evaluationReplanning{2,6}] =(sum(lengthQTDStar(index,2)./lengthQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{2,6}=sum(lengthQTDStar(index,2))/numAllSuccessful;

%time
[evaluationReplanning{3,2}] = (sum(timeQT(index,2)./timeQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{3,2}=sum(timeQT(index,2))/numAllSuccessful;

[evaluationReplanning{3,3}] = (sum(timeFQTDStar(index,2)./timeQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{3,3}=sum(timeFQTDStar(index,2))/numAllSuccessful;

[evaluationReplanning{3,4}] = (sum(timeRRTX(index,2)./timeQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{3,4}=sum(timeRRTX(index,2))/numAllSuccessful;

[evaluationReplanning{3,5}] = (sum(timeRRTStar(index,2)./timeQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{3,5}=sum(timeRRTStar(index,2))/numAllSuccessful;

[evaluationReplanning{3,6}] = (sum(timeQTDStar(index,2)./timeQT(index,2))/numAllSuccessful)*100;
evaluationReplanningAbs{3,6}=sum(timeQTDStar(index,2))/numAllSuccessful;


%%
%save results
cd 'Ergebnisse'
save(['DynamicComparison_Iterations_',num2str(numIterations),'_',date,'randommap_',num2str(randomMap)])