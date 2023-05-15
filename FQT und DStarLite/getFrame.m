function [states,frameIndices,neighboursSameFrame] = getFrame(index,maxIndexLength,states,minRes)
%Calculate the indies of the frame nodes. 
%smaller squares get formed, until the max index lenth is reached. Then the
%states in the corners are calculated. From these states the states of the
%frame are calculated by linear interpolating between the corners.
%Additionally every frame node gets an index to store its position within
%the frame to determine,which directions need to be searched. So the FSM is not called as often when
%calculating all neighbours and neighbours within the frame aren't
%identified again when calling getAllNeighbours.m
%The order of the directions is : R L D U RD RU LD LU 

indexR=index;
indexL=index;
indexD=index;
indexU=index;
while ceil(log10(indexR(1,1)))<maxIndexLength
    indexRtemp=[];
    indexLtemp=[];
    indexDtemp=[];
    indexUtemp=[];
    for k=1:size(indexR,1)
        indexRtemp(end+1:end+2,1)=[indexR(k)*10+2; indexR(k)*10+4];
        indexLtemp(end+1:end+2,1)=[indexL(k)*10+1; indexL(k)*10+3];
        indexDtemp(end+1:end+2,1)=[indexD(k)*10+3; indexD(k)*10+4];
        indexUtemp(end+1:end+2,1)=[indexU(k)*10+1; indexU(k)*10+2];
    end
    indexR=indexRtemp;
    indexL=indexLtemp;
    indexD=indexDtemp;
    indexU=indexUtemp;
    
    
end
frameSize=size(indexR,1);



[cornerRD] = getNodeFromValidSquare(states(1:minRes,end-minRes:end,:));
[cornerRU] = getNodeFromValidSquare(states(end-minRes:end,end-minRes:end,:));
[cornerLD] = getNodeFromValidSquare(states(1:minRes,1:minRes,:));
[cornerLU] = getNodeFromValidSquare(states(end-minRes:end,1:minRes,:));

statesR=zeros(frameSize,3);
statesL=zeros(frameSize,3);
statesD=zeros(frameSize,3);
statesU=zeros(frameSize,3);

for k=1:3
    statesR(:,k)=linspace(cornerRU(1,k),cornerRD(1,k),frameSize)';
    statesL(:,k)=linspace(cornerLU(1,k),cornerLD(1,k),frameSize)';
    statesD(:,k)=linspace(cornerLD(1,k),cornerRD(1,k),frameSize)';
    statesU(:,k)=linspace(cornerLU(1,k),cornerRU(1,k),frameSize)';
end

frameIndices=[indexR(2:end-1,1);indexL(2:end-1,1);indexD;indexU];
states=[statesR(2:end-1,:);statesL(2:end-1,:);statesD;statesU];

neighboursSameFrame=cell(4*frameSize-4,1);
allAdressesLocal=linspace(1,4*frameSize-4,4*frameSize-4);

for k=1:4*frameSize-4
    neighboursSameFrame{k,1}=[allAdressesLocal(1:k-1), allAdressesLocal(k+1:end)];
end

framePosition=[ones(frameSize-2,1); 2*ones(frameSize-2,1);7; 3*ones(frameSize-2,1);5;8; 4*ones(frameSize-2,1);6];

frameIndices(:,2)=framePosition;

end

