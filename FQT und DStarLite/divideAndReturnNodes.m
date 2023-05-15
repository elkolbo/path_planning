
function [nodesState,indexcodes_all,indexcodes_occupied,neighboursSameFrame] = divideAndReturnNodes(states,map,minRes,indexcode,maxIndexLength,minResFrame)
%recursive function to divide the space in even squares until they are
%completely vaild. Then the nodes of the frame are returned to the calling
%function. There is a recursive function call vor all four quarters. 
nodesState=[];
indexcodes_all=[];
indexcodes_occupied=[];
neighboursSameFrame={};

divided=divideintosquares(states);

dividedmap=divideintosquares(map);

status=checkstatus(dividedmap.topleft,minRes);
if status==0
    indexcodetemp=indexcode*10+1;
    [newnodes, indexcodetemp, indexcodes_occupied_temp,newNeighboursFrame]=divideAndReturnNodes(divided.topleft,dividedmap.topleft,minRes,indexcodetemp,maxIndexLength);
    nodesState=[nodesState ; newnodes ];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==1
    indexcodetemp=indexcode*10+1;
    [newnodes,indexcodetemp,newNeighboursFrame]=getFrame(indexcodetemp,maxIndexLength,divided.topleft,minRes);
    nodesState=[nodesState ;newnodes ];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==2
    indexcodetemp=indexcode*10+1;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end

status=checkstatus(dividedmap.topright,minRes);
if status==0
    indexcodetemp=indexcode*10+2;
    [newnodes, indexcodetemp, indexcodes_occupied_temp,newNeighboursFrame]=divideAndReturnNodes(divided.topright,dividedmap.topright,minRes,indexcodetemp,maxIndexLength);
    nodesState=[nodesState; newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==1
    indexcodetemp=indexcode*10+2;
    [newnodes,indexcodetemp,newNeighboursFrame]=getFrame(indexcodetemp,maxIndexLength,divided.topright,minRes);
    indexcodes_all =[indexcodes_all; indexcodetemp];
    nodesState=[nodesState ;newnodes ];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==2
    indexcodetemp=indexcode*10+2;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end



status=checkstatus(dividedmap.bottomleft,minRes);
if status==0
    indexcodetemp=indexcode*10+3;
    [newnodes, indexcodetemp, indexcodes_occupied_temp,newNeighboursFrame]= divideAndReturnNodes(divided.bottomleft,dividedmap.bottomleft,minRes,indexcodetemp,maxIndexLength);
    nodesState=[nodesState;newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==1
    indexcodetemp=indexcode*10+3;
    [newnodes,indexcodetemp,newNeighboursFrame]=getFrame(indexcodetemp,maxIndexLength,divided.bottomleft,minRes);
    indexcodes_all =[indexcodes_all; indexcodetemp];
    nodesState=[nodesState ;newnodes];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==2
    indexcodetemp=indexcode*10+3;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end

status=checkstatus(dividedmap.bottomright,minRes);
if status==0
    indexcodetemp=indexcode*10+4;
    [newnodes, indexcodetemp, indexcodes_occupied_temp,newNeighboursFrame]= divideAndReturnNodes(divided.bottomright,dividedmap.bottomright,minRes,indexcodetemp,maxIndexLength);
    nodesState=[nodesState; newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==1
    indexcodetemp=indexcode*10+4;
    [newnodes,indexcodetemp,newNeighboursFrame]=getFrame(indexcodetemp,maxIndexLength,divided.bottomright,minRes);
    indexcodes_all =[indexcodes_all; indexcodetemp];
    nodesState=[nodesState ;newnodes];
    
    %convert local neighbour adress of the same frame into an global adress
    adressAddition=size(neighboursSameFrame,1);
    newNeighboursFrame=cellfun(@(x) x+adressAddition,newNeighboursFrame,'UniformOutput',0);
    neighboursSameFrame=[neighboursSameFrame;newNeighboursFrame];
elseif status==2
    indexcodetemp=indexcode*10+4;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end
end



