function [path,nodes,openList,vBot,epsilon,r] = RRTXMain(mapBinary,start,goal,maxConnectionDistance,res,validationDistance,iterations)
%UNTITLED2 Summary of this function goes here
%   %nodes.values contains g,lmc,parent
nodes.states=[goal;start];
nodes.values=[0,0,NaN;Inf,Inf,NaN];
nodes.childs=cell(2,2);

nodes.neighboursOutInitial=cell(2,2);
nodes.neighboursInRunning=cell(2,2);
nodes.neighboursOutRunning=cell(2,2);
nodes.neighboursInInitial=cell(2,2);
vBot=2;
openList=[];
epsilon=0.1;

[xLim,yLim]=size(mapBinary);
xLim=xLim/res;
yLim=yLim/res;
minNodeDistance=10e-10;
gamma=calculateGamma(mapBinary,res);
for s=1:iterations
    
    numNodes=size(nodes.states,1);
    
    r =  min( ((gamma/pi)*(log(numNodes)/numNodes))^(1/2), maxConnectionDistance);
    
    v=[rand*xLim, rand*yLim];
    
    
    [nearestDistance, nearestAdress]=min(sqrt(((nodes.states(:,1)-v(1)).^2)+((nodes.states(:,2)-v(2)).^2)));
    
    if nearestDistance<minNodeDistance
        continue
    elseif nearestDistance>maxConnectionDistance
        v=saturate(v,nodes.states(nearestAdress,:),maxConnectionDistance);
    end
    
    
    if stateValidatorBinary(v,mapBinary,res)
        [nodes,vAdress] = extend(v,r,nodes,mapBinary,res,validationDistance);
    else
        vAdress=[];
    end
    
    if ~isempty(vAdress)
        [nodes,openList] = rewireNeighbours(vAdress,nodes,epsilon,r,openList);
        [openList,nodes] = reduceInconsistency(openList,nodes,vBot,epsilon,r,[]);
    end
    
    
end
if isnan(nodes.values(2,3)) %check if start got connected to the tree
    path=[];
else
    path=calculatePath(nodes.values,nodes.states,vBot);
end
end

