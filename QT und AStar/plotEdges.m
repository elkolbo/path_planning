function [] = plotEdges(states,neighbours)
%plot Edges of a Quadtree

for k=1:size(states,1)
    for v=1:size(neighbours{k,1},2)     
     if neighbours{k,2}(v)~=Inf
        plot([states(k,1) states(neighbours{k,1}(1,v),1)],[states(k,2) states(neighbours{k,1}(1,v),2)],'b')
     end
     end
   
end

