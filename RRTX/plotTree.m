function [] = plotTree(nodes)
%Plot a RRT like structure
hold on
for k=1:size(nodes.childs,1)
    for v=1:size(nodes.childs{k,1},2)
        
      plot([nodes.states(k,1),nodes.states(nodes.childs{k,1}(1,v),1)],[nodes.states(k,2),nodes.states(nodes.childs{k,1}(1,v),2)],'g')
       
    end
end

end

