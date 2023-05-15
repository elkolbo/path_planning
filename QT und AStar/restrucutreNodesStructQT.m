function [nodes] = restrucutreNodesStructQT(nodes)
%Restructure the structure so, that there is only one field containing all the
%neighbours

nodes.neighbours=cell(size(nodes.realNeighboursBigger));

for k=1:size(nodes.realNeighboursBigger,1)
    numBigger=size(nodes.realNeighboursBigger{k,1},2);
    numSmaller=size(nodes.realNeighboursSmaller{k,1},2);
    numEqual=size(nodes.realNeighboursEqual{k,1},2);
    nodes.neighbours{k,1}=zeros(1,numBigger+numSmaller+numEqual);
    nodes.neighbours{k,2}=zeros(1,numBigger+numSmaller+numEqual);
    position=1;
    for u=1:numBigger
        nodes.neighbours{k,1}(1,position)=nodes.realNeighboursBigger{k,1}(1,u);
        nodes.neighbours{k,2}(1,position)=nodes.realNeighboursBigger{k,2}(1,u);
        position=position+1;
    end
    for v=1:numSmaller
        nodes.neighbours{k,1}(1,position)=nodes.realNeighboursSmaller{k,1}(1,v);
        nodes.neighbours{k,2}(1,position)=nodes.realNeighboursSmaller{k,2}(1,v);
        position=position+1;
    end
    for w=1:numEqual
        nodes.neighbours{k,1}(1,position)=nodes.realNeighboursEqual{k,1}(1,w);
        nodes.neighbours{k,2}(1,position)=nodes.realNeighboursEqual{k,2}(1,w);
        position=position+1;
    end
end
nodes=rmfield(nodes,'realNeighboursBigger');
nodes=rmfield(nodes,'realNeighboursSmaller');
nodes=rmfield(nodes,'realNeighboursEqual');
nodes=rmfield(nodes,'neighboursSameSize');
end

