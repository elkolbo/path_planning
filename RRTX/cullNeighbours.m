function [nodes] = cullNeighbours(v,r,nodes)
%Check if neighbours are within the new radius. If they are outside of it
%they get removed. If the neighbour is part of the child set it wont get
%removed

if size(nodes.neighboursOutRunning{v,1},2)==0%bugfix for the case, that the neighbour matrix is empty
    return
end

for k=size(nodes.neighboursOutRunning{v,1},2):1 %turn the loop around, so the indices are still available because only vlues in the matrix further on the back are removed
    
      if  r<nodes.neighboursOutRunning{v,2}(1,k) 
        %check if neighbour is parent
       if nodes.values(v,3)~=nodes.neighboursOutRunning{v,1}(1,k)
           u=nodes.neighboursOutRunning{v,1}(1,k);
           pos=nodes.neighboursInRunning{u,1}==v;
           
           if sum(pos)>0
           nodes.neighboursInRunning{u,1}(1,pos)=[];
           nodes.neighboursInRunning{u,2}(1,pos)=[];
           end
           nodes.neighboursOutRunning{v,1}(k)=[];
           nodes.neighboursOutRunning{v,2}(k)=[];
       end
      end

    
end

end

