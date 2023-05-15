function [equalNeighbours,smallerNeighbours] = getAllNeighbours(SameSizeNeighbours,index)
%compute existing neigbours from same size neigbours
%   The function findNeighboursSameSize returns all same size neigbours of
%   a node. All of the 8 directions are searched. First it is checkend if a
%   neighbour in the same size exists. Then it is checked if a bigger
%   neighbour exists. Last it is checked, if smaller neighbours exist. The
%   smaller neighbours get passed in a different variable, because then the
%   the bigger square can be put as their neighbour.

global indexcodes_all
global indexcodes_occupied
equalNeighbours=[];
smallerNeighbours=[];
for k=1:8
    
    %Suchen, ob gleich große Nachbarn existieren
    tempindex=find(indexcodes_all==SameSizeNeighbours(k),1);
    if ~isempty(find(indexcodes_occupied==SameSizeNeighbours(k),1))
        continue
    end
    
    %Keine Eintraung, falls größere Nachbarn gefunden. Diese dienen nur als
    %Abrruchkriterium. Nachbarschaft wird bei Suche nach kleinerem Nachbarn
    %beidseitig eingetragen
    %Liegt in eine Richtung also ein größeres Element wird abgebrochen

    %Überprüfen, ob größerer Nachbar überhaupt existieren kann:
    
    [~,newdir]=newIndexAndDirection(index(end),k);
    
    
    if isempty(tempindex)
        if newdir~=9 %9 entspricht 'halt' und damit einer Richtung die innerhalb eines Elternquadrates sucht. Größere NAchbarn sind hier nicht möglich
            
            abbrechen=false;
            temp2=SameSizeNeighbours(k)/int64(10);
            while temp2~=0
                if ~isempty(find(indexcodes_all==temp2,1)) || ~isempty(find(indexcodes_occupied==temp2,1))
                    abbrechen=true;
                    break %Größerer Nachbar in dieser Richtung gefunden (belegt oder nicht belegt)
                end
                temp2=temp2/int64(10);
            end
            
            if abbrechen
                continue  %neue Richtung betrachten
            end
        end
        %Suche nach kleineren Nachbarn; je nach Richtung muss ein anderer Index
        %hinten angefügt werden. Z.B. wird ein rechter Nachbar gesucht muss an
        %den Suchindex eine 1 oder 3 angefügt werden
        
        
        undecidedSquares=SameSizeNeighbours(k);
        tempindex_small=[];
        while ~isempty(undecidedSquares)
            smallindex=checkAndReturnSmallerSquares(undecidedSquares,k);
            undecidedSquares=[];
            %überprüfen, ob die kleineren Quadrate existieren
            for v=1:length(smallindex)
                temp1=find(indexcodes_all==smallindex(v),1);
                
                if isempty(temp1)
                    undecidedSquares(end+1)=smallindex(v);
                    continue
                else
                    tempindex_small(end+1)=temp1;
                end
            end
            
            
            
        end
        smallerNeighbours=[smallerNeighbours tempindex_small];
    end
    
    
    equalNeighbours=[equalNeighbours tempindex];
    
    
    
    
end

