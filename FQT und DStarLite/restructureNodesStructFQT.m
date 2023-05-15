function [nodes] = restructureNodesStructFQT(nodes)
%rearrange the neighbour data so, that it is in only one field of the
%struct
nodes.neighbours=cell(size(nodes.neighboursSameFrame));

for k=1:size(nodes.neighboursSameFrame,1)
    numFrame=size(nodes.neighboursSameFrame{k,1},2);
    numEqual=size(nodes.realNeighboursEqual{k,1},2);
    nodes.neighbours{k,1}=zeros(1,numFrame+numEqual);
    nodes.neighbours{k,2}=zeros(1,numFrame+numEqual);
    position=1;
    for u=1:numFrame
        nodes.neighbours{k,1}(1,position)=nodes.neighboursSameFrame{k,1}(1,u);
        nodes.neighbours{k,2}(1,position)=nodes.neighboursSameFrame{k,2}(1,u);
        position=position+1;
    end
    for w=1:numEqual
        nodes.neighbours{k,1}(1,position)=nodes.realNeighboursEqual{k,1}(1,w);
        nodes.neighbours{k,2}(1,position)=nodes.realNeighboursEqual{k,2}(1,w);
        position=position+1;
    end
end
nodes=rmfield(nodes,'realNeighboursEqual');
nodes=rmfield(nodes,'neighboursSameFrame');


end

