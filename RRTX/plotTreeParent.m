function [] = plotTreeParent(nodes)
%Plot a RRT like structure
hold on
for k=2:size(nodes.states,1)
    if isnan(nodes.values(k,3))
        continue
    end
    
    plot([nodes.states(k,1),nodes.states(nodes.values(k,3),1)],[nodes.states(k,2),nodes.states(nodes.values(k,3),2)],'b')
    
end

end
