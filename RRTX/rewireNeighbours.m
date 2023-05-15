function [nodes,openList] = rewireNeighbours(vAdress,nodes,epsilon,r,openList)
%Rewire neighbours to create better paths from goal to start
%   Detailed explanation goes here

if nodes.values(vAdress,1)-nodes.values(vAdress,2)>epsilon
    nodes=cullNeighbours(vAdress,r,nodes);
    for k=1:size(nodes.neighboursInRunning{vAdress,1},2)
        u=nodes.neighboursInRunning{vAdress,1}(1,k);
        if u==nodes.values(vAdress,3)
            continue
        end
        if nodes.values(u,2)>nodes.neighboursInRunning{vAdress,2}(1,k)+nodes.values(vAdress,2)
            nodes.values(u,2)=nodes.neighboursInRunning{vAdress,2}(1,k)+nodes.values(vAdress,2);
            if ~isnan(nodes.values(u,3))
            %remove u from the child set of its old parent
            [nodes.childs{nodes.values(u,3),1},nodes.childs{nodes.values(u,3),2}] = removeChild(nodes.childs{nodes.values(u,3),1},nodes.childs{nodes.values(u,3),2},u);
            end
            %add u to the child set of v
            nodes.childs{vAdress,1}(1,end+1)=u;
            nodes.childs{vAdress,2}(1,end+1)=nodes.neighboursInRunning{vAdress,2}(1,k);
            %store v as new parent of u
            nodes.values(u,3)=vAdress;
            nodes.values(u,4)=nodes.neighboursInRunning{vAdress,2}(1,k);
            if nodes.values(u,1)-nodes.values(u,2)> epsilon
                 openList=verifyQueue(u,openList,nodes);
            end
        end
    end
    
    
    for k=1:size(nodes.neighboursInInitial{vAdress,1},2)
        u=nodes.neighboursInInitial{vAdress,1}(1,k);
        if u==nodes.values(vAdress,3)
            continue
        end
        if nodes.values(u,2)>nodes.neighboursInInitial{vAdress,2}(1,k)+nodes.values(vAdress,2)
            nodes.values(u,2)=nodes.neighboursInInitial{vAdress,2}(1,k)+nodes.values(vAdress,2);
            %remove u from the child set of its old parent
            if ~isnan(nodes.values(u,3))
            [nodes.childs{nodes.values(u,3),1},nodes.childs{nodes.values(u,3),2}] = removeChild(nodes.childs{nodes.values(u,3),1},nodes.childs{nodes.values(u,3),2},u);
            end
            %add u to the child set of v
            nodes.childs{vAdress,1}(1,end+1)=u;
            nodes.childs{vAdress,2}(1,end+1)=nodes.neighboursInInitial{vAdress,2}(1,k);
            %store v as new parent of u
            nodes.values(u,3)=vAdress;
            nodes.values(u,4)=nodes.neighboursInInitial{vAdress,2}(1,k);
            if nodes.values(u,1)-nodes.values(u,2)>epsilon
                openList=verifyQueue(u,openList,nodes);
            end
        end
    end
end

end

