function [successors,allNodes,openList] = computeShortestPath(km,startAdress,neighbours,states,goal,successors,allNodes,openList)
%compute shortest path with D* Lite at the beginning or after edge costs
%change
%nodes are built in columns like this: g,rhs,heuristic,key(1),key(2)
%the search direction is from goal to start, so predecessors and successors are switched.


while allNodes(startAdress,2)>allNodes(startAdress,1) || topKey1(allNodes(openList,4))<calculateKey1(allNodes(startAdress,:),km) ||topKey2(allNodes(openList,5))<calculateKey2(allNodes(startAdress,:))  
    
    [k_old, currentNodeAdressOpenList]=top(allNodes(openList,4:5));
    currentNodeAdress=openList(currentNodeAdressOpenList,1);
    [k_new,newNodeValues]=calculateKey(allNodes(currentNodeAdress,:),km);
    
    if k_old<k_new(1)
       allNodes(currentNodeAdress,4:5)=newNodeValues(1,4:5);
    elseif allNodes(currentNodeAdress,1) > allNodes(currentNodeAdress,2)
        allNodes(currentNodeAdress,1)=allNodes(currentNodeAdress,2);
        openList(currentNodeAdressOpenList,:)=[];
        for k=1:size(neighbours{currentNodeAdress,1},2)
            s=neighbours{currentNodeAdress,1}(1,k);
            if states(s,1)~=goal(1) || states(s,2)~=goal(2)
                allNodes(s,2)=min([allNodes(s,2),neighbours{currentNodeAdress,2}(1,k)+allNodes(currentNodeAdress,1)]);
            end
            [validSuccessor,openList,allNodes(s,:)]=updateVertex(s,km,openList,allNodes(s,:));
            if validSuccessor
                successors{s,1}(1,end+1)=currentNodeAdress;
                successors{s,2}(1,end+1)=neighbours{currentNodeAdress,2}(1,k);
            end
        end
    else
        g_old=allNodes(currentNodeAdress,1);
        allNodes(currentNodeAdress,1)=Inf;
        numPred=size(neighbours{currentNodeAdress,1},2);
        for k=1:numPred+1
            if k==numPred+1
                s=currentNodeAdress;
                if allNodes(s,2)==g_old
                    if states(currentNodeAdress,1)~=goal(1) || states(currentNodeAdress,2)~=goal(2)
                        [~,allNodes(s,2)]=nextStep(successors{s,:},allNodes);
                    end
                end
                 [~,openList,allNodes(s,:)]=updateVertex(s,km,openList,allNodes(s,:));
                
            else
                s=neighbours{currentNodeAdress,1}(1,k);
                if allNodes(s,2)==neighbours{currentNodeAdress,2}(1,k)+g_old
                    if states(s,1)~=goal(1) || states(s,2)~=goal(2)
                        [~,allNodes(s,2)]=nextStep(successors{s,:},allNodes);
                    end
                end
                [~,openList,allNodes(s,:)]=updateVertex(s,km,openList,allNodes(s,:));
                
            end
          
        end
    end
    
end
end

