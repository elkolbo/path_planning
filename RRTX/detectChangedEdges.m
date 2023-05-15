function [nodes,orphanNodes,openList] = detectChangedEdges(nodes,mapBinary,mapRes,validationDistance,openList,orphanNodes)

for k=1:size(nodes.values,1)
    for s=1:size(nodes.neighboursOutRunning{k,1},2)
        u=nodes.neighboursOutRunning{k,1}(1,s);
        valid=motionValidatorBinary(nodes.states(k,:),nodes.states(u,:),mapBinary,mapRes,validationDistance);
        
        if ~valid
            nodes.neighboursOutRunning{k,2}(1,s)=Inf;
            %change cost at neighbour
            [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,k,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
            if nodes.values(k,3)==u
                [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,k);
            end
            if nodes.values(u,3)==k
                [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
            end
        end
    end
    
    for s=1:size(nodes.neighboursOutInitial{k,1},2)
        u=nodes.neighboursOutInitial{k,1}(1,s);
        valid=motionValidatorBinary(nodes.states(k,:),nodes.states(u,:),mapBinary,mapRes,validationDistance);
        
        if ~valid
            nodes.neighboursOutInitial{k,2}(1,s)=Inf;
            %change cost at neighbour
            [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,k,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
            if nodes.values(k,3)==u
                [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,k);
            end
            if nodes.values(u,3)==k
                [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
            end
        end
    end
end



end




