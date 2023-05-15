function [nodes,openList,orphanNodes] = addNewObstacle(changedNodes,nodes,openList,orphanNodes)
%Handle the changes in state space and change the edge costs of blocked
%edges to infinity.

for k=1:size(changedNodes,2)
    v=changedNodes(1,k);
    %update edge cost for node
    nodes.neighboursOutInitial{v,2}=nodes.neighboursOutInitial{v,2}*Inf;
    nodes.neighboursInRunning{v,2}=nodes.neighboursInRunning{v,2}*Inf;
    nodes.neighboursOutRunning{v,2}=nodes.neighboursOutRunning{v,2}*Inf;
    nodes.neighboursInInitial{v,2}=nodes.neighboursInInitial{v,2}*Inf;
    
    %update edge cost from the view of the neighbour
    
    for s=1:size(nodes.neighboursOutInitial{v,1},2)
        u=nodes.neighboursOutInitial{v,1}(1,s);
        
       [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,v,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
    
       %check if nodes are parents of each other
       if nodes.values(v,3)==u
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,v);
           nodes.values(v,4)=Inf;
       end
       
       if nodes.values(u,3)==v
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
           nodes.values(u,4)=Inf;
       end
    end 
       
    
    
    %update edge cost from the view of the neighbour
    
    for s=1:size(nodes.neighboursOutRunning{v,1},2)
        u=nodes.neighboursOutRunning{v,1}(1,s);
        
     [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,v,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
    
       %check if nodes are parents of each other
       if nodes.values(v,3)==u
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,v);
           nodes.values(v,4)=Inf;
       end
       
       if nodes.values(u,3)==v
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
           nodes.values(u,4)=Inf;
       end
    end 
    
    
    
    %update edge cost from the view of the neighbour
    for s=1:size(nodes.neighboursInInitial{v,1},2)
        u=nodes.neighboursInInitial{v,1}(1,s);
        
       [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,v,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
    
       %check if nodes are parents of each other
       if nodes.values(v,3)==u
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,v);
           nodes.values(v,4)=Inf;
       end
       
       if nodes.values(u,3)==v
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
           nodes.values(u,4)=Inf;
       end
    end 
    
    
    
    %update edge cost from the view of the neighbour
    
    for s=1:size(nodes.neighboursInRunning{v,1},2)
        u=nodes.neighboursInRunning{v,1}(1,s);
        
       [nodes.neighboursOutInitial{u,2},nodes.neighboursInRunning{u,2},nodes.neighboursOutRunning{u,2},nodes.neighboursInInitial{u,2}]=changeCostAtNeighbour(u,v,{nodes.neighboursOutInitial{u,:}},{nodes.neighboursInRunning{u,:}},{nodes.neighboursOutRunning{u,:}},{nodes.neighboursInInitial{u,:}});
    
       %check if nodes are parents of each other
       if nodes.values(v,3)==u
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,v);
           nodes.values(v,4)=Inf;
       end
       
       if nodes.values(u,3)==v
           [openList,orphanNodes]=verifyOrphan(openList,orphanNodes,u);
           nodes.values(u,4)=Inf;
       end
    end 
    
    
end




end

