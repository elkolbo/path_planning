function[lowestKey,adressOpenList] = top(openListKeys)
%calculate node with the lowest priority of all the nodes on the open list
%the key has two components: it is checked for k(1). If there are equals
%then k(2) is checked

lowestKey=min(openListKeys(:,1));
tempAdress=find(openListKeys(:,1)==lowestKey);

if length(tempAdress)>1
    [~,tempAdress1]=min(openListKeys(tempAdress,2));
    adressOpenList=tempAdress(tempAdress1);
else
    adressOpenList=tempAdress;
end
end

