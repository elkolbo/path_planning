function [map] = mapCreator(size,start,goal,res)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

map=randn(size*res)-0.03; %-, um mehr freien Raum zu erhalten

%Glätten, um kontinuierliche Strukturen zu erhalten
map=movmean(movmean(map,15,1),15,2);
map=movmean(movmean(map,5,1),5,2);
map=movmean(movmean(map,7,1),7,2);

%Freihalten von Start und Ziel
map(ceil(abs(start(2)*res-5:start(2)*res+5)+1),floor(abs(start(1)*res-5:start(1)*res+5)+1)) = 0;
map(ceil(abs(goal(2)*res-5:goal(2)*res+5)+1),floor(abs(goal(1)*res-5:goal(1)*res+5)+1)) = 0;

%Rand einfügen
map(1:8,:)=1;
map(end-8:end,:)=1;
map(:,1:8)=1;
map(:,end-8:end)=1;

%Umwandeln in boolsche Karte
map(map<0)=0;
map=flipud(logical(map));




end

