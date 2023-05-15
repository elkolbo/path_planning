function [orphanNodes,nodes,openList] = propagateDescendants(orphanNodes,nodes,openList)
%Pass on the informatin about the dissconnected nodes

currentGeneration=orphanNodes;
while size(currentGeneration,1)>0
    nextGeneration=[];
    for k=1:size(currentGeneration,1)
        orphanNodes=[orphanNodes;nodes.childs{currentGeneration(k,1),1}'];
        nextGeneration=[nextGeneration;nodes.childs{currentGeneration(k,1),1}'];
    end
    currentGeneration=nextGeneration;
end


for k=1:size(orphanNodes,1)
    v=orphanNodes(k,1);
    
    %out running neighbours
    for s=1:size(nodes.neighboursOutRunning{v,1},2)
        u=nodes.neighboursOutRunning{v,1}(1,s);
        if any(orphanNodes==u)
            continue
        end
        nodes.values(u,1)=Inf;
        openList=verifyQueue(u,openList,nodes);
    end
    
    %initial out neighbours
    for s=1:size(nodes.neighboursOutInitial{v,1},2)
        u=nodes.neighboursOutInitial{v,1}(1,s);
        if any(orphanNodes==u)
            continue
        end
        nodes.values(u,1)=Inf;
        openList=verifyQueue(u,openList,nodes);
    end
    
    %parent
    u=nodes.values(v,3);
    if ~any(orphanNodes==u)
        nodes.values(u,1)=Inf;
        openList=verifyQueue(u,openList,nodes);
    end
end

for k=1:size(orphanNodes,1)
    v=orphanNodes(1,1);
    orphanNodes=orphanNodes(2:end,:);
    
    nodes.values(v,1)=Inf;
    nodes.values(v,2)=Inf;
    
    if ~isnan(nodes.values(v,3))
        index=nodes.childs{nodes.values(v,3),1}==v;
        nodes.childs{nodes.values(v,3),1}(index)=[];
        nodes.childs{nodes.values(v,3),2}(index)=[];
        nodes.values(v,3)=NaN;
    end
end

