function [path,tree,km,successors,allNodes,openList] = DStarLiteMainReplanning(tree,startAdress,goalAdress,changedEdges,km,successors,allNodes,openList)
%Main loop of the D*Lite algorithm
%changed edges has the adresses of the start- and endnodes of the edge in
%the first two rows. In the third row the new cost is stored.
%nodes are built in columns like this: g,
%rhs,heuristic,key(1),key(2),

%calculating the whole path again, so the new start equals the old start.
%If another start is used km needs to be calculated differently(see paper on
%D*Lite)
km=km+calculateHeuristic(tree.states(startAdress,:),tree.states(startAdress,:)); %equals zero

for k=1:size(changedEdges,2)
    u=changedEdges(1,k);
    v=changedEdges(2,k);
    %Update cost of the edge and calculate cOld
    tempAdress=find(tree.neighbours{u,1}==v, 1);
    cOld=tree.neighbours{u,2}(tempAdress);
    tree.neighbours{u,2}(tempAdress)=changedEdges(3,k);
    
    %Update the edge cost for the successor if the neighbour is a
    %successor
    tempAdress=find(successors{u,1}==v, 1);
    if ~isempty(tempAdress)
        successors{u,2}(tempAdress)=changedEdges(3,k);
    end
    
    
    
    if false %cOld>changedNodes(3,k) %thats the case if objects are removed
        if false %changedNodes(1,k)~=goalAdress
            %In this row the real new distance is calculated, because
            %it is not Inf.
            allNodes(u,2)=min(allNodes(u,2),calculateHeuristics(tree.states(u,:),tree.states(tree.neighbours{u,1}(1,s)))+allNodes(tree.neighbours{u,1}(1,s),1));
        end
        
    elseif allNodes(u,2)==cOld+allNodes(v,1) %Node was consistent
        if u~=goalAdress
            [~,minSuccessorCost] = nextStep(successors{u,1:2},allNodes);
            allNodes(u,2)=minSuccessorCost;
        end
    end
    [~,openList,allNodes(u,:)]=updateVertex(u,km,openList,allNodes(u,:));
    
end

[successors,allNodes,openList]=computeShortestPath(km,startAdress,tree.neighbours,tree.states,tree.states(goalAdress,:),successors,allNodes,openList);

pathAdresses=startAdress;
path=tree.states(startAdress,:);
nextAdress=startAdress;
numNodes=size(allNodes,1);
pathLength=1;
while nextAdress ~=goalAdress
    if isempty(successors{nextAdress,1})
        path=[];
        disp('Kein Pfad gefunden. (D*Lite)')
        return
    end
    [nextAdress,~]=nextStep(successors{nextAdress,:},allNodes);
    path(end+1,:)=tree.states(nextAdress,:);
    pathAdresses(end+1,:)=nextAdress;
    pathLength=pathLength+1;
    if pathLength>numNodes
        path=[];
        disp('Kein Pfad gefunden. (D*Lite).')
        return
    end
end

if size(path,1)==1
    path=[];
end




end

