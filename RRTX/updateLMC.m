function nodes=updateLMC(v,nodes,r,orphanNodes)

[nodes] = cullNeighbours(v,r,nodes);
p=nodes.values(v,3);
cost=nodes.values(v,4);
for k=1:size(nodes.neighboursOutRunning{v,1},2)
    u=nodes.neighboursOutRunning{v,1}(1,k);
    if any(orphanNodes==u) && any(nodes.values(u,3)==v)
        continue
    end
    
    
    if nodes.values(v,2)>nodes.neighboursOutRunning{v,2}(1,k)+nodes.values(u,2)
        nodes.values(v,2)=nodes.neighboursOutRunning{v,2}(1,k)+nodes.values(u,2);
        p=u;
        cost=nodes.neighboursOutRunning{v,2}(1,k);
    end
    
end

for k=1:size(nodes.neighboursOutInitial{v,1},2)
    u=nodes.neighboursOutInitial{v,1}(1,k);
    if any(orphanNodes==u) && any(nodes.values(u,3)==v)
        continue
    end
    if nodes.values(v,2)>nodes.neighboursOutInitial{v,2}(1,k)+nodes.values(u,2)
        nodes.values(v,2)=nodes.neighboursOutInitial{v,2}(1,k)+nodes.values(u,2);
        p=u;
        cost=nodes.neighboursOutInitial{v,2}(1,k);
    end
end

%remove v from the child set of its old parent
if ~isnan(nodes.values(v,3))
[nodes.childs{nodes.values(v,3),1},nodes.childs{nodes.values(v,3),2}] = removeChild(nodes.childs{nodes.values(v,3),1},nodes.childs{nodes.values(v,3),2},v);
end
if isnan(p)
    return
end
%add v to the child set of p
nodes.childs{p,1}(1,end+1)=v;
nodes.childs{p,2}(1,end+1)=cost;
%store p as new parent of v
nodes.values(v,3)=p;
nodes.values(v,4)=cost;
end

