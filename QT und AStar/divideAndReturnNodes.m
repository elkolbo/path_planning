
function [nodesState,indexcodes_all,indexcodes_occupied] = divideAndReturnNodes(states,map,minRes,indexcode)
%recursive funtction to divide the space in even squares until they are
%completely vaild. Then the node in the middle of the squares is returned.
%There is a recursive function call of every quarter of the square.
nodesState=[];
indexcodes_all=[];
indexcodes_occupied=[];

divided=divideintosquares(states);

dividedmap=divideintosquares(map);

status=checkstatus(dividedmap.topleft,minRes);


if status==0
    indexcodetemp=indexcode*10+1;
    [newnodes, indexcodetemp, indexcodes_occupied_temp]=divideAndReturnNodes(divided.topleft,dividedmap.topleft,minRes,indexcodetemp);
    nodesState=[nodesState ; newnodes ];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
elseif status==1
    indexcodetemp=indexcode*10+1;
    indexcodes_all =[indexcodes_all; indexcodetemp];
    newnodes=getNodeFromValidSquare(divided.topleft);
    nodesState=[nodesState ;newnodes ];
elseif status==2
    indexcodetemp=indexcode*10+1;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end

status=checkstatus(dividedmap.topright,minRes);
if status==0
    indexcodetemp=indexcode*10+2;
     [newnodes, indexcodetemp, indexcodes_occupied_temp]=divideAndReturnNodes(divided.topright,dividedmap.topright,minRes,indexcodetemp);
    nodesState=[nodesState; newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
elseif status==1
    indexcodetemp=indexcode*10+2;
    indexcodes_all =[indexcodes_all; indexcodetemp];
    newnodes=getNodeFromValidSquare(divided.topright);
    nodesState=[nodesState ;newnodes ];
elseif status==2
    indexcodetemp=indexcode*10+2;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end



status=checkstatus(dividedmap.bottomleft,minRes);
if status==0
    indexcodetemp=indexcode*10+3;
     [newnodes, indexcodetemp, indexcodes_occupied_temp]= divideAndReturnNodes(divided.bottomleft,dividedmap.bottomleft,minRes,indexcodetemp);
    nodesState=[nodesState;newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
elseif status==1
    indexcodetemp=indexcode*10+3;
    indexcodes_all =[indexcodes_all; indexcodetemp];
    nodesState=[nodesState ;getNodeFromValidSquare(divided.bottomleft)];
elseif status==2
    indexcodetemp=indexcode*10+3;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end

status=checkstatus(dividedmap.bottomright,minRes);
if status==0
    indexcodetemp=indexcode*10+4;
     [newnodes, indexcodetemp, indexcodes_occupied_temp]= divideAndReturnNodes(divided.bottomright,dividedmap.bottomright,minRes,indexcodetemp);
    nodesState=[nodesState; newnodes];
    indexcodes_all =[indexcodes_all; indexcodetemp];
    indexcodes_occupied=[indexcodes_occupied; indexcodes_occupied_temp];
elseif status==1
    indexcodetemp=indexcode*10+4;
    indexcodes_all =[indexcodes_all; indexcodetemp];
    nodesState=[nodesState ;getNodeFromValidSquare(divided.bottomright)];
elseif status==2
    indexcodetemp=indexcode*10+4;
    indexcodes_occupied =[indexcodes_occupied; indexcodetemp];
end
end



