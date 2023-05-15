function [changedEdges] = detectChangedEdgesDStar(nodes,mapBinary,mapRes,validationDistance)

changedEdges=[];

for k=1:size(nodes.states,1)
    for s=1:size(nodes.neighbours{k,1},2)
        u=nodes.neighbours{k,1}(1,s);
        valid=motionValidatorBinary(nodes.states(k,:),nodes.states(u,:),mapBinary,mapRes,validationDistance);
        
        %check if path is invalid
        if ~valid
            changedEdges(1,end+1)=k;
            changedEdges(2,end)=u;
            changedEdges(3,end)=Inf;
            
        end
    end
end



end




