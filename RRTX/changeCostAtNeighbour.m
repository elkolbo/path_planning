function  [neighbours1cost,neighbours2cost,neighbours3cost,neighbours4cost]=changeCostAtNeighbour(u,v,neighbours1,neighbours2,neighbours3,neighbours4)
%Find the node v within the neighbours of u and change this edge cost to Inf

vIndex=find(neighbours1{1,1}==v, 1);

if ~isempty(vIndex)
    neighbours1{1,2}(vIndex)=Inf;
    neighbours1cost=neighbours1{1,2};
    neighbours2cost=neighbours2{1,2};
    neighbours3cost=neighbours3{1,2};
    neighbours4cost=neighbours4{1,2};
end


vIndex=find(neighbours2{1,1}==v, 1);

if ~isempty(vIndex)
    neighbours2{1,2}(vIndex)=Inf;
    neighbours1cost=neighbours1{1,2};
    neighbours2cost=neighbours2{1,2};
    neighbours3cost=neighbours3{1,2};
    neighbours4cost=neighbours4{1,2};
end


vIndex=find(neighbours3{1,1}==v, 1);

if ~isempty(vIndex)
    neighbours1{1,3}(vIndex)=Inf;
    neighbours1cost=neighbours1{1,2};
    neighbours2cost=neighbours2{1,2};
    neighbours3cost=neighbours3{1,2};
    neighbours4cost=neighbours4{1,2};
end


vIndex=find(neighbours4{1,1}==v, 1);

if ~isempty(vIndex)
    neighbours4{1,2}(vIndex)=Inf;
    neighbours1cost=neighbours1{1,2};
    neighbours2cost=neighbours2{1,2};
    neighbours3cost=neighbours3{1,2};
    neighbours4cost=neighbours4{1,2};
end

end

